#library("ArrayTests");
#import("dart:json");
#import("../DUnit.dart");
#import("../Mixin.dart");

ArrayTests() {

module("Arrays");

test("arrays: first", () {  
  equal($([1,2,3]).first(), 1, 'can pull out the first element of an array');
  equal($($([1,2,3]).first(0)).join(', '), "", 'can pass an index to first');
  equal($($([1,2,3]).first(2)).join(', '), '1, 2', 'can pass an index to first');
  equal($($([1,2,3]).first(5)).join(', '), '1, 2, 3', 'can pass an index to first');
  var result = ((args) => $(args).first())([4, 3, 2, 1]);
  equal(result, 4, 'works on an arguments object.');
  result = $([[1,2,3],[1,2,3]]).map((x) => $(x).first());
  equal($(result).join(','), '1,1', 'works well with _.map');
  result = (() => $([1,2,3]).take(2))();
  equal($(result).join(','), '1,2', 'aliased as take');
});

test("arrays: rest", () {
  List numbers = [1, 2, 3, 4];
  equal($($(numbers).rest()).join(", "), "2, 3, 4", 'working rest()');
  equal($($(numbers).rest(0)).join(", "), "1, 2, 3, 4", 'working rest(0)');
  equal($($(numbers).rest(2)).join(', '), '3, 4', 'rest can take an index');
  var result = ((args) => $(args).tail())([1, 2, 3, 4]);
  equal($(result).join(', '), '2, 3, 4', 'aliased as tail and works on arguments object');
  result = $([[1,2,3],[1,2,3]]).map((x) => $(x).rest());
  equal($($(result).flatten()).join(','), '2,3,2,3', 'works well with _.map');
});

test("arrays: initial", () {
  equal($($([1,2,3,4,5]).initial()).join(", "), "1, 2, 3, 4", 'working initial()');
  equal($($([1,2,3,4]).initial(2)).join(", "), "1, 2", 'initial can take an index');
  var result = ((args) => $(args).initial())([1, 2, 3, 4]);
  equal($(result).join(", "), "1, 2, 3", 'initial works on arguments object');
  result = $([[1,2,3],[1,2,3]]).map((x) => $(x).initial());
  equal($($(result).flatten()).join(','), '1,2,1,2', 'initial works with _.map');
});

test("arrays: last", () {
  equal($([1,2,3]).last(), 3, 'can pull out the last element of an array');
  equal($($([1,2,3]).last(0)).join(', '), "", 'can pass an index to last');
  equal($($([1,2,3]).last(2)).join(', '), '2, 3', 'can pass an index to last');
  equal($($([1,2,3]).last(5)).join(', '), '1, 2, 3', 'can pass an index to last');
  var result = ((args) => $(args).last())([1, 2, 3, 4]);
  equal(result, 4, 'works on an arguments object');
  result = $([[1,2,3],[1,2,3]]).map((x) => $(x).last());
  equal($(result).join(','), '3,3', 'works well with _.map');
});

test("arrays: compact", () {
  equal($([0, 1, false, 2, false, 3]).compact().length, 3, 'can trim out all falsy values');
  var result = ((args) => $(args).compact().length)([0, 1, false, 2, false, 3]);
  equal(result, 3, 'works on an arguments object');
});

test("arrays: flatten", () {
  var list = [1, [2], [3, [[[4]]]]];
  equal(JSON.stringify($(list).flatten()), '[1,2,3,4]', 'can flatten nested arrays');
  equal(JSON.stringify($(list).flatten(true)), '[1,2,3,[[[4]]]]', 'can shallowly flatten nested arrays');
  var result = ((args) => $(args).flatten())([1, [2], [3, [[[4]]]]]);
  equal(JSON.stringify(result), '[1,2,3,4]', 'works on an arguments object');
});

test("arrays: without", function() {
  List list = [1, 2, 1, 0, 3, 1, 4];
  equal($($(list).without([0, 1])).join(', '), '2, 3, 4', 'can remove all instances of an object');
  var result = ((args) => $(args).without([0, 1]))([1, 2, 1, 0, 3, 1, 4]);
  equal($(result).join(', '), '2, 3, 4', 'works on an arguments object');

  list = [{'one': 1}, {'two': 2}];
  ok($(list).without([{'one': 1}]).length == 2, 'uses real object identity for comparisons.');
  ok($(list).without([list[0]]).length == 1, 'ditto.');
});

test("arrays: uniq", () {
  List list = [1, 2, 1, 3, 1, 4];
  equal($($(list).uniq()).join(', '), '1, 2, 3, 4', 'can find the unique values of an unsorted array');

  list = [1, 1, 1, 2, 2, 3];
  equal($($(list).uniq(true)).join(', '), '1, 2, 3', 'can find the unique values of a sorted array faster');

  list = [{'name':'moe'}, {'name':'curly'}, {'name':'larry'}, {'name':'curly'}];
  var iterator = (value) => value['name'];
  equal($($($(list).uniq(false, iterator)).map(iterator)).join(', '), 'moe, curly, larry', 'can find the unique values of an array using a custom iterator');

  iterator = (value) => value +1;
  list = [1, 2, 2, 3, 4, 4];
  equal($($(list).uniq(true, iterator)).join(', '), '1, 2, 3, 4', 'iterator works with sorted array');

  var result = ((args) => $(args).uniq())([1, 2, 1, 3, 1, 4]);
  equal($(result).join(', '), '1, 2, 3, 4', 'works on an arguments object');

  list = [null,null,2,2,5,5,8,8,null,null,"hi"];
//no sparse arrays
//  list[2] = list[3] = null;
//  list[8] = 2;
//  list[10] = 2;
//  list[11] = 5;
//  list[14] = 5;
//  list[16] = 8;
//  list[19] = 8;
//  list[26] = list[29] = null; //no undefined
//  list[33] = "hi";

  result = $(list).uniq();
  deepEqual(result, [null, 2, 5, 8, "hi"], "Works with sorted sparse arrays where `undefined` elements are elided");
  equal(result.length, 5, "The resulting array should not be sparse");
});

test("arrays: intersection", () {
  List stooges = ['moe', 'curly', 'larry'], leaders = ['moe', 'groucho'];
  equal($($(stooges).intersection([leaders])).join(''), 'moe', 'can take the set intersection of two arrays');
  equal($($(stooges).intersection([leaders])).join(''), 'moe', 'can perform an OO-style intersection');
  var result = ((args) => $(args).intersection([leaders]))(['moe', 'curly', 'larry']);
  equal($(result).join(''), 'moe', 'works on an arguments object');
});

test("arrays: union", function() {
  var result = $([1, 2, 3]).union([[2, 30, 1], [1, 40]]);
  equal($(result).join(' '), '1 2 3 30 40', 'takes the union of a list of arrays');

  result = $([1, 2, 3]).union([[2, 30, 1], [1, 40, [1]]]);
  equal($(result).join(' '), '1 2 3 30 40 [1]', 'takes the union of a list of nested arrays');
});

test("arrays: difference", () {
  var result = $([1, 2, 3]).difference([[2, 30, 40]]);
  equal($(result).join(' '), '1 3', 'takes the difference of two arrays');

  result = $([1, 2, 3, 4]).difference([[2, 30, 40], [1, 11, 111]]);
  equal($(result).join(' '), '3 4', 'takes the difference of three arrays');
});

test('arrays: zip', () {
  var names = ['moe', 'larry', 'curly'], ages = [30, 40, 50], leaders = [true];
  var stooges = $List.zip([names, ages, leaders]);
  equal($String.debugString(stooges), 'moe,30,true,larry,40,,curly,50,', 'zipped together arrays of different lengths');
});

test("arrays: indexOf", () {
  var numbers = [1, 2, 3];
// Can't replace readonly fns  
//  numbers.indexOf = null;
//  equal($(numbers).indexOf(2), 1, 'can compute indexOf, even without the native function');
  var result = ((args) => $(args).indexOf(2))([1, 2, 3]);
  equal(result, 1, 'works on an arguments object');
  equal($(null).indexOf(2), -1, 'handles nulls properly');

  numbers = [10, 20, 30, 40, 50];
  var num = 35;
  var index = $(numbers).indexOf(num);
  equal(index, -1, '35 is not in the list');

  numbers = [10, 20, 30, 40, 50];
  num = 40;
  index = $(numbers).indexOf(num);
  equal(index, 3, '40 is in the list');

  numbers = [1, 40, 40, 40, 40, 40, 40, 40, 50, 60, 70]; 
  num = 40;
  index = $(numbers).indexOf(num);
  equal(index, 1, '40 is in the list');
});

test("arrays: lastIndexOf", () {
  var numbers = [1, 0, 1, 0, 0, 1, 0, 0, 0];
//  numbers.lastIndexOf = null;
//  equal(_.lastIndexOf(numbers, 1), 5, 'can compute lastIndexOf, even without the native function');
  equal($(numbers).lastIndexOf(0), 8, 'lastIndexOf the other element');
  var result = ((args) => $(args).lastIndexOf(1))([1, 0, 1, 0, 0, 1, 0, 0, 0]);
  equal(result, 5, 'works on an arguments object');
  equal($(null).indexOf(2), -1, 'handles nulls properly');
});

test("arrays: range", () {
  equal($(Mixin.range()).join(''), '', 'range with 0 as a first argument generates an empty array');
  equal($(Mixin.range(4)).join(' '), '0 1 2 3', 'range with a single positive argument generates an array of elements 0,1,2,...,n-1');
  equal($(Mixin.range(5, 8)).join(' '), '5 6 7', 'range with two arguments a &amp; b, a&lt;b generates an array of elements a,a+1,a+2,...,b-2,b-1');
  equal($(Mixin.range(8, 5)).join(''), '', 'range with two arguments a &amp; b, b&lt;a generates an empty array');
  equal($(Mixin.range(3, 10, 3)).join(' '), '3 6 9', 'range with three arguments a &amp; b &amp; c, c &lt; b-a, a &lt; b generates an array of elements a,a+c,a+2c,...,b - (multiplier of a) &lt; c');
  equal($(Mixin.range(3, 10, 15)).join(''), '3', 'range with three arguments a &amp; b &amp; c, c &gt; b-a, a &lt; b generates an array with a single element, equal to a');
  equal($(Mixin.range(12, 7, -2)).join(' '), '12 10 8', 'range with three arguments a &amp; b &amp; c, a &gt; b, c &lt; 0 generates an array of elements a,a-c,a-2c and ends with the number not less than b');
  equal($(Mixin.range(0, -10, -1)).join(' '), '0 -1 -2 -3 -4 -5 -6 -7 -8 -9', 'final example in the Python docs');
});

}