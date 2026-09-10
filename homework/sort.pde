 int [] data = new int [100];
 int max, temp, index, i, j;
 
 for (i = 0; i < data.length; i++) {
   data[i] = (int)random(500);
 }
 
 
 for (i = 0; i < data.length; i++) {
   max = index = -1;
   for (j = 0; j < data.length - i - 1; j++) {
     if(max < data[j]) {
     max = data[j];
     index = j;
     }
   }
   if (index != -1) {
     temp = data[j];
     data[j] = max;
     data[index] = temp;
    }
 }
 
 for (i = 0; i < data.length; i++) {
   print(data[i], " ");
 }
