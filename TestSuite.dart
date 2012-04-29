#library("TestSuite");

class Assertion {
  var actual, expected;
  bool deepEqual,strictEqual;
  String msg;
  Assertion(this.actual,this.expected,this.msg,[this.deepEqual=false, this.strictEqual=false]);
  success() {
    if (strictEqual) return actual === expected;
    if (!deepEqual) return actual == expected;
    if (actual == null || expected == null || actual.length != expected.length) 
      return false;

    if (actual is Map) {
      if (expected is! Map) return false;
      for (var key in actual.getKeys()) 
        if (actual[key] != expected[key]) return false;
      return true; 
    }
    
    int i=0;
    return actual.every((x) => x == expected[i++]);
  }
}
Map<String,Map<String,Function>> _moduleTests; 

String _moduleName;
module (name) {
  if (_moduleTests == null) _moduleTests = new Map<String,Map<String,Function>>();
  _moduleName = name;
  _moduleTests.putIfAbsent(_moduleName, () => {});
}

test(name, Function assertions) {
  _moduleTests[_moduleName][name] = assertions;
}

List<Assertion> _testAssertions;
equal(actual, expected, msg) =>
  _testAssertions.add(new Assertion(actual,expected,msg));
deepEqual(actual, expected, msg) =>
    _testAssertions.add(new Assertion(actual,expected,msg,deepEqual:true));
strictEqual(actual, expected, msg) =>
    _testAssertions.add(new Assertion(actual,expected,msg,strictEqual:true));
ok(actual, msg) =>
  _testAssertions.add(new Assertion(actual,true,msg));

raises(actualFn, expectedTypeFn, msg) {
  try {
    var actual = actualFn();
    _testAssertions.add(new Assertion(actual,"expected error",msg));
  }
  catch (final e) {
    if (expectedTypeFn(e)) 
      _testAssertions.add(new Assertion(true,true,msg));
    else
      _testAssertions.add(new Assertion(e,"wrong error type",msg));
  }
}

runAllTests(){
  for (String moduleName in _moduleTests.getKeys()) {
    int testNo = 0;
    Map<String,Function> moduleTests = _moduleTests[moduleName];
    for (String testName in moduleTests.getKeys()) {
      testNo++;
      _testAssertions = new List<Assertion>();
      String error = null;
      try {
        moduleTests[testName]();
      } 
//UnComment to catch and report errors
//      catch(final e){
//        error = "Error while running test #$testNo in $moduleName: $testName\n$e";
//      }
      finally {}
      int total = _testAssertions.length;
      int failed = _testAssertions.filter((x) => !x.success()).length;
      int success = total - failed;
      
      print("$testNo. $moduleName: $testName ($failed, $success, $total)");
      
      for (int i=0; i<_testAssertions.length; i++) {
        Assertion assertion = _testAssertions[i]; 
        print("  ${i+1} ${assertion.msg}");
        if (assertion.expected is! bool)
          print("    Expected ${assertion.expected}");
        if (!assertion.success()) 
          print("    FAILED was ${assertion.actual}");
      }
      if (error != null) print(error);
    }
    print("");
  }
}