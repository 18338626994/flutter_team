
Iterable<int> naturalsTo(int n) sync* {
  int k = 0;
  while (k < n) yield k++;
}

Stream<int> asynchronousNaturalsTo(int n) async* {
  int k = 0;
  while (k < n) yield k++;
}

test () async{
  asynchronousNaturalsTo(10).listen((value){
    print(value);
  });
}

void main() {
  // print(naturalsTo(10));
  test();
}