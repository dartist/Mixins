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
  
  runAllTests(hidePassedTests:false);
}
