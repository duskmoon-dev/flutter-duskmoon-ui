/// The smallest encompassing edit, avoiding boundaries inside surrogate pairs.
({int start, int oldEnd, int newEnd}) sourceEdit(String old, String next) {
  var start = 0;
  final limit = old.length < next.length ? old.length : next.length;
  while (start < limit && old.codeUnitAt(start) == next.codeUnitAt(start)) {
    start++;
  }
  if (start > 0 &&
      start < old.length &&
      _low(old.codeUnitAt(start)) &&
      _high(old.codeUnitAt(start - 1))) {
    start--;
  }
  var oldEnd = old.length;
  var newEnd = next.length;
  while (oldEnd > start &&
      newEnd > start &&
      old.codeUnitAt(oldEnd - 1) == next.codeUnitAt(newEnd - 1)) {
    oldEnd--;
    newEnd--;
  }
  if (oldEnd < old.length &&
      oldEnd > start &&
      _low(old.codeUnitAt(oldEnd)) &&
      _high(old.codeUnitAt(oldEnd - 1))) {
    oldEnd++;
    newEnd++;
  }
  return (start: start, oldEnd: oldEnd, newEnd: newEnd);
}

bool _low(int unit) => unit >= 0xdc00 && unit <= 0xdfff;
bool _high(int unit) => unit >= 0xd800 && unit <= 0xdbff;

({int row, int column}) sourcePoint(String source, int offset) {
  var row = 0;
  var last = -1;
  for (var i = 0; i < offset; i++) {
    if (source.codeUnitAt(i) == 10) {
      row++;
      last = i;
    }
  }
  return (row: row, column: offset - last - 1);
}
