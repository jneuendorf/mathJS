// Generated by CoffeeScript 1.7.1

/**
 * @module mathJS
 * @main mathJS
*
 */

(function() {
  var __slice = [].slice,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.mathJS = {};

  window.mixOf = function() {
    var Mixed, base, method, mixin, mixins, name, _i, _ref;
    base = arguments[0], mixins = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    Mixed = (function(_super) {
      __extends(Mixed, _super);

      function Mixed() {
        return Mixed.__super__.constructor.apply(this, arguments);
      }

      return Mixed;

    })(base);
    for (_i = mixins.length - 1; _i >= 0; _i += -1) {
      mixin = mixins[_i];
      _ref = mixin.prototype;
      for (name in _ref) {
        method = _ref[name];
        Mixed.prototype[name] = method;
      }
    }
    return Mixed;
  };

  Array.prototype.reverseCopy = function() {
    var item, res, _i;
    res = [];
    for (_i = this.length - 1; _i >= 0; _i += -1) {
      item = this[_i];
      res.push(item);
    }
    return res;
  };

  Array.prototype.sample = function(n, forceArray) {
    var arr, elem, i, res;
    if (n == null) {
      n = 1;
    }
    if (forceArray == null) {
      forceArray = false;
    }
    if (n === 1) {
      if (!forceArray) {
        return this[Math.floor(Math.random() * this.length)];
      }
      return [this[Math.floor(Math.random() * this.length)]];
    }
    if (n > this.length) {
      n = this.length;
    }
    i = 0;
    res = [];
    arr = this.clone();
    while (i++ < n) {
      console.log(arr);
      elem = arr.sample(1);
      res.push(elem);
      arr.remove(elem);
    }
    return res;
  };

  Array.prototype.shuffle = function() {
    var arr, elem, i, _i, _len;
    arr = this.sample(this.length);
    for (i = _i = 0, _len = arr.length; _i < _len; i = ++_i) {
      elem = arr[i];
      this[i] = elem;
    }
    return this;
  };

  Array.prototype.first = function() {
    return this[0];
  };

  Array.prototype.last = function() {
    return this[this.length - 1];
  };

  Array.prototype.average = function() {
    var elem, elems, sum, _i, _len;
    sum = 0;
    elems = 0;
    for (_i = 0, _len = this.length; _i < _len; _i++) {
      elem = this[_i];
      if (!(Math.isNum(elem))) {
        continue;
      }
      sum += elem;
      elems++;
    }
    return sum / elems;
  };

  Array.prototype.median = Array.prototype.average;

  Array.prototype.clone = Array.prototype.slice;

  Array.prototype.remove = function(elem) {
    var idx;
    idx = this.indexOf(elem);
    if (idx > -1) {
      this.splice(idx, 1);
    }
    return this;
  };

  Array.prototype.removeAll = function(elements) {
    var elem, _i, _len;
    if (elements == null) {
      elements = [];
    }
    for (_i = 0, _len = elements.length; _i < _len; _i++) {
      elem = elements[_i];
      this.remove(elem);
    }
    return this;
  };

  Array.prototype.removeAt = function(idx) {
    this.splice(idx, 1);
    return this;
  };


  /**
   * @method getMax
   * @param {Function} propertyGetter
   * The passed callback extracts the value being compared from the array elements.
   * @return {Array} An array of all maxima.
  *
   */

  Array.prototype.getMax = function(propertyGetter) {
    var elem, max, res, val, _i, _len;
    max = null;
    res = [];
    if (propertyGetter == null) {
      propertyGetter = function(item) {
        return item;
      };
    }
    for (_i = 0, _len = this.length; _i < _len; _i++) {
      elem = this[_i];
      val = propertyGetter(elem);
      if (val > max || max === null) {
        max = val;
        res = [elem];
      } else if (val === max) {
        res.push(elem);
      }
    }
    return res;
  };

  Array.prototype.getMin = function(propertyGetter) {
    var elem, min, res, val, _i, _len;
    min = null;
    res = [];
    if (propertyGetter == null) {
      propertyGetter = function(item) {
        return item;
      };
    }
    for (_i = 0, _len = this.length; _i < _len; _i++) {
      elem = this[_i];
      val = propertyGetter(elem);
      if (val < min || min === null) {
        min = val;
        res = [elem];
      } else if (val === min) {
        res.push(elem);
      }
    }
    return res;
  };

  String.prototype.camel = function(spaces) {
    var i, str, _i, _ref;
    if (spaces == null) {
      spaces = false;
    }
    str = this.toLowerCase();
    if (spaces) {
      str = str.split(" ");
      for (i = _i = 1, _ref = str.length; 1 <= _ref ? _i < _ref : _i > _ref; i = 1 <= _ref ? ++_i : --_i) {
        str[i] = str[i].charAt(0).toUpperCase() + str[i].substr(1);
      }
      str = str.join("");
    }
    return str;
  };

  String.prototype.antiCamel = function() {
    var i, res, temp, _i, _ref;
    res = this.charAt(0);
    for (i = _i = 1, _ref = this.length; 1 <= _ref ? _i < _ref : _i > _ref; i = 1 <= _ref ? ++_i : --_i) {
      temp = this.charAt(i);
      if (temp === temp.toUpperCase()) {
        res += " ";
      }
      res += temp;
    }
    return res;
  };

  String.prototype.firstToUpperCase = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
  };

  String.prototype.snakeToCamelCase = function() {
    var char, prevChar, res, _i, _len;
    res = "";
    for (_i = 0, _len = this.length; _i < _len; _i++) {
      char = this[_i];
      if (char !== "_") {
        if (prevChar !== "_") {
          res += char;
        } else {
          res += char.toUpperCase();
        }
      }
      prevChar = char;
    }
    return res;
  };

  String.prototype.camelToSnakeCase = function() {
    var char, prevChar, res, _i, _len;
    res = "";
    prevChar = null;
    for (_i = 0, _len = this.length; _i < _len; _i++) {
      char = this[_i];
      if (char === char.toLowerCase()) {
        res += char;
      } else {
        if (prevChar === prevChar.toLowerCase()) {
          res += "_" + char.toLowerCase();
        } else {
          res += char;
        }
      }
      prevChar = char;
    }
    return res;
  };


  /**
   * This function checks if a given parameter is a (plain) number.
   * @method isNum
   * @param {Number} num
   * @return {Boolean} Whether the given number is a Number (excluding +/-Infinity)
  *
   */

  mathJS.isNum = function(r) {
    return (typeof r === "number") && !isNaN(r) && r !== Infinity && r !== -Infinity;
  };


  /**
   * This function returns a random (plain) integer between max and min (both inclusive).
   * @method randInt
   * @param {Number} max
   * @param {Number} min
   * @return {Number} Random integer.
  *
   */

  mathJS.randInt = function(max, min) {
    if (min == null) {
      min = 0;
    }
    return Math.floor(Math.random() * (max + 1 - min)) + min;
  };


  /**
   * This function returns a random number between max and min (both inclusive).
   * @method randNum
   * @param {Number} max
   * @param {Number} min
   * Default is 0.
   * @return {Integer} Random number.
  *
   */

  mathJS.randNum = function(max, min) {
    if (min == null) {
      min = 0;
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
    if (n != null) {
      if (n < 0) {
        return -1;
      }
      return 1;
    }
    return null;
  };


  /**
   * @abstract
   * @class Number
   * @constructor
   * @param {Number} value
   * @extends Object
  *
   */

  mathJS.Number = (function() {
    Number._pool = [];

    Number.fromPool = function(val) {
      var number;
      if (this._pool.length > 0) {
        number = this._pool.pop();
        number.value = val;
        return number;
      } else {
        return new Number(val);
      }
    };

    Number.parse = function(str) {
      return this.fromPool(parseFloat(str));
    };

    Number.getRandom = function(max, min) {
      return this.fromPool(mathJS.randNum(max, min));
    };

    function Number(value) {
      var fStr;
      if (!this._valueIsValid(value)) {
        fStr = arguments.callee.caller.toString();
        throw new Error("mathJS: Expected plain number! Given " + value + " at '" + (fStr.substring(0, fStr.indexOf(")") + 1)) + "'");
      }
      Object.defineProperty(this, "value", {
        get: this._getValue.bind(this),
        set: this._setValue.bind(this, value)
      });
      this.value = this._getValueFromParam(value);
    }

    Number.prototype._setValue = function(value) {
      if (this._valueIsValid(value)) {
        this._value = this._getValueFromParam(value);
      }
      return this;
    };

    Number.prototype._getValue = function() {
      return this._value;
    };

    Number.prototype._valueIsValid = function(value) {
      return (value != null) && (value instanceof this.constructor || mathJS.isNum(value));
    };


    /**
    * This method gets the value from a <b>valid</b> parameter. The validity is determined by this._valueIsValid().
    * @method _getValueFromParam
    * @param {Number} param
    *
    *
     */

    Number.prototype._getValueFromParam = function(param) {
      var value;
      if (param instanceof mathJS.Number) {
        value = param.value;
      } else if (mathJS.isNum(param)) {
        value = param;
      }
      return value;
    };

    Number.prototype.plus = function(n) {
      return this.constructor.fromPool(this.value + n);
    };

    Number.prototype.increase = function(n) {
      this.value += n;
      return this;
    };

    Number.prototype.minus = function(n) {
      return this.constructor.fromPool(this.value - n);
    };

    Number.prototype.decrease = function(n) {
      this.value -= n;
      return this;
    };

    Number.prototype.times = function(n) {
      return this.constructor.fromPool(this.value * n);
    };

    Number.prototype.clone = function() {
      return this.constructor.fromPool(this.value);
    };

    Number.prototype.divide = function(n) {
      return this.constructor.fromPool(this.value / n);
    };

    Number.prototype.sign = function() {
      return mathJS.sign(this.value);
    };

    Number.prototype.release = function() {
      this.constructor._pool.push(this);
      return this.constructor;
    };

    return Number;

  })();

  mathJS.Double = (function(_super) {
    __extends(Double, _super);

    function Double(value) {
      Double.__super__.constructor.apply(this, arguments);
    }

    return Double;

  })(mathJS.Number);

  mathJS.Int = (function(_super) {
    __extends(Int, _super);

    function Int(value) {}

    return Int;

  })(mathJS.Number);

  mathJS.Fraction = (function(_super) {
    __extends(Fraction, _super);

    function Fraction(enumerator, denominator) {
      this.enumerator = enumerator;
      this.denominator = denominator;
      Object.defineProperty(this, "value", {
        get: function() {
          return this.enumerator / this.denominator;
        }
      });
    }

    return Fraction;

  })(mathJS.Number);

  mathJS.Set = (function() {
    function Set() {}

    Set.prototype.add = function() {};

    Set.prototype.remove = function() {};

    Set.prototype.union = function() {};

    Set.prototype.intersect = function() {};

    Set.prototype.complement = function() {};


    /**
    * a.without b => returns: removed all common elements from a
    *
     */

    Set.prototype.without = function() {};

    return Set;

  })();

  mathJS.SpecificSet = (function(_super) {
    __extends(SpecificSet, _super);

    function SpecificSet(args) {}

    return SpecificSet;

  })(mathJS.Set);

  mathJS.ConditionalSet = (function(_super) {
    __extends(ConditionalSet, _super);

    function ConditionalSet(args) {}

    return ConditionalSet;

  })(mathJS.Set);

  mathJS.Function = (function(_super) {
    __extends(Function, _super);

    function Function(fromSet, toSet, mapping) {
      this.fromSet = fromSet;
      this.toSet = toSet;
      this.mapping = mapping;
    }

    return Function;

  })(mathJS.ConditionalSet);

  $(document).ready(function() {
    return console.log("dom ready");
  });

}).call(this);