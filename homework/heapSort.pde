int[] arr;

void setup() {
  intArr(16);
  printArr();
  heapSorting();
  printArr();
}

void intArr(int n) {
  int i;
  arr = new int[n];
  
  for(i=0; i<arr.length; i++) {
    arr[i] = (int) random(100);
  }
}

void printArr() {
  int i;
  
  for(i=0; i<arr.length; i++) {
    print(arr[i], " ");
  }
  println();
}

void heapSorting() {
  int i, tmp;
  
  // 최대 힙 만들기
  for(i=arr.length/2-1; i>=0; i--) {
    heapify(arr.length, i);
  }
  
  // 가장 큰 값을 뒤로 보내면서 정렬
  for(i=arr.length-1; i>0; i--) {
    tmp = arr[0];
    arr[0] = arr[i];
    arr[i] = tmp;
    
    heapify(i, 0);
  }
}

void heapify(int n, int i) {
  int largest, left, right, tmp;
  
  largest = i;
  left = 2*i+1;
  right = 2*i+2;
  
  if(left < n && arr[left] > arr[largest]) {
    largest = left;
  }
  
  if(right < n && arr[right] > arr[largest]) {
    largest = right;
  }
  
  if(largest != i) {
    tmp = arr[i];
    arr[i] = arr[largest];
    arr[largest] = tmp;
    
    heapify(n, largest);
  }
}
