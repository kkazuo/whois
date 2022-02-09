List chunkArray(List array, int size) {
  // var chunkedArray = List. Array(Math.ceil(array.length / size));
  var chunkedArray = [];
  var chunkedArrayLenght = (array.length / size).ceil();

  for (var i = 0; i < chunkedArrayLenght; i++) {
    final sliceIndex = i * size;
    chunkedArray[i] = array.getRange(sliceIndex, sliceIndex + size);
  }

  return chunkedArray;
}
