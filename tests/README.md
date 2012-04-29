# DUnit.dart

A minimal port of the QUnit subset that Underscore.js uses.
The entire implementation fits in a single stand-alone [DUnit.dart](https://github.com/mythz/DartMixins/blob/master/DUnit.dart) file that's an easy include in any project.

Includes a text output runner and basic support for these test primitves:

### API 

    module(moduleName):

       test(testName, testClosure):

           equal(actual, expected, msg)
           deepEqual(actual, expected, msg)
           strictEqual(actual, expected, msg)
           ok(bool, msg)
           raises(closure, errorPredicate, msg)

### Example Usage:

Just like in QUnit you define your tests declaratively in modules and test sections:

    module("Utility");  

    test("utility: times", () {
        var vals = [];
        $(3).times((i) => vals.add(i));
        deepEqual(vals, [0,1,2], "is 0 indexed");
    });

    test("utility: mixin", () {
        Mixin.mixin({
          'myReverse': (str) => $($(str.splitChars()).reverse()).join(''),
          'truncate': (str,len) => str.length > len ? "${str.substring(0, len)}..." : str,
        });
        equal($('panacea').myReverse(), 'aecanap', 'mixed in a function with no args');
        equal($("veryLongWord").truncate(8), 'veryLong...', 'mixed in a function with 1 arg');
    });

    module("Arrays");

    test("arrays: first", () {  
        deepEqual($([1,2,3]).first(2), [100, 200], 'can pass an index to first'); //Fail example
    });

Then you can run all the tests with the top-level function:

    runAllTests();    

Which for the above tests will print this output:

    1. Utility: utility: times (0, 1, 1)
      1. is 0 indexed
         Expected [0, 1, 2]
    2. Utility: utility: mixin (0, 2, 2)
      1. mixed in a function with no args
         Expected aecanap
      2. mixed in a function with 1 arg
         Expected veryLong...

    1. Arrays: arrays: first (1, 0, 1)
      1. can pass an index to first
         Expected [100, 200]
         FAILED was [1, 2]


    Tests completed in 107ms
    4 tests of 3 passed, 1 failed.


You also have the option to only show failing tests with:

    runAllTests(hidePassedTests:false);

Which will only show the tests that have failed:

    1. Arrays: arrays: first (1, 0, 1)
      1. can pass an index to first
         Expected [100, 200]
         FAILED was [1, 2]

    Tests completed in 17ms
    4 tests of 3 passed, 1 failed.

## Packaging larger test suites tips

As maintaining large test suites in a single file can soon become unwieldy it is a good idea to split your
tests into different modules by wrapping each module definition into their own functions thereby being able
to import and run them in a single test runner. Here's the [MixinTestSuite.dart](https://github.com/mythz/DartMixins/blob/master/tests/MixinTestSuite.dart) for the DartMixin's project:

    #import("../DUnit.dart");
    #import("ArrayTests.dart");
    #import("CollectionTests.dart");
    #import("ObjectTests.dart");
    #import("UtilityTests.dart");

    main(){
      ObjectTests();
      CollectionTests();
      ArrayTests();
      UtilityTests();
      
      runAllTests();
    }

And the [entire text output](https://gist.github.com/2523357) of the above test runner.
