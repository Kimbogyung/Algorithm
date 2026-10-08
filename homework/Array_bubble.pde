Array a;

void setup() {
  size(800, 600);
  a = new Array(16, 0, 0);
  a.printArray();
}

void draw() {
  background(32);
  a.display();
}

void mousePressed() {
  a.bubbleSorting();
  a.printArray();
}

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

  void display() {
    int x, y, h;

    for (int i=0; i<len; i++) {
      if (j0 == i && i0 < len-1)
        fill(255, 100, 100);
      else
        fill(128);

      x = i*w+2;
      h = arr[i];
      y = height-5*h-60;

      rect(x, y, w, 5*h);
    }
  }

  void shuffle() {
    for (int i=0; i<len; i++) {
      arr[i] = (int)random(max);
    }
  }

  void printArray() {
    print("("+nf(i0,2)+","+nf(j0,2)+")- ");

    for (int i=0; i<len; i++) {
      print(nf(arr[i],2)+" ");
    }
    println();
  }

  void bubbleSorting() {
    int tmp;

    if (i0 >= len-1)
      return;

    if (arr[j0] > arr[j0+1]) {
      tmp = arr[j0];
      arr[j0] = arr[j0+1];
      arr[j0+1] = tmp;
    }

    j0++;

    if (j0 >= len-i0-1) {
      j0 = 0;
      i0++;
    }
  }
}
