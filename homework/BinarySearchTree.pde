
int n = 8;
int xstep = 400;
int ystep = 65;
int radius = 34;

int mode = 0;
int traversal = 0;
int textcolor = 0;

PFont font;
BTree tree = new BTree();

String message = "";
String traversalResult = "";

void setup() {
  size(1200, 600);

  font = createFont("Arial", 16);
  textFont(font);
  textAlign(CENTER, CENTER);

  stroke(192, 0, 0);

  newTree();
}

void draw() {
  drawTree();
}

// 마우스 클릭
void mousePressed() {
  int value = (int)(100.0 * mouseX / width);

  if (mouseButton == LEFT) {

    // Insert
    if (mode == 0) {
      if (tree.insert(value))
        message = "Inserted: " + value;
      else
        message = "Already exists: " + value;
    }

    // Delete
    else if (mode == 1) {
      tree.findNode();

      if (tree.value != -1) {
        int target = tree.value;
        tree.remove(target);
        message = "Deleted: " + target;
      } else {
        message = "Click a node to delete";
      }
    }

    // Search
    else if (mode == 2) {
      tree.findNode();

      if (tree.value != -1)
        value = tree.value;

      if (tree.contains(value))
        message = "Found: " + value;
      else
        message = "Not found: " + value;
    }
  }
}

// 키보드 입력
void keyPressed() {

  // 삽입
  if (key == 'i') {
    mode = 0;
    message = "INSERT MODE";
  }

  // 삭제
  else if (key == 'd') {
    mode = 1;
    message = "DELETE MODE";
  }

  // 검색
  else if (key == 's') {
    mode = 2;
    message = "SEARCH MODE";
  }

  // 중위 순회
  else if (key == '1') {
    traversal = 0;
    tree.printTree();
  }

  // 전위 순회
  else if (key == '2') {
    traversal = 1;
    tree.printTree();
  }

  // 후위 순회
  else if (key == '3') {
    traversal = 2;
    tree.printTree();
  }

  // 트리 초기화
  else if (key == 'c') {
    tree.clear();
    traversalResult = "";
    message = "Tree cleared";
  }

  // 새로운 트리 생성
  else if (key == 'b') {
    newTree();
  }

  // 트리 출력
  else if (key == 'v' || key == ' ') {
    tree.printTree();
  }
}

// 새로운 트리 생성
void newTree() {
  tree.clear();

  for (int i = 0; i < n; i++) {
    tree.insert((int)random(99));
  }

  message = "New tree created";
  traversalResult = "";
}

// 화면 출력
void drawTree() {
  background(200);

  tree.assignPosition();
  tree.drawTree();

  drawMode();
}

// 상태 표시
void drawMode() {
  fill(0);
  textAlign(LEFT, CENTER);
  textSize(18);

  if (mode == 0)
    text("MODE: INSERT", 20, 30);
  else if (mode == 1)
    text("MODE: DELETE", 20, 30);
  else if (mode == 2)
    text("MODE: SEARCH", 20, 30);

  textSize(15);

  text("i:Insert  d:Delete  s:Search", 20, 480);
  text("1:Inorder  2:Preorder  3:Postorder", 20, 505);
  text("c:Clear  b:New Tree  v:Print", 20, 530);

  text(message, 20, 455);
  text(traversalResult, 20, 565);

  textAlign(CENTER, CENTER);
}

// 이진 탐색 트리
class BTree {

  Node root;
  int x, y, value, index;

  void clear() {
    root = null;
    value = -1;
  }

  boolean isEmpty() {
    return root == null;
  }

  // SEARCH
  boolean contains(int in) {
    return contains(in, root);
  }

  boolean contains(int in, Node curr) {
    if (curr == null)
      return false;

    if (in < curr.val)
      return contains(in, curr.left);

    else if (in > curr.val)
      return contains(in, curr.right);

    else
      return true;
  }

  // INSERT
  boolean insert(int in) {
    if (contains(in))
      return false;

    root = insert(in, root);
    return true;
  }

  Node insert(int in, Node curr) {
    if (curr == null)
      return new Node(in);

    if (in < curr.val)
      curr.left = insert(in, curr.left);

    else if (in > curr.val)
      curr.right = insert(in, curr.right);

    return curr;
  }

  // DELETE
  void remove(int in) {
    root = remove(in, root);
  }

  Node remove(int in, Node curr) {

    if (curr == null)
      return null;

    if (in < curr.val)
      curr.left = remove(in, curr.left);

    else if (in > curr.val)
      curr.right = remove(in, curr.right);

    else {

      // 자식이 없는 경우
      if (curr.left == null && curr.right == null)
        return null;

      // 오른쪽 자식만 있는 경우
      if (curr.left == null)
        return curr.right;

      // 왼쪽 자식만 있는 경우
      if (curr.right == null)
        return curr.left;

      // 자식이 둘 다 있는 경우
      Node temp = findMin(curr.right);
      curr.val = temp.val;
      curr.right = remove(temp.val, curr.right);
    }

    return curr;
  }

  Node findMin(Node curr) {
    if (curr == null)
      return null;

    while (curr.left != null)
      curr = curr.left;

    return curr;
  }

  Node findMax(Node curr) {
    if (curr == null)
      return null;

    while (curr.right != null)
      curr = curr.right;

    return curr;
  }

  // 트리 높이
  int treeHeight(Node curr) {
    if (curr == null)
      return -1;

    return 1 + max(
      treeHeight(curr.left),
      treeHeight(curr.right)
    );
  }

  // 노드 위치 계산
  void assignPosition() {
    if (!isEmpty())
      assignPosition(root, 0, 0);
  }

  void assignPosition(Node curr, float dx, float dy) {
    if (curr != null) {

      assignPosition(
        curr.left,
        dx - 1.0 / pow(2.0, dy + 1),
        dy + 1
      );

      curr.x = dx;
      curr.y = dy;

      assignPosition(
        curr.right,
        dx + 1.0 / pow(2.0, dy + 1),
        dy + 1
      );
    }
  }

  // 순회 출력
  void printTree() {
    index = 0;
    traversalResult = "";

    if (isEmpty()) {
      println("The tree is empty");
      return;
    }

    if (traversal == 0)
      traversalResult = "Inorder: ";

    else if (traversal == 1)
      traversalResult = "Preorder: ";

    else if (traversal == 2)
      traversalResult = "Postorder: ";

    printTree(root);

    println(traversalResult);
  }

  void printTree(Node curr) {
    if (curr == null)
      return;

    // INORDER
    if (traversal == 0) {
      printTree(curr.left);
      visit(curr);
      printTree(curr.right);
    }

    // PREORDER
    else if (traversal == 1) {
      visit(curr);
      printTree(curr.left);
      printTree(curr.right);
    }

    // POSTORDER
    else if (traversal == 2) {
      printTree(curr.left);
      printTree(curr.right);
      visit(curr);
    }
  }

  void visit(Node curr) {
    traversalResult += curr.val + " ";
    index++;
  }

  // 마우스로 노드 검색
  void findNode() {
    x = y = value = -1;

    if (!isEmpty())
      findNode(root);
  }

  void findNode(Node curr) {
    if (curr == null)
      return;

    findNode(curr.left);

    int dx = mouseX -
      (int)(curr.x * xstep + width/2);

    int dy = mouseY -
      (int)(curr.y * ystep + radius);

    if (dx*dx + dy*dy < radius*radius/4) {
      x = (int)(curr.x * xstep + width/2);
      y = (int)(curr.y * ystep + radius);
      value = curr.val;
      return;
    }

    findNode(curr.right);
  }

  // 트리 그리기
  void drawTree() {
    if (!isEmpty()) {
      drawTreeLine(root);
      drawTree(root);
    }
  }

  // 노드 연결선
  void drawTreeLine(Node curr) {
    if (curr == null)
      return;

    if (curr.left != null) {
      line(
        curr.x*xstep + width/2,
        curr.y*ystep + radius,
        curr.left.x*xstep + width/2,
        curr.left.y*ystep + radius
      );
    }

    if (curr.right != null) {
      line(
        curr.x*xstep + width/2,
        curr.y*ystep + radius,
        curr.right.x*xstep + width/2,
        curr.right.y*ystep + radius
      );
    }

    drawTreeLine(curr.left);
    drawTreeLine(curr.right);
  }

  // 노드 그리기
  void drawTree(Node curr) {
    if (curr == null)
      return;

    drawTree(curr.left);

    fill(255);

    ellipse(
      curr.x*xstep + width/2,
      curr.y*ystep + radius,
      radius,
      radius
    );

    if (textcolor == 0)
      fill(0);
    else
      fill(255);

    text(
      curr.val,
      curr.x*xstep + width/2,
      curr.y*ystep + radius
    );

    drawTree(curr.right);
  }
}

// 노드 클래스
class Node {

  int val;
  float x, y;

  Node left;
  Node right;

  Node(int v) {
    val = v;
  }

  Node(int v, Node l, Node r) {
    val = v;
    left = l;
    right = r;
  }

  public String toString() {
    if (left == null && right == null)
      return "N(" + val + ")";

    return "N(" + val + ", " + left + ", " + right + ")";
  }
}
