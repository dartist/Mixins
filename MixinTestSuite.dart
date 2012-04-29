#import("TestSuite.dart");
#import("tests/ArrayTests.dart");
#import("tests/CollectionTests.dart");
#import("tests/ObjectTests.dart");
#import("tests/UtilityTests.dart");

main(){
  ObjectTests();
  CollectionTests();
  ArrayTests();
  UtilityTests();
  
  runAllTests();
}
