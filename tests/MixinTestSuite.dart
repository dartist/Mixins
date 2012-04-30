#import("../DUnit.dart");
#import("ArrayTests.dart");
#import("CollectionTests.dart");
#import("ObjectTests.dart");
#import("UtilityTests.dart");
#import("StringTests.dart");

main(){
//  ObjectTests();
//  CollectionTests();
//  ArrayTests();
//  UtilityTests();
  StringTests();
  
  runAllTests(hidePassedTests:true);
}
