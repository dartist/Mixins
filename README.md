Dart Mixins
===========

This [Dart](http://www.dartlang.org) project includes most utils from the popular [Underscore.js](https://github.com/documentcloud/underscore) library via a jQuery-like interface. It also provides Mixin-like capabilities allowing run-time extensibility of its API with custom functions.

Follow [@demisbellot](http://twitter.com/demisbellot) for updates.

### Download

The entire library is maintained in a single, stand-alone [Mixin.dart](https://github.com/mythz/DartMixins/blob/master/Mixin.dart) file. Refer to the [underscorejs.org](http://underscorejs.org/) website for documentation or the included [test suite](https://github.com/mythz/DartMixins/tree/master/tests) and its [output](https://gist.github.com/2523357). The light-weight, text-based [DUnit.dart](https://github.com/mythz/DartMixins/blob/master/DUnit.dart) test runner used is also available to download separately.

## Usage

As the **'_'** character in Dart is a reserved prefix to denote library-only visibility we use **'$'** in its place to wrap a target object to apply _.underscores functions onto, e.g:

    $([1,2,3]).max() -> 3

Just like jQuery you wrap any object with `$(...)` to unlock all additional functionality relating to that object. Unlike jQuery `$()` returns a type-specific mixin class based on the type of the wrapped object, e.g:

    $([])    -> new List$([])
    $({})    -> new Map$({})
    $("")    -> new String$("")
    $(0)     -> new Num$(0)
    $((){})  -> new Function$((){})
    $(null)  -> new Mixin(null)
    $(mixin) -> mixin

Where all mixin classes inherit the `Mixin` base type.
So passing in an array returns an instance of `List$` with all its methods applying to the wrapped object.

    $([1,2,3,4,5]).first(3) -> [1,2,3]

This allows you to get intelli-sense from the DartEditor by specifying the returned type, e.g:

    List$ list = $([1,2,3,4,5]);
    list.first(3) -> [1,2,3];    //intelli-sense

Unlike jQuery (and like Underscore.js) mixin methods **do not** return a wrapped object so you can't chain your results like this:

    $([1,2,3,4,5]).first(3).sum()  //Warning does NOT work

Instead you need to wrap the response to use mixins on the resulting results, e.g:

    $( $([1,2,3,4,5]).first(3) ).sum() -> 6

## API

Most of the functions have been ported from [Underscore.js](http://underscorejs.org). As Dart doesn't yet support reflection or dynamically [invoking N-Arity functions](http://www.dartlang.org/articles/emulating-functions/) parts of Underscore like its Function, Currying and templating utils have not yet been ported over. 

The full list of methods

### List$ API

    []
    length
    value()
    sum()
    clone()
    insert()
    reverse()
    sort()
    reduce()        aliases: foldl, inject
    reduceRight()   aliases: foldr
    single()        aliases: find, detect
    filter()        aliases: select
    map()
    forEach()       aliases: each
    every()         aliases: all
    some()          aliases: any
    isEmpty()
    add()
    addLast()
    addAll()
    clear()
    removeLast()
    getRange()
    setRange()
    reject()
    pluck()
    include()       aliases: contains
    min()
    max()
    shuffle()
    sortBy()
    groupBy()
    sortedIndex()
    first()         aliases: head, take
    initial()
    last()
    rest()          aliases: tail
    compact()
    flatten()
    unique()        aliases: uniq
    join()

    static:
      fn()
      concat()
      zip()

### Map$ API
    
    []
    getKeys()       aliases: keys
    getValues()     aliases: values
    containsKey()   aliases: has
    containsValue() aliases: include, contains
    map()
    clone()
    max()
    min()
    functions()
    methods()
    pick()
    defaults()
    isEmpty()
    addAll()

    static:
      fn()

### String$ API

    escape()
    isBlank()
    trim()
    stripTags()
    capitalize()
    chars()
    lines()
    clean()
    replaceAllMatches()
    titleize()
    underscored()
    dasherize()
    humanize()
    succ()
    truncate()
    words()
    repeat()
    padLeft()       aliases: lpad
    padRight()      aliases: rpad
    padBoth()       aliases: lrpad
    reverse()
    split()
    splitOnFirst()
    splitOnLast()

    static:
      fn()
      debugString()

### Num$ API

    times()

    static:
      fn()

### Function$ API

    invoke()
    memoize()
    once()
    wrap()
    compose()
    after()

    static:
      fn()

### Mixin API (base class)

    length          aliases: size
    valueOf()
    isEqual()
    isElement()
    isArray()
    isObject()
    isFunction()
    isString()
    isNumber()
    isFinite()
    isNaN()
    isBoolean()
    isDate()
    isRegExp()
    isNull()
    isUndefined()
    isFalsy()
    isTruthy()
    isEmpty()
    toArray()
    each()
    map()
    collect()
    reduce()        aliases: foldl, inject
    reduceRight()   aliases: foldr
    result()
    indexOf()
    lastIndexOf()
    clone()
    identify()
    tap()
    toDebugString()

    static:
      uniqueId()
      range()

## Adding your own mixins

In addition to the above you may also want to have your own utility functions accessible from `$` (as done with jQuery plugins or Underscores mixins) which will make them more discoverable and less verbose than using common static class functions, they're also more testable since they can be mocked with stub methods in tests.

There are a couple of hooks available that will let you plug in your own mixins. 

The easiest way to do this is by attaching custom functions to the base Mixin class which takes advantage of Dart's **noSuchMethod** to call any matching methods that have been assigned, e.g:

### Registering adhoc Mixins

    Mixin.mixin({
      'myReverse': (string) => $( $(string.splitChars() ).reverse()).join('')
    });

Once registered they can now be called wrapped around any object, e.g:    

    $("test").myReverse() -> tset

Note: you cannot 'monkey patch' or override any built-in methods registered with the `Mixin.mixin()` since it only gets invoked when non-existing methods are called.

### Registering custom extensions

Another more direct and typed alternative to adding your own functionality is to register your own factory with `Mixin.registerFactory()` which provides a hook into introspecting all calls to `$()` and provides the option to return your own wrapped Mixin instance instead of the default one. 

For an example we'll register our own custom List extension methods by creating a custom class that extends from `List$`:  

    class MyListExtensions extends List$ {
        MyListExtensions(target) : super(target);

        double avg() => sum() / target.length;
        int count(predicate) => filter(predicate).length;
    }

Then we'll register a factory that returns this instance only for any invocations of `$(list)`

    Mixin.registerFactory((x) => x is List ? new MyListExtensions(x) : null);

We can now access all methods on our custom class like:

    $([20,30,50,100]).count()  -> 4
    $([20,30,50,100]).avg()    -> 50

The above is equivalent to:

    new MyListExtensions([20,30,50,100]).count()  -> 4
    new MyListExtensions([20,30,50,100]).avg()    -> 50

Which is exactly what is happening behind the scenes.

### Adding via pull-request

A more permanent way to add your utility methods is to submit them via a Github pull-request :) 

If your utility methods are useful and have broad appeal we'd love to include them (with tests!).

## The need for Mixins

Despite Dart being hailed as a 'batteries included' platform that includes a [Comprehensive Library](http://api.dartlang.org/index.html) it has some qualites that inhibits its ability to provide rich functionality around built-in types, namely:

   - Everything is an interface
   - Optional typing

### Everything is an interface

All core types in Dart (i.e nums, ints, strings, Lists, Maps, etc) are interfaces, which is great from an interoperability and versionability perspective but also means defining additional functionality causes un-due friction since it forces all interface implementors the burden of providing an implementation. For an illustrative example let's look at the [Collection](http://api.dartlang.org/dart_core/Collection.html) interface:

    Collection extends Iterable
        bool every(predicate)
        Collection filter(predicate)
        void forEach(lambda)
        bool isEmpty()
        int get length()
        Collection map(lambda)
        bool some(predicate)

Out of these only the `Iterable` interface and `length()` getter are required since the rest of the API could be added via Mixins, e.g: 

    Collection c = ..;
    void forEach(lambda) => for (var e in c) lambda(e);
    bool isEmpty() => c == null || c.length == 0;
    ...

Using a Mixin allows a single implementation to be shared by all collections - as promoted by this library, where all methods are available to all Collections, Maps, Strings, etc.

### Why doesn't Dart have Mixins already?

Whist the above illustrates why providing more functionality to the core interfaces is prohibitive, it doesn't explain why Dart doesn't have mixins built into the language despite being requested repeatedly in the mail group and code project. The main issue (I believe) is due to Dart's unsound type system:

### Optional typing

Dart's [optional typing](http://www.dartlang.org/articles/optional-types/) hits the producitivity sweet-spot of letting you rapidly prototype ideas **without care for types** (visibility, restrictions, ...) in a fast Run + Replay dev-cycle, quickly iterating until you reach the desired outcome. Once you're happy with the current behaviour you can optionally sprinkle additional type info to your program, tightening-it up and letting the type-checker in DartEditor highlight any obvious mistakes, catching errors at dev time - even before your next run.

To do this optional typing in Dart has no effect on the run-time behaviour of your program since all type info is erased at runtime. In this way they act like annotations whoose primary purpose is to assist the developer in describing the intent and semantics of their code. Since there's no type info at runtime, Dart doesn't support any language features relying on them like method overloading and C# Extension methods. 

### Fixed classes

Another issue preventing Mixins, is Dart types being fixed i.e. its definition is effectively locked at design-time (presumably for performance), meaning no Ruby-like mixins is possible whilst the lack of a JavaScript-like prototype property means there's currently no other mechanism to attach additional functionality to pre-defined types.

## Contributions

This project is still in active development, follow [@demisbellot](http://twitter.com/demisbellot) for updates.

Contributions to this project in code, tests, issues, wikis, etc are welcome. 

### Contributors

  - [mythz](https://github.com/mythz) (Demis Bellot)

### Future

  - After [substitute functions](http://www.dartlang.org/articles/emulating-functions/) have been implemented the `Mixin` class will be merged with the top-level `$` function.
  - After Dart's Mirror-based reflection is implemented the remaining function utils from Underscore.js will be ported over
  - Once Dart's package system is ready we'll add this library to it
  - Add documentation + website once library and API have matured 

