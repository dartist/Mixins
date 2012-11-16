library StringTests;
import "DUnit.dart";
import "package:mixin/mixin.dart";

class MyListExtensions extends List$ {
  MyListExtensions(target) : super(target);
  int count(predicate) => target.filter(predicate).length;
  double avg() => sum() / length;
}

MixinTests () {

  module("Mixin");

  test('Mixin: registerFactory', (){
    Mixin.registerFactory((x) => x is List ? new MyListExtensions(x) : null);

    equal($([1,2,3,4,5]).count((n) => n.isOdd()), 3, 'can use custom extension');
    equal($([20,30,50,100]).avg(), 50, 'can use custom extension that uses base methods');

  });

  test("Mixin: mixin", () {
    Mixin.mixin({
      'myReverse': (string) => $($(string.splitChars()).reverse()).join('')
    });
    equal($('panacea').myReverse(), 'aecanap', 'mixed in a function to _');
//    equal($('test').myReverse(), 'tset', 'mixed in a function to _');
  });

}
