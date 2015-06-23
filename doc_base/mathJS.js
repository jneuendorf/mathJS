// Generated by CoffeeScript 1.9.3
(function() {
  var modulo = function(a, b) { return (+a % (b = +b) + b) % b; },
    slice = [].slice;

  Object.defineProperties(mathJS, {
    e: {
      value: Math.E,
      writable: false
    },
    pi: {
      value: Math.PI,
      writable: false
    },
    ln2: {
      value: Math.LN2,
      writable: false
    },
    ln10: {
      value: Math.LN10,
      writable: false
    },
    log2e: {
      value: Math.LOG2E,
      writable: false
    },
    log10e: {
      value: Math.LOG10E,
      writable: false
    },
    infty: {
      value: Infinity,
      writable: false
    },
    infinity: {
      value: Infinity,
      writable: false
    },
    epsilon: {
      value: Number.EPSILON || 2.220446049250313e-16,
      writable: false
    },
    maxValue: {
      value: Number.MAX_VALUE,
      writable: false
    },
    minValue: {
      value: Number.MIN_VALUE,
      writable: false
    },
    id: {
      value: function(x) {
        return x;
      },
      writable: false
    }
  });

  mathJS.isPrimitive = function(x) {
    return typeof x === "string" || typeof x === "number" || typeof x === "boolean";
  };

  mathJS.isComparable = function(x) {
    return x.equals instanceof Function || mathJS.isPrimitive(x);
  };

  mathJS.equals = function(x, y) {
    return (typeof x.equals === "function" ? x.equals(y) : void 0) || (typeof y.equals === "function" ? y.equals(x) : void 0) || x === y;
  };

  mathJS.greaterThan = function(x, y) {
    return (typeof x.gt === "function" ? x.gt(y) : void 0) || (typeof y.lt === "function" ? y.lt(x) : void 0) || x > y;
  };

  mathJS.gt = mathJS.greaterThan;

  mathJS.lessThan = function(x, y) {
    return (typeof x.lt === "function" ? x.lt(y) : void 0) || (typeof y.gt === "function" ? y.gt(x) : void 0) || x < y;
  };

  mathJS.lt = mathJS.lessThan;

  mathJS.ggT = function() {
    var ggt, i, j, ref, vals;
    if (arguments[0] instanceof Array) {
      vals = arguments[0];
    } else {
      vals = Array.prototype.slice.apply(arguments);
    }
    if (vals.length === 2) {
      if (vals[1] === 0) {
        return vals[0];
      }
      return mathJS.ggT(vals[1], modulo(vals[0], vals[1]));
    } else if (vals.length > 2) {
      ggt = mathJS.ggT(vals[0], vals[1]);
      for (i = j = 2, ref = vals.length; 2 <= ref ? j < ref : j > ref; i = 2 <= ref ? ++j : --j) {
        ggt = mathJS.ggT(ggt, vals[i]);
      }
      return ggt;
    }
    return null;
  };

  mathJS.gcd = mathJS.ggT;

  mathJS.kgV = function() {
    var i, j, kgv, ref, vals;
    if (arguments[0] instanceof Array) {
      vals = arguments[0];
    } else {
      vals = Array.prototype.slice.apply(arguments);
    }
    if (vals.length === 2) {
      return Math.floor(vals[0] * vals[1] / mathJS.ggT(vals[0], vals[1]));
    } else if (vals.length > 2) {
      kgv = mathJS.kgV(vals[0], vals[1]);
      for (i = j = 2, ref = vals.length; 2 <= ref ? j < ref : j > ref; i = 2 <= ref ? ++j : --j) {
        kgv = mathJS.kgV(kgv, vals[i]);
      }
      return kgv;
    }
    return null;
  };

  mathJS.lcm = mathJS.kgV;

  mathJS.coprime = function(x, y) {
    return mathJS.gcd(x, y) === 1;
  };

  mathJS.ceil = Math.ceil;

  mathJS.floor = function(n) {
    return ~~n;
  };

  mathJS.floatToInt = mathJS.floor;

  mathJS.square = function(n) {
    if (mathJS.isNum(n)) {
      return n * n;
    }
    return NaN;
  };

  mathJS.cube = function(n) {
    if (mathJS.isNum(n)) {
      return n * n * n;
    }
    return NaN;
  };

  mathJS.pow = Math.pow;

  mathJS.sqrt = Math.sqrt;

  mathJS.curt = function(n) {
    if (mathJS.isNum(n)) {
      return mathJS.pow(n, 1 / 3);
    }
    return NaN;
  };

  mathJS.root = function(n, exp) {
    if (mathJS.isNum(n) && mathJS.isNum(exp)) {
      return mathJS.pow(n, 1 / exp);
    }
    return NaN;
  };

  mathJS.factorial = function(n) {
    if ((n = ~~n) < 0) {
      return NaN;
    }
    return mathJS.factorial.cache[n] || (mathJS.factorial.cache[n] = n * mathJS.factorial(n - 1));
  };

  mathJS.factorial.cache = [1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 39916800, 4.790016e8, 6.2270208e9, 8.71782912e10, 1.307674368e12];

  mathJS.fac = mathJS.factorial;

  mathJS.parseNumber = function(str) {
    return null;
  };

  mathJS.factorialInverse = function(n) {
    var x, y;
    if ((n = ~~n) < 0) {
      return NaN;
    }
    x = 0;
    while ((y = mathJS.factorial(++x)) < n) {}
    if (y === n) {
      return parseInt(x, 10);
    }
    return NaN;
  };

  mathJS.facInv = mathJS.factorialInverse;


  /**
   * This function checks if a given parameter is a (plain) number.
   * @method isNum
   * @param {Number} num
   * @return {Boolean} Whether the given number is a Number (excluding +/-Infinity)
  *
   */

  mathJS.isNum = function(n) {
    return (n != null) && isFinite(n);
  };

  mathJS.isMathJSNum = function(n) {
    return (n != null) && (isFinite(n) || n instanceof mathJS.Number || n["instanceof"](mathJS.Number));
  };

  mathJS.isInt = function(r) {
    return mathJS.isNum(r) && ~~r === r;
  };


  /**
   * This function returns a random (plain) integer between max and min (both inclusive). If max is less than min the parameters are swapped.
   * @method randInt
   * @param {Number} max
   * @param {Number} min
   * @return {Number} Random integer.
  *
   */

  mathJS.randInt = function(max, min) {
    if (max == null) {
      max = 1;
    }
    if (min == null) {
      min = 0;
    }
    return ~~mathJS.randNum(max, min);
  };


  /**
   * This function returns a random number between max and min (both inclusive). If max is less than min the parameters are swapped.
   * @method randNum
   * @param {Number} max
   * @param {Number} min
   * Default is 0.
   * @return {Integer} Random number.
  *
   */

  mathJS.randNum = function(max, min) {
    var temp;
    if (max == null) {
      max = 1;
    }
    if (min == null) {
      min = 0;
    }
    if (min > max) {
      temp = min;
      min = max;
      max = temp;
    }
    return Math.random() * (max + 1 - min) + min;
  };

  mathJS.radToDeg = function(rad) {
    return rad * 57.29577951308232;
  };

  mathJS.degToRad = function(deg) {
    return deg * 0.017453292519943295;
  };

  mathJS.sign = function(n) {
    n = n.value || n;
    if (mathJS.isNum(n)) {
      if (n < 0) {
        return -1;
      }
      return 1;
    }
    return NaN;
  };

  mathJS.min = function() {
    var elems, item, j, len, min, propGetter, res;
    elems = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    if (elems.first instanceof Array) {
      elems = elems.first;
      propGetter = null;
    } else if (elems.first instanceof Function) {
      propGetter = elems.first;
      elems = elems.slice(1);
      if (elems.first instanceof Array) {
        elems = elems.first;
      }
    }
    res = [];
    min = null;
    for (j = 0, len = elems.length; j < len; j++) {
      item = elems[j];
      if (propGetter != null) {
        item = propGetter(item);
      }
      if (min === null || item.lessThan(min) || item < min) {
        min = item;
        res = [elem];
      } else if (item.equals(min) || item === min) {
        res.push(elem);
      }
    }
    return res;
  };

  mathJS.max = function() {
    var elems, item, j, len, max, propGetter, res;
    elems = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    if (elems.first instanceof Array) {
      elems = elems.first;
      propGetter = null;
    } else if (elems.first instanceof Function) {
      propGetter = elems.first;
      elems = elems.slice(1);
      if (elems.first instanceof Array) {
        elems = elems.first;
      }
    }
    res = [];
    max = null;
    for (j = 0, len = elems.length; j < len; j++) {
      item = elems[j];
      if (propGetter != null) {
        item = propGetter(item);
      }
      if (max === null || item.greaterThan(max) || item > max) {
        max = item;
        res = [elem];
      } else if (item.equals(max) || item === max) {
        res.push(elem);
      }
    }
    return res;
  };

  mathJS.log = function(n, base) {
    if (base == null) {
      base = 10;
    }
    return Math.log(n) / Math.log(base);
  };

  mathJS.logBase = mathJS.log;

  mathJS.reciprocal = function(n) {
    if (mathJS.isNum(n)) {
      return 1 / n;
    }
    return NaN;
  };

  mathJS.sortFunction = function(a, b) {
    if (a.lessThan(b)) {
      return -1;
    }
    if (a.greaterThan(b)) {
      return 1;
    }
    return 0;
  };

}).call(this);
