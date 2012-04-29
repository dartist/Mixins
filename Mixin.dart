#library("Mixin");
#import("dart:core");

typedef IteratorFn(memo, value);
typedef bool _Predicate(item);
typedef Dynamic Expr(item);

class $TypeError {
  String msg;
  $TypeError(this.msg) {
//    print("TypeError $msg");
  }
  static type(x) => x is $TypeError;
}

_isFalsy(e) => e == null || e == false || e == 0 || e == double.NAN || e == '';
_cloneList(List from) {
  List to = [];
  for (var item in from) to.add(item);
  return to;
}
_cloneMap(Map from) {
  Map to = {};
  for (var key in from.getKeys())
    to[key] = from[key];
  return to;
}

$(target){
  for (Function factory in Mixin.factories) {
    var $target = factory(target);
    if ($target != null) return $target;
  }
  return target;
}

//TODO: rename to $ when dart supports callable classes
class Mixin {
  var e;
  Mixin(this.e);

  static List _factories;
  static List get factories() {
    if (_factories == null) {
      _factories = [
        (target) => target is Mixin ? target : null,
        (target) => target is Collection ? new $List(target) : null, 
        (target) => target is Map ? new $Map(target) : null,
        (target) => target is String ? new $String(target) : null,
        (target) => new Mixin(target),
      ];
    }
    return _factories;
  }
  valueOf() => e;
  bool isEqual(to) => e == to;
  bool isElement() => e != null && e['nodeType'] == 1;
  bool isArray() => e is List;
  bool isObject() => e == null ? false : e is Object && !(e is String || e is num || e is bool);
  bool isFunction() => e is Function;
  bool isString() => e is String;
  bool isNumber() => e is num;
  bool isFinite() => e is num && !e.isNaN() && !e.isInfinite();
  bool isNaN() => e == null ? false : e.isNaN();
  bool isBoolean() => e is bool;
  bool isDate() => e is Date;
  bool isRegExp() => e is RegExp;
  bool isNull() => e == null;
  bool isUndefined() => isNull(); 
  bool isFalsy() => _isFalsy(e); 
  bool isTruthy() => !_isFalsy(e); 
  int size() => e.length;
  bool isEmpty() => e is RegExp ? true : _isFalsy(e);

  List toArray() => e == null ? 
      [] : 
    e is List ? 
      _cloneList(e) : 
    e is Map ? 
      (e['toArray'] is Function ?
        e['toArray']() :
        e.getValues())
    : new List.from(e);
        
  void each(f(x)) {
    if (e == null) return;
    e.forEach(f);
  }
  void forEach(f(x)) => each(f);
  
  map(f(x)) {
    if (e == null) return [];
    return e.map(f);
  }
  void collect(f(x)) => map(f);
  
  reduce(f(x,y), [memo]) {
    if (e == null)
      if (memo == null)
        throw new $TypeError('Reduce of empty array with no initial value');
      else return memo;
    return $List.wrap(e).reduce(f,memo);
  }
  void foldl(f(x,y), [memo]) => reduce(f,memo);
  void inject(f(x,y), [memo]) => reduce(f,memo);
  
  reduceRight(f(x,y), [memo]) => e == null 
      ? reduce(f,memo) //same behavior if null
      : $List.wrap(e).reduceRight(f,memo);  
  void foldr(f(x,y), [memo]) => reduceRight(f,memo);
  
  static int _idCounter = 0;
  static uniqueId ([prefix]) {
    int id = _idCounter++;
    return prefix == null ? "$prefix$id" : id;
  }
  
  times(iterator(int n)) {
    for (int i = 0; i < e; i++) iterator(i);
  }  
  
  result(key) { 
    if (e == null) return null;
    var val = e[key];
    return val is Function ? val(e) : val;
  }
  
  indexOf(needle) {
    if (e == null || needle == null) return -1;
    return e.indexOf(needle);
  }
  
  lastIndexOf(needle) {
    if (e == null || needle == null) return -1;
    return e.lastIndexOf(needle);
  }
  
  clone() => e is List ? _cloneList(e) : e is Map ? _cloneMap(e) : e;
  
  functions() { throw "Reflection Api not supported in Dart yet"; }
  
  static Map _mixins;
  static void mixin (obj) {
    if (_mixins == null) _mixins = {}; //TODO: remove after Dart gets static lazy initialization
    $Map.wrap(obj).functions().forEach((name){
      _mixins[name] = obj[name];
    });
  }

  noSuchMethod(name, args) {
    if (_mixins == null) _mixins = {}; //TODO: remove after Dart gets static lazy initialization
    Function fn = _mixins[name];
    if (fn == null) throw new $TypeError('Method $name not implemented');
    var len = args.length;
    //TODO replace with generic sln when Dart gets varargs + Function call/apply ops
    print("calling fn with $len args..");
    return len == 0 
        ? fn(e)
        : len == 1
          ? fn(e, args[0])
          : len == 2
            ? fn(e, args[0],args[1])
            : fn(e, args[0],args[1],args[2]);
  }
  
  static identity(x) => x;
    
  static List range ([start=0, stop=null, step=1]) {
    if (stop==null) {
      stop = start;
      start = 0;
    }

    int len = Math.max(((stop - start) / step).ceil(), 0).toInt();
    int idx = 0;
    List res = new List(len);

    while(idx < len) {
      res[idx++] = start;
      start += step;
    }

    return res;
  }
  
  tap(Expr interceptor) {
    interceptor(e);
    return e;
  }  
    
  String toDebugString() => $String.debugString(e);
}

class $String extends Mixin {
  String target;
  $String(target) : super(target) {
    this.target = target == null 
      ? ""
      : target is String 
        ? target 
        : "$target";
  }
  
  String escape() =>
    '$e'.replaceAll(new RegExp("&"), '&amp;')
        .replaceAll(new RegExp("<"), '&lt;')
        .replaceAll(new RegExp(">"), '&gt;')
        .replaceAll(new RegExp('"'), '&quot;')
        .replaceAll(new RegExp("'"), '&#x27;')
        .replaceAll(new RegExp('/'),'&#x2F;');
  
  static String debugString(str) => 
    "$str".replaceAll("[", "")
          .replaceAll("]", "")
          .replaceAll("null", "")
          .replaceAll(" ", "");
}

class $List extends Mixin {
  List target;
  $List(target) : super(target) {
    this.target = target == null 
      ? []
      : target is List 
        ? target 
        : new List.from(target);
  }
  
  operator [](int index) => target[index];
  void operator []=(int index, value) {
    target[index] = value;
  } 

  static $List wrap(list) => new $List(list);
  List get value() => target;
  num sum() => reduce((memo, value) => memo + value, 0);
  List clone() => _cloneList(target);
  
  List reverse() {
    List to = new List();
    int i=target.length;
    while (--i>=0) to.add(target[i]);
    return to; 
  }
  
  List sort([int comparer(x,y)]) { 
    if (comparer == null) comparer=(x,y) => x.compareTo(y);
    target.sort(comparer); 
    return target; 
  }
  
  reduce(IteratorFn iterator, [memo]) {
    bool hasInitial = memo != null;
    target.forEach((value) {
      if (!hasInitial) {
        memo = value;
        hasInitial = true;
      } else {
        memo = iterator(memo, value);
      }
    });
    if (!hasInitial) throw new $TypeError('Reduce of empty array with no initial value');
    return memo;
  }
  foldl(IteratorFn iterator,  [memo]) => reduce(iterator, memo); 
  inject(IteratorFn iterator, [memo]) => reduce(iterator, memo); 

  reduceRight(IteratorFn iterator, [memo]) => wrap(reverse()).reduce(iterator, memo);
  foldr(IteratorFn iterator, [memo]) => reduceRight(iterator, memo); 
  
  single(_Predicate match) {
    var res;
    for (var value in target) {
      if (match(value)) {
        res = value;
        break;
      }
    }
    return res;
  }
  find(_Predicate match)   => single(match);
  detect(_Predicate match) => single(match);
  
  List filter(_Predicate match) => target.filter(match);
  List select(_Predicate match) => target.filter(match);
  List map(Function convert) => target.map(convert);
  void forEach(Function f) => target.forEach(f);
  void each(Function f) => target.forEach(f);
  bool every(_Predicate match) => target.every(match);
  bool all(_Predicate match) => every(match);
  bool some([_Predicate match]) => target.some(match != null ? match : (x) => !_isFalsy(x));
  bool any([_Predicate match]) => some(match);
  bool isEmpty() => target.isEmpty();
  int get length() => target.length;
  void add(item) => target.add(item);
  void addLast(item) => target.addLast(item);
  void addAll(Collection collection) => target.addAll(collection);
  void clear() => target.clear();
  removeLast() => target.removeLast();
  List getRange(int start, int length) => target.getRange(start, length);
  void setRange(int start, int length, List from, [int startFrom]) => target.setRange(start, length, from, startFrom);
  
  reject(_Predicate match) => target.filter((x) => !match(x));
  
  List pluck(String key) => map((value) => value[key]);
  
  include(item) => target.indexOf(item) != -1;
  contains(item) => include(item);
  
  static final int MaxInt = 2^32-1;
  Date MinDate; //TODO: use lazy static initialization when available
  max([Expr expr]) {
    if (MinDate == null) MinDate = new Date.fromEpoch(0, new TimeZone.utc());
    if (isEmpty()) return double.NEGATIVE_INFINITY;
    var firstArg = target[0];
    var res = {'computed': firstArg is Date ? MinDate : double.NEGATIVE_INFINITY};
    each((value) {
      var computed = expr != null ? expr(value) : value;
      computed.compareTo(res['computed']) >= 0 && (res = {'value': value, 'computed': computed}) != null;
    });
    return res['value'];
  }
  
  Date MaxDate; //TODO: use lazy static initialization when available
  min([Expr expr]) {
    if (isEmpty()) return double.INFINITY;
    if (MaxDate == null) MaxDate = new Date.fromEpoch(MaxInt, new TimeZone.utc());
    var firstArg = target[0];
    var res = {'computed': firstArg is Date ? MaxDate : double.INFINITY};
    each((value) {
      var computed = expr != null ? expr(value) : value;
      computed.compareTo(res['computed']) < 0 && (res = {'value': value, 'computed': computed}) != null;
    });
    return res['value'];
  }
  
  shuffle() {
    List shuffled = clone();
    int index=0;
    each((value) {
      int rand = (Math.random() * (index + 1)).floor().toInt();
      shuffled[index] = shuffled[rand];
      shuffled[rand] = value;
      index++;
    });
    return shuffled;
  }  
  
  sortBy(val) {
    List l = [2,3,4];
    Function iterator = val is Function ? val : (obj) => obj[val];
    return wrap(
      wrap(
        map((value) => {
          'value': value,
          'criteria': iterator(value)
        })
      )
      .sort((left, right) {
        var a = left['criteria'], b = right['criteria'];
        if (a == null) return 1;
        if (b == null) return -1;
        return a.compareTo(b);
      })
    ).pluck('value');
  }
  
  Map groupBy(val) {
    Map res = {};
    Function iterator = val is Function ? val : (obj) => obj[val];
    each((value) {
      var key = iterator(value);
      if (res["$key"] == null) res["$key"] = [];
      res["$key"].add(value);
    });
    return res;
  }
  
  sortedIndex(obj, [Function iterator]) {
    if (iterator == null) iterator = Mixin.identity;
    int low = 0, high = target.length;
    while (low < high) {
      var mid = (low + high) >> 1;
      iterator(target[mid]) < iterator(obj) ? low = mid + 1 : high = mid;
    }
    return low;
  }
  
  first([int n]) => n != null 
      ? target.getRange(0, n <= target.length ? n : target.length) 
      : target[0];
  head([int n]) => first(n);
  take([int n]) => first(n);

  initial([int n]) => target.getRange(0, target.length - (n == null ? 1 : n));
  
  last([int n]) {
    if (n == null) return target.last(); 
    int startAt = Math.max(target.length - n, 0);
    return target.getRange(startAt, target.length - startAt);
  }
  
  rest([int n]) => target.getRange(n == null ? 1 : n, target.length - (n == null ? 1 : n));  
  tail([int n]) => rest(n);
  
  compact() => filter((value) => _isFalsy(value));
  
  List flatten([shallow=false]) {
    return reduce((List memo, value) {
      if (value is List) 
        memo.addAll(shallow ? value : wrap(value).flatten());
      else 
        memo.add(value);
      return memo;
    }, []);
  }
  
  uniq([isSorted=false, iterator]) {
    var init = iterator is Function ? map(iterator) : target;
    List results = [];
    // The `isSorted` flag is irrelevant if the array only contains two elements.
    if (target.length < 3) isSorted = true;
    int index = 0;
    wrap(init).reduce((List memo, value) {
      bool exists = isSorted ? memo.length == 0 || memo.last() != value : memo.indexOf(value) == -1;
      if (exists) {
        memo.add(value);
        results.add(target[index]);
      }
      index++;
      return memo;
    },[]);
    return results;
  }
  unique([isSorted, iterator]) => uniq(isSorted, iterator);
  
  join([delim=',']) => reduce((memo,x) => memo.isEmpty() ? "$x" : "$memo$delim$x","");
//  join([delim=',']) => Strings.join(target, delim);  
  
  static concat(List<List> lists) {
    List to = [];
    lists.forEach((x) => to.addAll(x));
    return to;
  }
    
  //TODO: replace with varargs
  intersection(List<List> with) =>
    uniq().filter((item) =>
      with.every( (other) => other.indexOf(item) >= 0 )
    ); 
  intersect(List<List> with) => intersection(with);
  
  difference(List<List> with) {
    List _rest = wrap(with).flatten(true);
    return filter((value) => !wrap(_rest).include(value) );
  }
  without(List<List> with) => difference(with);
  union(List<List> with) => wrap(wrap(concat([target,with])).flatten(true)).uniq();
  
  static zip(List args) {
    int length = wrap(args.map((x) => x.length)).max();
    List results = new List(length);
    var $args = $(args);
    for (int i = 0; i < length; i++) results[i] = $args.map((x) => i < x.length ? x[i] : null);
    return results;
  }
  
//TODO: requires currying
//  invoke (method) {
//    var args = slice.call(arguments, 2);
//    return _.map(obj, function(value) {
//      return (_.isFunction(method) ? method || value : value[method]).apply(value, args);
//    });
//  };    
}

class $Map extends Mixin {
  Map target;
  $Map(target) : super(target) {
    this.target = target == null ? {} : target;
  }
  
  static $Map wrap(e) => new $Map(e);
  
  Collection keys() => target.getKeys();
  Collection values() => target.getValues();
  
  map(iterator(val)) {
    Map res = {};    
    for (var key in target.getKeys()){
      res[key] = iterator(target[key]);
    }
    return res;
  }

  clone() => _cloneMap(target);
  
  include(item) => target.containsValue(item);
  contains(item) => include(item);
  max([Expr expr]) => $List.wrap(target.getValues()).max(expr);
  min([Expr expr]) => $List.wrap(target.getValues()).min(expr);

  List functions() {
    List<String> names = [];
    for (var key in target.getKeys()) {
      if (target[key] is Function) names.add(key);
    }
    names.sort((String x, String y) => x.compareTo(y));
    return names;
  }
  methods() => functions();
  
  //TODO: Change to var args
  pick(List names) {
    Map res = {};
    for (var key in $(names).flatten()) {
      if (target.containsKey("$key")) res["$key"] = target["$key"];
    }
    return res;
  }

  //TODO: support varargs defaultProps
  defaults(defaultProps) {
    if (defaultProps is Map) defaultProps = [defaultProps];
    defaultProps.forEach((source) {
      source.forEach((key, value){
        if (!target.containsKey(key)) target[key] = value;
      });
    });
    return target;
  }

//  _.extend Requires Reflection  

  isEmpty() => target.isEmpty();  
  
  has() => target.containsKey(target);
}
