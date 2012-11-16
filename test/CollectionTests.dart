library CollectionTests;
import "../DUnit.dart";
import "../Mixin.dart";

CollectionTests() {

  module("Collections");

  test("collections: each", () {
    int i=0;
    $([1, 2, 3]).each((num) {
      equal(num, i++ + 1, 'each iterators provide value and iteration count');
    });

    var answers = [];
//    _.each((num){ answers.push(num * this.multiplier);}, {multiplier : 5});
//    equal(answers.join(', '), '5, 10, 15', 'context object property accessed');

    answers = [];
    $([1, 2, 3]).forEach((num){ answers.add(num); });
    equal($(answers).join(', '), '1, 2, 3', 'aliased as "forEach"');

//    answers = [];
//    var obj = {one : 1, two : 2, three : 3};
//    obj.constructor.prototype.four = 4;
//    _.each(obj, function(value, key){ answers.push(key); });
//    equal(answers.join(", "), 'one, two, three', 'iterating over objects works, and ignores the object prototype.');
//    delete obj.constructor.prototype.four;

//    answer = null;
//    $([1, 2, 3]).each((num, index, arr){ if ($(arr).include(num)) answer = true; });
//    ok(answer, 'can reference the original collection from inside the iterator');

    answers = 0;
    $(null).each((_){ ++answers; });
    equal(answers, 0, 'handles a null properly');
  });

  test('collections: map', () {
    var doubled = $([1, 2, 3]).map((num) => num * 2);
    equal($(doubled).join(', '), '2, 4, 6', 'doubled numbers');

    doubled = $([1, 2, 3]).collect((num) => num * 2);
    equal($(doubled).join(', '), '2, 4, 6', 'aliased as "collect"');

//    var tripled = _.map([1, 2, 3], function(num){ return num * this.multiplier; }, {multiplier : 3});
//    equal(tripled.join(', '), '3, 6, 9', 'tripled numbers with context');

    doubled = $([1, 2, 3]).map((num) => num * 2);
    equal($(doubled).join(', '), '2, 4, 6', 'OO-style doubled numbers');

//    var ids = _.map($('div.underscore-test').children(), function(n){ return n.id; });
//    ok(_.include(ids, 'qunit-header'), 'can use collection methods on NodeLists');

//    var ids = _.map(document.images, function(n){ return n.id; });
//    ok(ids[0] == 'chart_image', 'can use collection methods on HTMLCollections');

    var ifnull = $(null).map((_){});
    ok($(ifnull).isArray() && ifnull.length == 0, 'handles a null properly');

    var length = $(new List(2)).map((v) => v).length;
    equal(length, 2, "can preserve a sparse array's length");
  });

  test('collections: reduce', () {
    var sum = $([1, 2, 3]).reduce((sum, num) => sum + num, 0);
    equal(sum, 6, 'can sum up an array');

//    var context = {multiplier : 3};
//    sum = _.reduce([1, 2, 3], function(sum, num){ return sum + num * this.multiplier; }, 0, context);
//    equal(sum, 18, 'can reduce with a context object');

    sum = $([1, 2, 3]).inject((memo, num) => memo + num, 0);
    equal(sum, 6, 'aliased as "inject"');

    sum = $([1, 2, 3]).reduce((memo, num) => memo + num, 0);
    equal(sum, 6, 'OO-style reduce');

    sum = $([1, 2, 3]).reduce((memo, num) => memo + num);
    equal(sum, 6, 'default initial value');

    var ifnull;
    try {
      $(null).reduce((x,y){});
    } catch (final ex) {
      ifnull = ex;
    }
    ok(ifnull is TypeError$, 'handles a null (without inital value) properly');

    ok($(null).reduce((x,y){}, 138) == 138, 'handles a null (with initial value) properly');
//    equal($([]).reduce((x,y){}, null), null, 'undefined can be passed as a special case');
//    raises(function() { _.reduce([], function(){}); }, TypeError, 'throws an error for empty arrays with no initial value');

//    var sparseArray = [];
//    sparseArray[0] = 20;
//    sparseArray[2] = -5;
//    equal(_.reduce(sparseArray, function(a, b){ return a - b; }), 25, 'initially-sparse arrays with no memo');
  });

  test('collections: reduceRight', () {
    var list = $(["foo", "bar", "baz"]).reduceRight((memo, str) => memo + str, '');
    equal(list, 'bazbarfoo', 'can perform right folds');

    list = $(["foo", "bar", "baz"]).foldr((memo, str) => memo + str, '');
    equal(list, 'bazbarfoo', 'aliased as "foldr"');

    list = $(["foo", "bar", "baz"]).foldr((memo, str) => memo + str);
    equal(list, 'bazbarfoo', 'default initial value');

    var ifnull;
    try {
      $(null).reduceRight((x,y){});
    } catch (final ex) {
      ifnull = ex;
    }
    ok(ifnull is TypeError$, 'handles a null (without inital value) properly');

    ok($(null).reduceRight((x,y){}, 138) == 138, 'handles a null (with initial value) properly');

//    equal($([]).reduceRight((x,y){}, null), null, 'undefined can be passed as a special case');
//    raises(function() { _.reduceRight([], function(){}); }, TypeError, 'throws an error for empty arrays with no initial value');

//    var sparseArray = [];
//    sparseArray[0] = 20;
//    sparseArray[2] = -5;
//    equal(_.reduceRight(sparseArray, function(a, b){ return a - b; }), -25, 'initially-sparse arrays with no memo');
  });

  test('collections: detect', () {
    var result = $([1, 2, 3]).detect((num) => num * 2 == 4);
    equal(result, 2, 'found the first "2" and broke the loop');
  });

  test('collections: select', () {
    var evens = $([1, 2, 3, 4, 5, 6]).select((num) => num % 2 == 0);
    equal($(evens).join(', '), '2, 4, 6', 'selected each even number');

    evens = $([1, 2, 3, 4, 5, 6]).filter((num) => num % 2 == 0);
    equal($(evens).join(', '), '2, 4, 6', 'aliased as "filter"');
  });

  test('collections: reject', () {
    var odds = $([1, 2, 3, 4, 5, 6]).reject((num) => num % 2 == 0);
    equal($(odds).join(', '), '1, 3, 5', 'rejected each even number');
  });

  test('collections: all', () {
    ok($([]).all(Mixin.identity), 'the empty set');
    ok($([true, true, true]).all(Mixin.identity), 'all true values');
    ok(!$([true, false, true]).all(Mixin.identity), 'one false value');
    ok($([0, 10, 28]).all((num) => num % 2 == 0), 'even numbers');
    ok(!$([0, 11, 28]).all((num) => num % 2 == 0), 'an odd number');
//Dart .every() is typed - throws checked error
//    ok($([1]).all(Mixin.identity) == true, 'cast to boolean - true');
//    ok($([0]).all(Mixin.identity) == false, 'cast to boolean - false');
    ok($([true, true, true]).every(Mixin.identity), 'aliased as "every"');
  });

  test('collections: any', () {
//    var nativeSome = Array.prototype.some;
//    Array.prototype.some = null;
    ok(!$([]).any(), 'the empty set');
    ok(!$([false, false, false]).any(), 'all false values');
    ok($([false, false, true]).any(), 'one true value');
    ok($([null, 0, 'yes', false]).any(), 'a string');
    ok(!$([null, 0, '', false]).any(), 'falsy values');
    ok(!$([1, 11, 29]).any((num) => num % 2 == 0), 'all odd numbers');
    ok($([1, 10, 29]).any((num) => num % 2 == 0), 'an even number');
//Dart .some() is typed - throws checked error
//    ok($([1]).any(Mixin.identity) == true, 'cast to boolean - true');
//    ok($([0]).any(Mixin.identity) == false, 'cast to boolean - false');
    ok($([false, false, true]).some(), 'aliased as "some"');
//    Array.prototype.some = nativeSome;
  });

  test('collections: include', function() {
    ok($([1,2,3]).include(2), 'two is in the array');
    ok(!$([1,3,9]).include(2), 'two is not in the array');
    ok($({'moe':1, 'larry':3, 'curly':9}).contains(3) == true, '_.include on objects checks their values');
    ok($([1,2,3]).include(2), 'OO-style include');
  });

// Requires Function support in Dart
//  test('collections: invoke', () {
//    var list = [[5, 1, 7], [3, 2, 1]];
//    var result = $(list).invoke('sort');
//    equal($(result[0]).join(', '), '1, 5, 7', 'first array sorted');
//    equal($(result[1]).join(', '), '1, 2, 3', 'second array sorted');
//  });

//  test('collections: invoke w/ function reference', function() {
//    var list = [[5, 1, 7], [3, 2, 1]];
//    var result = _.invoke(list, Array.prototype.sort);
//    equal(result[0].join(', '), '1, 5, 7', 'first array sorted');
//    equal(result[1].join(', '), '1, 2, 3', 'second array sorted');
//  });
//
//  // Relevant when using ClojureScript
//  test('collections: invoke when strings have a call method', function() {
//    String.prototype.call = function() {
//      return 42;
//    };
//    var list = [[5, 1, 7], [3, 2, 1]];
//    var s = "foo";
//    equal(s.call(), 42, "call function exists");
//    var result = _.invoke(list, 'sort');
//    equal(result[0].join(', '), '1, 5, 7', 'first array sorted');
//    equal(result[1].join(', '), '1, 2, 3', 'second array sorted');
//    delete String.prototype.call;
//    equal(s.call, undefined, "call function removed");
//  });

  test('collections: pluck', () {
    List people = [{'name': 'moe', 'age': 30}, {'name': 'curly', 'age': 50}];
    equal($($(people).pluck('name')).join(', '), 'moe, curly', 'pulls names out of objects');
  });

  test('collections: max', () {
    equal(3, $([1, 2, 3]).max(), 'can perform a regular Math.max');

    var neg = $([1, 2, 3]).max((num) => -num);
    equal(neg, 1, 'can perform a computation-based max');

    equal(double.NEGATIVE_INFINITY, $({}).max(), 'Maximum value of an empty object');
    equal(double.NEGATIVE_INFINITY, $([]).max(), 'Maximum value of an empty array');
  });

  test('collections: min', function() {
    equal($([1, 2, 3]).min(), 1, 'can perform a regular Math.min');

    var neg = $([1, 2, 3]).min((num) => -num);
    equal(neg, 3, 'can perform a computation-based min');

    equal(double.INFINITY, $({}).min(), 'Minimum value of an empty object');
    equal(double.INFINITY, $([]).min(), 'Minimum value of an empty array');

    Date now = new Date.fromMillisecondsSinceEpoch(9999999999, isUtc: true);
    Date then = new Date.fromMillisecondsSinceEpoch(0, isUtc: true);
    equal($([now, then]).min(), then, 'can perform min on date');
  });

  test('collections: sortBy', function() {
    List people = [{'name': 'curly', 'age': 50}, {'name': 'moe', 'age': 30}];
    people = $(people).sortBy((person) => person['age']);
    equal($($(people).pluck('name')).join(', '), 'moe, curly', 'stooges sorted by age');

    var list = [null, 4, 1, null, 3, 2];
    equal($($(list).sortBy(Mixin.identity)).toDebugString(), '1,2,3,4,,', 'sortBy with undefined values');

    list = ["one", "two", "three", "four", "five"];
    var sorted = $(list).sortBy((x) => x.length);
    equal($(sorted).join(' '), 'one two four five three', 'sorted by length');
  });

  test('collections: groupBy', () {
    var parity = $([1, 2, 3, 4, 5, 6]).groupBy((num) => num % 2);
    ok(parity.containsKey('0') && parity.containsKey('1'), 'created a group for each value');
    equal($(parity['0']).join(', '), '2, 4, 6', 'put each even number in the right group');

    List list = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"];
    var grouped = $(list).groupBy((x) => x.length);
    equal($(grouped['3']).join(' '), 'one two six ten', '1st group grouped by length');
    equal($(grouped['4']).join(' '), 'four five nine', '2nd group grouped by length');
    equal($(grouped['5']).join(' '), 'three seven eight', '3rd group grouped by length');
  });

  test('collections: sortedIndex', function() {
    List numbers = [10, 20, 30, 40, 50];
    int num = 35;
    var indexForNum = $(numbers).sortedIndex(num);
    equal(indexForNum, 3, '35 should be inserted at index 3');

    var indexFor30 = $(numbers).sortedIndex(30);
    equal(indexFor30, 2, '30 should be inserted at index 2');
  });

  test('collections: shuffle', () {
    var numbers = Mixin.range(10);
    var shuffled = $($(numbers).shuffle()).sort();
    deepEqual(numbers, shuffled, 'original object is unmodified');
    equal($(shuffled).join(','), $(numbers).join(','), 'contains the same members before and after shuffle');
  });

  test('collections: toArray', function() {
//    ok(!_.isArray(arguments), 'arguments object is not an array');
//    ok(_.isArray(_.toArray(arguments)), 'arguments object converted into array');
    var a = [1,2,3];
    ok(!identical($(a).toArray(), a), 'array is cloned');
    equal($($(a).toArray()).join(', '), '1, 2, 3', 'cloned array contains same elements');

    var numbers = $({'one': 1, 'two': 2, 'three': 3}).toArray();
    equal($(numbers).join(', '), '1, 2, 3', 'object flattened into array');

    var objectWithToArrayFunction = {'toArray': () => [1, 2, 3]};
    equal($($(objectWithToArrayFunction).toArray()).join(', '), '1, 2, 3', 'toArray method used if present');

    var objectWithToArrayValue = {'toArray': 1};
    equal($($(objectWithToArrayValue).toArray()).join(', '), '1', 'toArray property ignored if not a function');
  });

  test('collections: size', () {
    equal($({'one': 1, 'two': 2, 'three': 3}).size(), 3, 'can compute the size of an object');
    equal($([1, 2, 3]).size(), 3, 'can compute the size of an array');
  });

  test('collections: insert', (){
    List chars = ['b','c','d'];
    $(chars).insert(0, 'a');
    deepEqual(chars, ['a','b','c','d'], 'can insert at start of the list');
    chars = ['b','c','d'];
    $(chars).insert(chars.length, 'e');
    deepEqual(chars, ['b','c','d','e'], 'can insert at end of the list');
  });

}