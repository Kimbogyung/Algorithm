int [] arr;

void setup() {
  intArr(16);
  pirntArr();
  selectionSorting();
  pirntArr();
}

void intArr(int n) {
  int i;
  arr = new int[n];
  for(i = 0; i < arr.length; i++) {
    arr[i] = (int)random(100);
  }
}

void pirntArr() {
  int i;
   for (i = 0; i < arr.length; i++) {
   print(arr[i], " ");
  }
  println();
}

void selectionSorting() {
  int i, j, max, index, temp;
  for (i = 0; i < arr.length; i++) {
    max = index = 0;
    for (j = 0; j < arr.length-i; j++) {
      if (arr[j] > max) {
        index = j;
        max = arr[j];
      }
    }
    swap(index, arr.length-i-1);
    temp = arr[arr.length-i-1];
    arr[arr.length-i-1]=max;
    arr[index] = temp;
  }
}

void swap(int i, int j) {
  int temp;
  temp = arr[j];
  arr[j]= arr[i];
  arr[i] = temp;
}
  
