
// =====================================================
//  Infix to Postfix Calculator using Stack (Processing)
//  - 중위식을 입력하고 Enter → 후위식 변환 + 계산
//  - 띄어쓰기 없이 입력해도 됨 (예: 3+5*(2-8))
//  - 지원: + - * / ^ ( ) , 여러 자리 수, 소수
// =====================================================
 
String input = "";       // 입력 중인 수식
String infixStr = "";    // 중위식 (보기 좋게 정리)
String postfixStr = "";  // 후위식
String resultStr = "";   // 계산 결과
String errorMsg = "";    // 오류 메시지
 
void setup() {
  size(720, 440);
  textFont(createFont(findKoreanFont(), 17));
}
 
// 한글 폰트 찾기 (Windows → Mac → 나눔고딕)
String findKoreanFont() {
  String[] candidates = { "Malgun Gothic", "맑은 고딕", "AppleSDGothicNeo-Regular",
                          "Apple SD Gothic Neo", "NanumGothic", "나눔고딕" };
  String[] installed = PFont.list();
  for (String c : candidates) {
    for (String f : installed) {
      if (f.equals(c)) return c;
    }
  }
  return "SansSerif";
}
 
void draw() {
  background(236, 241, 247);
 
  // 상단 제목 바
  noStroke();
  fill(52, 73, 120);
  rect(0, 0, width, 60);
  fill(255);
  textSize(20);
  text("스택을 이용한 중위 → 후위 계산기", 30, 38);
 
  // 안내 문구
  fill(80);
  textSize(15);
  text("수식을 입력한 뒤 Enter를 누르세요.  예) 3+5*(2-8)", 30, 95);
 
  // 입력창
  stroke(52, 73, 120);
  strokeWeight(2);
  fill(255);
  rect(30, 110, width - 60, 44, 10);
  noStroke();
  fill(30);
  textSize(18);
  String cursor = (frameCount / 30) % 2 == 0 ? "|" : "";
  text(input + cursor, 45, 139);
 
  // 결과 카드
  fill(255);
  rect(30, 180, width - 60, 190, 12);
 
  textSize(15);
  fill(120);
  text("중위 표기식 (Infix)", 50, 215);
  text("후위 표기식 (Postfix)", 50, 270);
  text("계산 결과", 50, 325);
 
  textSize(19);
  fill(40);
  text(infixStr, 240, 215);
  fill(40, 120, 90);
  text(postfixStr, 240, 270);
  fill(200, 90, 30);
  text(resultStr, 240, 325);
 
  // 오류 메시지
  if (errorMsg.length() > 0) {
    fill(210, 50, 50);
    textSize(15);
    text("오류: " + errorMsg, 30, 395);
  }
 
  // 도움말
  fill(140);
  textSize(12);
  text("Enter: 계산    Backspace: 한 글자 삭제    Delete: 전체 지우기", 30, height - 15);
}
 
// ---------------- 키 입력 ----------------
void keyPressed() {
  if (key == CODED) return;
 
  if (key == ENTER || key == RETURN) {
    calculate();
  } else if (key == BACKSPACE) {
    if (input.length() > 0) input = input.substring(0, input.length() - 1);
  } else if (key == DELETE) {
    input = "";
    infixStr = postfixStr = resultStr = errorMsg = "";
  } else if ("0123456789.+-*/^() ".indexOf(key) >= 0) {
    input += key;
  }
}
 
void calculate() {
  infixStr = postfixStr = resultStr = errorMsg = "";
  try {
    ArrayList<String> tokens = tokenize(input);
    infixStr = join(tokens.toArray(new String[0]), " ");
 
    ArrayList<String> postfix = infixToPostfix(tokens);
    postfixStr = join(postfix.toArray(new String[0]), " ");
 
    resultStr = formatNum(evaluatePostfix(postfix));
  } catch (RuntimeException e) {
    errorMsg = e.getMessage();
  }
}
 
// ---------------- 1. 토큰 분리 ----------------
ArrayList<String> tokenize(String expr) {
  ArrayList<String> tokens = new ArrayList<String>();
  int i = 0;
  while (i < expr.length()) {
    char c = expr.charAt(i);
    if (c == ' ') {
      i++;
    } else if (Character.isDigit(c) || c == '.') {
      String num = "";
      while (i < expr.length() && (Character.isDigit(expr.charAt(i)) || expr.charAt(i) == '.')) {
        num += expr.charAt(i);
        i++;
      }
      tokens.add(num);
    } else if ("+-*/^()".indexOf(c) >= 0) {
      tokens.add(str(c));
      i++;
    } else {
      throw new RuntimeException("잘못된 문자: " + c);
    }
  }
  if (tokens.isEmpty()) throw new RuntimeException("수식이 비어 있습니다");
  return tokens;
}
 
// ---------------- 2. 중위식 → 후위식 (연산자 스택) ----------------
ArrayList<String> infixToPostfix(ArrayList<String> tokens) {
  ArrayList<String> output = new ArrayList<String>();
  Stack stack = new Stack();
 
  for (String t : tokens) {
    if (isNumber(t)) {
      output.add(t);                       // 숫자는 바로 출력
    } else if (t.equals("(")) {
      stack.push(t);                       // 여는 괄호는 push
    } else if (t.equals(")")) {
      // 여는 괄호가 나올 때까지 pop
      while (!stack.isEmpty() && !stack.peek().equals("(")) {
        output.add(stack.pop());
      }
      if (stack.isEmpty()) throw new RuntimeException("괄호 짝이 맞지 않습니다");
      stack.pop();                         // "(" 제거
    } else {
      // 스택 top의 우선순위가 더 높거나 같으면 먼저 pop (^는 오른쪽 결합)
      while (!stack.isEmpty() && !stack.peek().equals("(")
             && (prec(stack.peek()) > prec(t)
                 || (prec(stack.peek()) == prec(t) && !t.equals("^")))) {
        output.add(stack.pop());
      }
      stack.push(t);
    }
  }
 
  // 남은 연산자 모두 pop
  while (!stack.isEmpty()) {
    String op = stack.pop();
    if (op.equals("(")) throw new RuntimeException("괄호 짝이 맞지 않습니다");
    output.add(op);
  }
  return output;
}
 
// ---------------- 3. 후위식 계산 (피연산자 스택) ----------------
double evaluatePostfix(ArrayList<String> postfix) {
  Stack stack = new Stack();
  for (String t : postfix) {
    if (isNumber(t)) {
      stack.push(t);
    } else {
      if (stack.size() < 2) throw new RuntimeException("잘못된 수식입니다");
      double b = Double.parseDouble(stack.pop());  // 오른쪽 피연산자
      double a = Double.parseDouble(stack.pop());  // 왼쪽 피연산자
      stack.push(String.valueOf(applyOp(a, b, t)));
    }
  }
  if (stack.size() != 1) throw new RuntimeException("잘못된 수식입니다");
  return Double.parseDouble(stack.pop());
}
 
double applyOp(double a, double b, String op) {
  if (op.equals("+")) return a + b;
  if (op.equals("-")) return a - b;
  if (op.equals("*")) return a * b;
  if (op.equals("/")) {
    if (b == 0) throw new RuntimeException("0으로 나눌 수 없습니다");
    return a / b;
  }
  if (op.equals("^")) return Math.pow(a, b);
  throw new RuntimeException("알 수 없는 연산자: " + op);
}
 
// ---------------- 유틸 ----------------
int prec(String op) {
  if (op.equals("^")) return 3;
  if (op.equals("*") || op.equals("/")) return 2;
  if (op.equals("+") || op.equals("-")) return 1;
  return 0;
}
 
boolean isNumber(String t) {
  try {
    Double.parseDouble(t);
    return true;
  } catch (NumberFormatException e) {
    return false;
  }
}
 
// 정수면 소수점 없이, 아니면 소수 넷째 자리까지
String formatNum(double v) {
  if (v == Math.floor(v) && !Double.isInfinite(v)) return String.valueOf((long) v);
  return nf((float) v, 0, 4);
}
 
// ---------------- 배열로 만든 Stack 클래스 ----------------
class Stack {
  String[] data = new String[16];
  int top = -1;
 
  void push(String s) {
    if (top == data.length - 1) data = (String[]) expand(data, data.length * 2);
    data[++top] = s;
  }
 
  String pop() {
    if (isEmpty()) throw new RuntimeException("스택이 비어 있습니다");
    return data[top--];
  }
 
  String peek() {
    if (isEmpty()) throw new RuntimeException("스택이 비어 있습니다");
    return data[top];
  }
 
  boolean isEmpty() { return top == -1; }
  int size()        { return top + 1; }
}
