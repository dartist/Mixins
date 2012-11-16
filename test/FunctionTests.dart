library FunctionTests;
import "DUnit.dart";
import "package:mixin/mixin.dart";

FunctionTests() {

  module("Function");

  test("functions: memoize", () {
    fib(n) => n < 2 ? n : fib(n - 1) + fib(n - 2);

    var fastFib = $(fib).memoize();
    equal(fib(10), 55, 'a memoized version of fibonacci produces identical results');
    equal(fastFib(10), 55, 'a memoized version of fibonacci produces identical results');

    o(str) => str;

    var fastO = $(o).memoize();
    equal(o('toString'), 'toString', 'checks hasOwnProperty');
    equal(fastO('toString'), 'toString', 'checks hasOwnProperty');
  });

//  asyncTest("functions: delay", 2, function() {
//    var delayed = false;
//    _.delay(function(){ delayed = true; }, 100);
//    setTimeout(function(){ ok(!delayed, "didn't delay the function quite yet"); }, 50);
//    setTimeout(function(){ ok(delayed, 'delayed the function'); start(); }, 150);
//  });
//
//  asyncTest("functions: defer", 1, function() {
//    var deferred = false;
//    _.defer(function(bool){ deferred = bool; }, true);
//    _.delay(function(){ ok(deferred, "deferred the function"); start(); }, 50);
//  });
//
//  asyncTest("functions: throttle", 2, function() {
//    var counter = 0;
//    var incr = function(){ counter++; };
//    var throttledIncr = _.throttle(incr, 100);
//    throttledIncr(); throttledIncr(); throttledIncr();
//    setTimeout(throttledIncr, 70);
//    setTimeout(throttledIncr, 120);
//    setTimeout(throttledIncr, 140);
//    setTimeout(throttledIncr, 190);
//    setTimeout(throttledIncr, 220);
//    setTimeout(throttledIncr, 240);
//    _.delay(function(){ equal(counter, 1, "incr was called immediately"); }, 30);
//    _.delay(function(){ equal(counter, 4, "incr was throttled"); start(); }, 400);
//  });
//
//  asyncTest("functions: throttle arguments", 2, function() {
//    var value = 0;
//    var update = function(val){ value = val; };
//    var throttledUpdate = _.throttle(update, 100);
//    throttledUpdate(1); throttledUpdate(2); throttledUpdate(3);
//    setTimeout(function(){ throttledUpdate(4); }, 120);
//    setTimeout(function(){ throttledUpdate(5); }, 140);
//    setTimeout(function(){ throttledUpdate(6); }, 250);
//    _.delay(function(){ equal(value, 1, "updated to latest value"); }, 40);
//    _.delay(function(){ equal(value, 6, "updated to latest value"); start(); }, 400);
//  });
//
//  asyncTest("functions: throttle once", 2, function() {
//    var counter = 0;
//    var incr = function(){ return ++counter; };
//    var throttledIncr = _.throttle(incr, 100);
//    var result = throttledIncr();
//    _.delay(function(){
//      equal(result, 1, "throttled functions return their value");
//      equal(counter, 1, "incr was called once"); start();
//    }, 220);
//  });
//
//  asyncTest("functions: throttle twice", 1, function() {
//    var counter = 0;
//    var incr = function(){ counter++; };
//    var throttledIncr = _.throttle(incr, 100);
//    throttledIncr(); throttledIncr();
//    _.delay(function(){ equal(counter, 2, "incr was called twice"); start(); }, 220);
//  });
//
//  asyncTest("functions: throttle recursively", 1, function() {
//    var counter = 0;
//    var incr = _.throttle(function() {
//        counter++;
//        if (counter < 5) incr();
//    }, 100);
//    incr();
//    _.delay(function(){ equal(counter, 3, "incr was throttled"); start(); }, 220);
//  });
//
//  asyncTest("functions: debounce", 1, function() {
//    var counter = 0;
//    var incr = function(){ counter++; };
//    var debouncedIncr = _.debounce(incr, 50);
//    debouncedIncr(); debouncedIncr(); debouncedIncr();
//    setTimeout(debouncedIncr, 30);
//    setTimeout(debouncedIncr, 60);
//    setTimeout(debouncedIncr, 90);
//    setTimeout(debouncedIncr, 120);
//    setTimeout(debouncedIncr, 150);
//    _.delay(function(){ equal(counter, 1, "incr was debounced"); start(); }, 220);
//  });
//
//  asyncTest("functions: debounce asap", 2, function() {
//    var counter = 0;
//    var incr = function(){ counter++; };
//    var debouncedIncr = _.debounce(incr, 50, true);
//    debouncedIncr(); debouncedIncr(); debouncedIncr();
//    equal(counter, 1, 'incr was called immediately');
//    setTimeout(debouncedIncr, 30);
//    setTimeout(debouncedIncr, 60);
//    setTimeout(debouncedIncr, 90);
//    setTimeout(debouncedIncr, 120);
//    setTimeout(debouncedIncr, 150);
//    _.delay(function(){ equal(counter, 1, "incr was debounced"); start(); }, 220);
//  });
//
//  asyncTest("functions: debounce asap recursively", 2, function() {
//    var counter = 0;
//    var debouncedIncr = _.debounce(function(){
//      counter++;
//      if (counter < 5) debouncedIncr();
//    }, 50, true);
//    debouncedIncr();
//    equal(counter, 1, 'incr was called immediately');
//    _.delay(function(){ equal(counter, 1, "incr was debounced"); start(); }, 70);
//  });

  test("functions: once", () {
    int num = 0;
    var increment = $((){ num++; }).once();
    increment();
    increment();
    equal(num, 1, "increment is only called once");
  });

  test("functions: wrap", () {
    greet(name) => "hi: " + name;
    var backwards = $(greet).wrap((func, name) => "${func(name)} ${$($(name.split('')).reverse()).join('')}" );
    equal(backwards('moe'), 'hi: moe eom', 'wrapped the saluation function');

    inner() => "Hello ";
    Map obj   = {'name': "Moe"};
    obj['hi'] = $(inner).wrap((fn) => "${fn()}${obj['name']}");
    equal(obj['hi'](), "Hello Moe", "does wrap inner() fn");

    noop(){};
    var wrapped = $(noop).wrap((fn, [arg1,arg2,arg3]) => [fn,arg1,arg2,arg3]);
    var ret     = wrapped(['whats', 'your'], 'vector', 'victor');
    deepEqual(ret, [noop, ['whats', 'your'], 'vector', 'victor'], 'wrapped noop() with args');
  });

  test("functions: compose", () {
    greet(name) => "hi: $name";
    var exclaim = (sentence) => '$sentence!';
    var composed = $(exclaim).compose(greet);
    equal(composed('moe'), 'hi: moe!', 'can compose a function that takes another');

    composed = $(greet).compose(exclaim);
    equal(composed('moe'), 'hi: moe!', 'in this case, the functions are also commutative');
  });

  test("functions: after", () {
    testAfter(afterAmount, timesCalled) {
      var afterCalled = 0;
      var after = $(() => afterCalled++).after(afterAmount);
      while (timesCalled-- > 0) after();
      return afterCalled;
    }

    equal(testAfter(5, 5), 1, "after(N) should fire after being called N times");
    equal(testAfter(5, 4), 0, "after(N) should not fire unless called N times");
    equal(testAfter(0, 0), 1, "after(0) should fire immediately");
  });

}
