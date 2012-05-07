#import("../DUnit.dart");
#import("MixinTests.dart");
#import("ArrayTests.dart");
#import("CollectionTests.dart");
#import("ObjectTests.dart");
#import("UtilityTests.dart");
#import("StringTests.dart");
#import("FunctionTests.dart");

main(){
  MixinTests();
  ObjectTests();
  CollectionTests();
  ArrayTests();
  UtilityTests();
  StringTests();
  FunctionTests();
  
  runAllTests(hidePassedTests:false);
}
