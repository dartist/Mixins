import "Mixin.dart";

void main() {
  print("Hello World");

  List$ people = $([
    {'id':13,'name':'Tom','grade':'C'},
    {'id':11,'name':'Dick','grade':'B'},
    {'id':12,'name':'Harry','grade':'A'},
    {'id':10,'name':'Larry','grade':'B'}
  ]);

  List$ ids = $(people.pluck('id'));
  List$ grades = $(people.pluck('grade'));
  print("Min ${ids.min()} / Max ${ids.max()}");
  print("Reversed ${ids.reverse()}, Shuffled ${ids.shuffle()}");
  print("SortBy id: ${$(people.sortBy('id')).pluck('id')}, name: ${$(people.sortBy('name')).pluck('name')}");
  print("GroupBy ${people.groupBy('grade')}");
  print("First 2 ids ${ids.first(2)} / ${ids.first()}");
  print("Last 2 ids ${ids.last(2)} / ${ids.last()}");
  print("Rest ids ${ids.rest()} / ${ids.rest(2)}");
  print("Unique grades ${grades.uniq()})}");
  print("Range 5-10 ${Mixin.range(5,10)}, 2 step ${Mixin.range(5,10,2)}");
  $(3).times((i) => print("$i Time(s)"));
  print($([2,4,6]).join(" | "));

  Mixin.mixin({
    'greet': (str) => print("Hello $str!"),
    'upper': (str) => str.toUpperCase(),
    'mutliply': (a, b) => a * b,
  });

  $("Mixalot").greet();
  print("Can haz ${$("uppercase?").upper()}");
  var $2 = $(2);
  print("2x4 = ${$2.mutliply(4)}");

  Function x3 = (x) => x['id'] == 12;
  print("x3: ${x3(people[2])} | ${x3(people[3])} ");

  var harry = people.single((x) => x['id'] == 12);
  print("Found ${harry['name']}!");

  List$ list = $([1,5,10]);
  int sum = list.reduce((memo, value) => memo + value);
  int minus = list.reduce((memo, value) => memo - value);
  int minusRight = list.reduceRight((memo, value) => memo - value);

//  int sum = reduce([1,5,10],
//    (memo, value) => memo + value, 0);

  print("Sum is $sum == ${list.sum()}");
  print("Minus is $minus | $minusRight");
}
