#import("../DUnit.dart");
#import("MixinTests.dart");
#import("ArrayTests.dart");
#import("CollectionTests.dart");
#import("ObjectTests.dart");
#import("UtilityTests.dart");
#import("StringTests.dart");

main(){
  MixinTests();
  ObjectTests();
  CollectionTests();
  ArrayTests();
  UtilityTests();
  StringTests();
  
  runAllTests(hidePassedTests:false);
}
