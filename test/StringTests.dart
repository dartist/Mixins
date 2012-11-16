library StringTests;
import "../DUnit.dart";
import "../Mixin.dart";

StringTests(){

  module("Strings");

  test("Strings: capitalize", () {
    equal($("fabio").capitalize(), "Fabio", 'First letter is upper case');
    equal($('FOO').capitalize(), 'FOO', 'Other letters unchanged');
    equal($("123").capitalize(), "123", "Non string");
  });

  test("Strings: reverse", () {
    equal($("foo").reverse(), "oof", 'reverses 3-letter word');
    equal($("foobar").reverse(), "raboof", 'reverses 6-letter');
    equal($("foo bar").reverse(), "rab oof", 'reverses 2 words');
    equal($("123").reverse(), "321", "Non string");
    equal($("123.45").reverse(), "54.321", "Non string");
  });

  test("Strings: clean", () {
    equal($(" foo    bar   ").clean(), "foo bar", 'cleans spaced words');
    equal($("123").clean(), "123", "does not change numbers");
  });

  test('String: titleize', (){
    equal($('the titleize string method').titleize(), 'The Titleize String Method', 'does titilize sentence');
    equal($('the titleize string  method').titleize(), 'The Titleize String  Method', 'does not change word spacing');
    equal($("123").titleize(), '123', 'titleize leaves numbers');
  });

//  test('String: camelize', (){
//    equal($('the_camelize_string_method').camelize(), 'theCamelizeStringMethod', 'can camelize underscores');
//    equal($('-the-camelize-string-method').camelize(), 'TheCamelizeStringMethod', 'can camelize dashes');
//    equal($('the camelize string method').camelize(), 'theCamelizeStringMethod', 'can camelize words together');
//    equal($(' the camelize  string method').camelize(), 'theCamelizeStringMethod', 'can camelize spaced words together');
//    equal($("123").camelize(), '123', 'camelize leaves numbers');
//    equal($('-moz-transform').camelize(), 'MozTransform', 'can camelize dash prefix');
//    equal($('webkit-transform').camelize(), 'webkitTransform', 'can camelize dashes');
//    equal($('under_scored').camelize(), 'underScored', 'can camelize underscores');
//    equal($(' with   spaces').camelize(), 'withSpaces', 'can camelize spaces');
//  });

  test('String: underscored', (){
    equal($('the-underscored-string-method').underscored(), 'the_underscored_string_method', 'can underscored dashes');
    equal($('theUnderscoredStringMethod').underscored(), 'the_underscored_string_method', 'can underscored camelCase words');
    equal($('TheUnderscoredStringMethod').underscored(), 'the_underscored_string_method', 'can underscored PascalCase words');
    equal($(' the underscored  string method').underscored(), 'the_underscored_string_method', 'can underscored spaced words');
    equal($("123").underscored(), '123', 'underscores leaves numbers');
  });

  test('String: dasherize', (){
    equal($('the_dasherize_string_method').dasherize(), 'the-dasherize-string-method', 'can dasherize underscores');
    equal($('TheDasherizeStringMethod').dasherize(), '-the-dasherize-string-method', 'can dasherize PascalCase');
//    equal($('thisIsATest').dasherize(), 'this-is-a-test', 'can dasherize camelCase');
    equal($('this Is A Test').dasherize(), 'this-is-a-test', 'can dasherize spaced mix-case words');
//    equal($('thisIsATest123').dasherize(), 'this-is-a-test123', 'can dasherize camelCase with number suffix');
//    equal($('123thisIsATest').dasherize(), '123this-is-a-test', 'can dasherize camelCase with number prefix');
    equal($('the dasherize string method').dasherize(), 'the-dasherize-string-method', 'can dasherize lower case words');
    equal($('the  dasherize string method  ').dasherize(), 'the-dasherize-string-method', 'can dasherize spaced words');
    equal($('téléphone').dasherize(), 'téléphone', 'can dasherize i18n words');
    equal($(r'foo$bar').dasherize(), r'foo$bar', 'dasherize leaves special chars');
    equal($("123").dasherize(), '123', 'dasherize leaves numbers');
  });

  test('String: humanize', (){
    equal($('the_humanize_string_method').humanize(), 'The humanize string method', 'can humanize underscores');
    equal($('ThehumanizeStringMethod').humanize(), 'Thehumanize string method', 'can humanize PascalCase');
    equal($('the humanize string method').humanize(), 'The humanize string method', 'can humanize sentence');
    equal($('the humanize_id string method_id').humanize(), 'The humanize id string method', 'can humanize repetitive id literal');
    equal($('the  humanize string method  ').humanize(), 'The humanize string method', 'can humanize spaced words');
    equal($('   capitalize dash-CamelCase_underscore trim  ').humanize(), 'Capitalize dash camel case underscore trim', 'can humanize mix');
    equal($("123").humanize(), '123', 'humanize leaves numbers');
  });

  test('String: truncate', (){
    equal($('Hello world').truncate(6, 'read more'), 'Hello read more', 'can truncate with suffix');
    equal($('Hello world').truncate(5), 'Hello...', 'can truncate without suffix');
    equal($('Hello').truncate(10), 'Hello', 'truncate leaves short words');
    equal($("1234567890").truncate(5), '12345...', 'can truncate numbers');
  });

  test('String: isBlank', (){
    ok($('').isBlank(), 'empty string');
    ok($(' ').isBlank(), 'single space');
    ok($('\n').isBlank(), 'new line');
    ok(!$('a').isBlank(), 'a is not blank');
    ok(!$('0').isBlank(), 'string 0 is not blank');
  });

  test('String: words', () {
    equal($("I love you!").words().length, 3, 'handles !');
    equal($(" I    love   you!  ").words().length, 3, 'handles spaced words');
    equal($("I_love_you!").words('_').length, 3, 'handles underscores');
    equal($("I-love-you!").words(new RegExp("-")).length, 3, 'handles RegExp');
    equal($("123").words().length, 1, 'handles numbers');
  });

  test('String: chars', () {
    equal($("Hello").chars().length, 5, 'does word');
    equal($("123").chars().length, 3, 'does number');
  });

  test('String: lines', () {
    equal($("Hello\nWorld").lines().length, 2, 'does multiple lines');
    equal($("Hello World").lines().length, 1, 'does single line');
    equal($("123").lines().length, 1, 'does number');
  });

  test('String: lpad', () {
    equal($("1").lpad(8), '       1', 'does char');
    equal($("1").lpad(8, '0'), '00000001', 'does char with padStr');
  });

  test('String: rpad', () {
    equal($("1").rpad(8), '1       ', 'does char');
    equal($("1").rpad(8, '0'), '10000000', 'does char with padStr');
    equal($("foo").rpad(8, '0'), 'foo00000', 'does word with padStr 8');
    equal($("foo").rpad(7, '0'), 'foo0000', 'does word with padStr 7');
  });

  test('String: lrpad', () {
    equal($("1").lrpad(8), '    1   ', 'does char');
    equal($("1").lrpad(8, '0'), '00001000', 'does char with padStr');
    equal($("foo").lrpad(8, '0'), '000foo00', 'does word with padStr 8');
    equal($("foo").lrpad(7, '0'), '00foo00', 'does word with padStr 7');
    equal($("foo").lrpad(7, '!@%dofjrofj'), '!!foo!!','does use partial padStr');
  });

  test('Strings: stripTags', () {
    equal($('a <a href="#">link</a>').stripTags(), 'a link', 'can strip link');
    equal($('a <a href="#">link</a><script>alert("hello world!")</scr'+'ipt>').stripTags(), 'a linkalert("hello world!")', 'can strip link with js');
    equal($('<html><body>hello world</body></html>').stripTags(), 'hello world', 'can strip html');
    equal($('123').stripTags(), '123', 'leaves number');
  });

  test('Strings: repeat', () {
    equal($('foo').repeat(), '', 'does not repeat without times');
    equal($('foo').repeat(3), 'foofoofoo', 'does 3 times');
    equal($('123').repeat(2), '123123', 'does number');
    equal($('1234').repeat(2, '*'), '1234*1234', 'does with seperator');
  });

  test('Strings: splitOnFirst', (){
    deepEqual($("/a/test/path").splitOnFirst("/"), ["","a/test/path"], "can split on first char");
    deepEqual($("a/test/path").splitOnFirst("/"), ["a","test/path"], "can split on string with multiple matches");
    deepEqual($("a/test/path").splitOnFirst("_"), ["a/test/path"], "unmatched leaves string in-tact");
  });

  test('Strings: splitOnLast', (){
    deepEqual($("a/test/path/").splitOnLast("/"), ["a/test/path",""], "can split on last char");
    deepEqual($("a/test/path").splitOnLast("/"), ["a/test","path"], "can split on string with multiple matches");
    deepEqual($("a/test/path").splitOnLast("_"), ["a/test/path"], "unmatched leaves string in-tact");
  });

}
