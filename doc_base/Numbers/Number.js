// Generated by CoffeeScript 1.8.0

/**
 * @abstract
 * @class Number
 * @constructor
 * @param {Number} value
 * @extends Object
*
 */

(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  mathJS.Number = (function(_super) {
    __extends(Number, _super);

    Number._valueIsValid = function(value) {
      return value instanceof mathJS.Number || mathJS.isNum(value);
    };


    /**
    * This method gets the value from a parameter. The validity is determined by this._valueIsValid().
    * @static
    * @protected
    * @method _getValueFromParam
    * @param {Number} param
    * @param {Boolean} skipCheck
    * If `true` the given parameter is not (again) checked for validity. If the function that calls _getValueFromParam() has already checked the passed parameter this `skipCheck` should be set to true.
    * @return {Number} The primitive value or null.
    *
     */

    Number._getValueFromParam = function(param, skipCheck) {
      var value;
      if (!skipCheck && !this._valueIsValid(param)) {
        return null;
      }
      if (param instanceof mathJS.Number) {
        value = param.value;
      } else if (mathJS.isNum(param)) {
        value = param;
      }
      return value;
    };


    /**
    * @Override mathJS.Poolable
    * @static
    * @method fromPool
    *
     */

    Number.fromPool = function(val) {
      var number;
      if (this._pool.length > 0) {
        if (this._valueIsValid(val)) {
          number = this._pool.pop();
          number.value = val;
          return number;
        }
        return null;
      } else {
        return new this(val);
      }
    };


    /**
    * @Override mathJS.Parseable
    * @static
    * @method parse
    *
     */

    Number.parse = function(str) {
      var parsed;
      if (mathJS.isNum(parsed = parseFloat(str))) {
        return this.fromPool(parsed);
      }
      return parsed;
    };

    Number.random = function(max, min) {
      return this.fromPool(mathJS.randNum(max, min));
    };

    Number.toNumber = function(n) {
      if (n instanceof mathJS.Number) {
        return n;
      }
      return new mathJS.Number(n);
    };

    function Number(value) {
      var fStr;
      if (!this._valueIsValid(value)) {
        fStr = arguments.callee.caller.toString();
        throw new Error("mathJS: Expected plain number! Given " + value + " in '" + (fStr.substring(0, fStr.indexOf(")") + 1)) + "'");
      }
      Object.defineProperties(this, {
        value: {
          get: this._getValue,
          set: this._setValue
        },
        fromPool: {
          value: this.constructor.fromPool.bind(this.constructor),
          writable: false,
          enumarable: false,
          configurable: false
        }
      });
      this.value = this._getValueFromParam(value, true);
    }

    Number.prototype._setValue = function(value) {
      if (this._valueIsValid(value)) {
        this._value = this._getValueFromParam(value, true);
      }
      return this;
    };

    Number.prototype._getValue = function() {
      return this._value;
    };

    Number.prototype._valueIsValid = Number._valueIsValid;

    Number.prototype._getValueFromParam = Number._getValueFromParam;


    /**
    * @Override mathJS.Comparable
    * This method checks for mathmatical equality. This means new mathJS.Double(4.2).equals(4.2) is true.
    * @method equals
    * @param {Number} n
    * @return {Boolean}
    *
     */

    Number.prototype.equals = function(n) {
      return this.value === this._getValueFromParam(n);
    };


    /**
    * @Override mathJS.Orderable
    * This method check for mathmatical '<'. This means new mathJS.Double(4.2).lessThan(5.2) is true.
    * @method lessThan
    *
     */

    Number.prototype.lessThan = function(n) {
      return this.value < this._getValueFromParam(n);
    };


    /**
    * @Override mathJS.Orderable
    * This method check for mathmatical '>'. This means new mathJS.Double(4.2).greaterThan(3.2) is true.
    * @method greaterThan
    * @param {Number} n
    * @return {Boolean}
    *
     */

    Number.prototype.greaterThan = function(n) {
      return this.value > this._getValueFromParam(n);
    };


    /**
    * @Override mathJS.Orderable
    * This method check for mathmatical equality. This means new mathJS.Double(4.2).lessThanOrEqualTo(3.2) is true.
    * @method lessThanOrEqualTo
    * @param {Number} n
    * @return {Boolean}
    *
     */

    Number.prototype.lessThanOrEqualTo = function(n) {
      return this.value <= this._getValueFromParam(n);
    };


    /**
    * This method check for mathmatical equality. This means new mathJS.Double(4.2).lessThanOrEqualTo(3.2) is true.
    * @method greaterThanOrEqualTo
    * @param {Number} n
    * @return {Boolean}
    *
     */

    Number.prototype.greaterThanOrEqualTo = function(n) {
      return this.value >= this._getValueFromParam(n);
    };


    /**
    * This method adds 2 numbers and returns a new one.
    * @method plus
    * @param {Number} n
    * @return {Number} Calculated Number.
    *
     */

    Number.prototype.plus = function(n) {
      return this.fromPool(this.value + this._getValueFromParam(n));
    };


    /**
    * This method adds the given number to this instance.
    * @method increase
    * @param {Number} n
    * @return {Number} This instance.
    *
     */

    Number.prototype.increase = function(n) {
      this.value += this._getValueFromParam(n);
      return this;
    };


    /**
    * See increase().
    * @method plusSelf
    *
     */

    Number.prototype.plusSelf = Number.increase;


    /**
    * This method substracts 2 numbers and returns a new one.
    * @method minus
    * @param {Number} n
    * @return {Number} Calculated Number.
    *
     */

    Number.prototype.minus = function(n) {
      return this.fromPool(this.value - n);
    };

    Number.prototype.decrease = function(n) {
      this.value -= this._getValueFromParam(n);
      return this;
    };

    Number.prototype.minusSelf = Number.decrease;


    /**
    * This method multiplies 2 numbers and returns a new one.
    * @method times
    * @param {Number} n
    * @return {Number} Calculated Number.
    *
     */

    Number.prototype.times = function(n) {
      return this.fromPool(this.value * this._getValueFromParam(n));
    };

    Number.prototype.timesSelf = function(n) {
      this.value *= this._getValueFromParam(n);
      return this;
    };


    /**
    * This method divides 2 numbers and returns a new one.
    * @method divide
    * @param {Number} n
    * @return {Number} Calculated Number.
    *
     */

    Number.prototype.divide = function(n) {
      return this.fromPool(this.value / this._getValueFromParam(n));
    };

    Number.prototype.divideSelf = function(n) {
      this.value /= this._getValueFromParam(n);
      return this;
    };


    /**
    * This method squares this instance and returns a new one.
    * @method square
    * @return {Number} Calculated Number.
    *
     */

    Number.prototype.square = function() {
      return this.fromPool(this.value * this.value);
    };

    Number.prototype.squareSelf = function() {
      this.value *= this.value;
      return this;
    };


    /**
    * This method cubes this instance and returns a new one.
    * @method cube
    * @return {Number} Calculated Number.
    *
     */

    Number.prototype.cube = function() {
      return this.fromPool(this.value * this.value * this.value);
    };

    Number.prototype.cubeSelf = function() {
      this.value *= this.value * this.value;
      return this;
    };


    /**
    * This method calculates the square root of this instance and returns a new one.
    * @method sqrt
    * @return {Number} Calculated Number.
    *
     */

    Number.prototype.sqrt = function() {
      return this.fromPool(mathJS.sqrt(this.value));
    };

    Number.prototype.sqrtSelf = function() {
      this.value = mathJS.sqrt(this.value);
      return this;
    };


    /**
    * This method calculates the cubic root of this instance and returns a new one.
    * @method curt
    * @return {Number} Calculated Number.
    *
     */

    Number.prototype.curt = function() {
      return this.pow(1 / 3);
    };

    Number.prototype.curtSelf = function() {
      return this.powSelf(1 / 3);
    };


    /**
    * This method calculates any root of this instance and returns a new one.
    * @method plus
    * @param {Number} exponent
    * @return {Number} Calculated Number.
    *
     */

    Number.prototype.root = function(exp) {
      return this.pow(1 / exp);
    };

    Number.prototype.rootSelf = function(exp) {
      return this.powSelf(1 / exp);
    };


    /**
    * This method adds 2 numbers and returns a new one.
    * @method plus
    * @param {Number} n
    * @return {Number} Calculated Number.
    *
     */

    Number.prototype.reciprocal = function() {
      return this.fromPool(1 / this.value);
    };

    Number.prototype.reciprocalSelf = function() {
      this.value = 1 / this.value;
      return this;
    };


    /**
    * This method adds 2 numbers and returns a new one.
    * @method plus
    * @param {Number} n
    * @return {Number} Calculated Number.
    *
     */

    Number.prototype.pow = function(n) {
      return this.fromPool(mathJS.pow(this.value, this._getValueFromParam(n)));
    };

    Number.prototype.powSelf = function(n) {
      this.value = mathJS.pow(this.value, this._getValueFromParam(n));
      return this;
    };

    Number.prototype.sign = function() {
      return mathJS.sign(this.value);
    };

    Number.prototype.toInt = function() {
      return mathJS.Int.fromPool(mathJS.floor(this.value));
    };

    Number.prototype.toDouble = function() {
      return mathJS.Double.fromPool(this.value);
    };

    Number.prototype.toString = function() {
      return this.value.toString();
    };

    Number.prototype.clone = function() {
      return this.fromPool(this.value);
    };

    Number.prototype.release = function() {
      this.constructor._pool.push(this);
      return this.constructor;
    };

    return Number;

  })(mixOf(mathJS.Orderable, mathJS.Poolable, mathJS.Parseable));

}).call(this);
