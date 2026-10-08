import java.util.ArrayList;

ArrayList<Array> lists;
Array list, plist;

int napTime = 100;
int len = 16;
int index = 0;
int loop = 0;

boolean autoFlag = true;

PFont f;

void setup() {
  size(900, 600);

  f = createFont("Arial", 24);
  textFont(f);

  run();
}

void draw() {
  background(200);

  list = lists.get(index);
  list.draw();

  fill(0);
  text("bubbleSort", 20, 40);

  text("(" + nf(list.i0, 2) + "," +
    nf(list.j0, 2) + ") - " +
    index + "/" + loop +
    " napTime:" + napTime + "(a/s)",
    20, height-20);

  if (autoFlag) {
    nextStep();
  }
}

void nextStep() {
  if (index == 0)
    delay(10 * napTime);
  else
    delay(napTime);

  if (index < loop)
    index++;
  else
    index = 0;
}

void keyPressed() {
  if (key == ' ') {
    autoFlag = !autoFlag;
  }
  else if (key == 'a') {
    if (napTime > 100)
      napTime -= 100;
  }
  else if (key == 's') {
    napTime += 100;
  }
  else if (key == CODED) {
    if (keyCode == LEFT) {
      if (index > 0)
        index--;
    }
    else if (keyCode == RIGHT) {
      if (index < loop)
        index++;
    }
  }
}

void mousePressed() {
  if (autoFlag)
    autoFlag = false;

  if (mouseButton == LEFT) {
    if (index > 0)
      index--;
  }
  else if (mouseButton == RIGHT) {
    if (index < loop)
      index++;
  }
}

void run() {
  loop = index = 0;

  lists = new ArrayList<Array>();
  lists.add(new Array(len, 0, -1));

  list = lists.get(0);
  list.printArray();

  bubbleSort();

  list = lists.get(loop);
  list.printArray();
}

// 버블 정렬
void bubbleSort() {
  int i, j;

  for (j = 0; j < len-1; j++) {

    plist = lists.get(loop);
    lists.add(new Array(len, plist.arr, j+1, 0));
    loop++;

    for (i = 0; i < len-j-1; i++) {

      plist = lists.get(loop);
      lists.add(new Array(len, plist.arr, j+1, i+1));
      loop++;

      list = lists.get(loop);

      if (list.arr[i] > list.arr[i+1]) {
        swap(list.arr, i, i+1);
      }
    }
  }
}

void swap(int[] arr, int i, int j) {
  int tmp = arr[j];
  arr[j] = arr[i];
  arr[i] = tmp;
}

// Array 클래스
class Array {
  int i0, j0, len, max, w;
  int[] arr;

  Array(int len, int i0, int j0) {
    max = 100;

    this.i0 = i0;
    this.j0 = j0;
    this.len = len;

    arr = new int[len];
    w = (width-4)/len;

    shuffle();
  }

  Array(int len, int[] arr, int i0, int j0) {
    max = 100;

    this.i0 = i0;
    this.j0 = j0;
    this.len = len;

    this.arr = new int[len];
    w = (width-4)/len;

    for (int i = 0; i < len; i++) {
      this.arr[i] = arr[i];
    }
  }

  void draw() {
    int x, y, h;

    for (int i = 0; i < len; i++) {

      if (j0 == i)
        fill(64);
      else
        fill(128);

      x = i*w+2;
      h = arr[i];
      y = height-5*h-60;

      rect(x, y, w, 5*h);
    }
  }

  void shuffle() {
    for (int i = 0; i < len; i++) {
      arr[i] = (int)random(max);
    }
  }

  void printArray() {
    print("(" + nf(i0, 2) + "," +
      nf(j0, 2) + ")- ");

    for (int i = 0; i < len; i++) {
      print(nf(arr[i], 2) + " ");
    }

    println();
  }
}
