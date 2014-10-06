// Generated by CoffeeScript 1.7.1
(function() {
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
      value: Number.EPSILON,
      writable: false
    },
    maxValue: {
      value: Number.MAX_VALUE,
      writable: false
    },
    minValue: {
      value: Number.MIN_VALUE,
      writable: false
    }
  });

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

  mathJS.parseNumber = function(str) {
    return null;
  };


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

  mathJS.isInt = function(r) {
    return mathJS.isNum(r) && mathJS.floor(r) === r;
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
    return Math.floor(Math.random() * (max + 1 - min)) + min;
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
    if (mathJS.isNum(n)) {
      if (n < 0) {
        return -1;
      }
      return 1;
    }
    return NaN;
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

}).call(this);
