// Generated by CoffeeScript 1.9.3

/**
 * @abstract
 * @class Complex
 * @constructor
 * @param {Number} real
 * Real part of the number. Either a mathJS.Number or primitive number.
 * @param {Number} image
 * Real part of the number. Either a mathJS.Number or primitive number.
 * @extends Number
*
 */

(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  mathJS.Complex = (function(superClass) {
    var PARSE_KEY;

    extend(Complex, superClass);

    PARSE_KEY = "0c";


    /**
    * @Override
    * This method creates an object with the keys "real" and "img" which have primitive numbers as their values.
    * @static
    * @method _getValueFromParam
    * @param {Complex|Number} real
    * @param {Number} img
    * @return {Object}
    *
     */

    Complex._getValueFromParam = function(real, img) {
      if (real instanceof mathJS.Complex) {
        return {
          real: real.real,
          img: real.img
        };
      }
      if (real instanceof mathJS.Number && img instanceof mathJS.Number) {
        return {
          real: real.value,
          img: img.value
        };
      }
      if (mathJS.isNum(real) && mathJS.isNum(img)) {
        return {
          real: real,
          img: img
        };
      }
      return null;
    };

    Complex._fromPool = function(real, img) {
      var number;
      if (this._pool.length > 0) {
        if (this._valueIsValid(real) && this._valueIsValid(img)) {
          number = this._pool.pop();
          number.real = real;
          number.img = img;
          return number;
        }
        return null;
      } else {
        return new this(real, img);
      }
    };

    Complex.parse = function(str) {
      var idx, img, parts, real;
      idx = str.toLowerCase().indexOf(PARSE_KEY);
      if (idx >= 0) {
        parts = str.substring(idx + PARSE_KEY.length).split(",");
        if (mathJS.isNum(real = parseFloat(parts[0])) && mathJS.isNum(img = parseFloat(parts[1]))) {
          return this._fromPool(real, img);
        }
      }
      return NaN;
    };

    Complex.random = function(max1, min1, max2, min2) {
      return this._fromPool(mathJS.randNum(max1, min1), mathJS.randNum(max2, min2));
    };

    function Complex(real, img) {
      var values;
      values = this._getValueFromParam(real, img);
      Object.defineProperties(this, {
        real: {
          get: this._getReal,
          set: this._setReal
        },
        img: {
          get: this._getImg,
          set: this._setImg
        },
        _fromPool: {
          value: this.constructor._fromPool.bind(this.constructor),
          writable: false,
          enumarable: false,
          configurable: false
        }
      });
      this.real = values.real;
      this.img = values.img;
    }

    Complex.prototype._setReal = function(value) {
      if (this._valueIsValid(value)) {
        this._real = value.value || value.real || value;
      }
      return this;
    };

    Complex.prototype._getReal = function() {
      return this._real;
    };

    Complex.prototype._setImg = function(value) {
      if (this._valueIsValid(value)) {
        this._img = value.value || value.img || value;
      }
      return this;
    };

    Complex.prototype._getImg = function() {
      return this._img;
    };

    Complex.prototype._getValueFromParam = Complex._getValueFromParam;


    /**
    * This method check for mathmatical equality. This means new mathJS.Double(4.2).equals(4.2)
    * @method equals
    * @param {Number} n
    * @return {Boolean}
    *
     */

    Complex.prototype.equals = function(r, i) {
      var values;
      values = this._getValueFromParam(r, i);
      if (values != null) {
        return this.real === values.real && this.img === values.img;
      }
      return false;
    };

    Complex.prototype.plus = function(r, i) {
      var values;
      values = this._getValueFromParam(r, i);
      if (values != null) {
        return this._fromPool(this.real + values.real, this.img + values.img);
      }
      return NaN;
    };

    Complex.prototype.increase = function(r, i) {
      var values;
      values = this._getValueFromParam(r, i);
      if (values != null) {
        this.real += values.real;
        this.img += values.img;
      }
      return this;
    };

    Complex.prototype.plusSelf = Complex.increase;

    Complex.prototype.minus = function(n) {
      var values;
      values = this._getValueFromParam(r, i);
      if (values != null) {
        return this._fromPool(this.real - values.real, this.img - values.img);
      }
      return NaN;
    };

    Complex.prototype.decrease = function(n) {
      var values;
      values = this._getValueFromParam(r, i);
      if (values != null) {
        this.real -= values.real;
        this.img -= values.img;
      }
      return this;
    };

    Complex.prototype.minusSelf = Complex.decrease;

    Complex.prototype.times = function(r, i) {
      var values;
      values = this._getValueFromParam(r, i);
      if (values != null) {
        return this._fromPool(this.real * values.real, this.img * values.img);
      }
      return NaN;
    };

    Complex.prototype.timesSelf = function(n) {
      this.value *= _getValueFromParam(n);
      return this;
    };

    Complex.prototype.divide = function(n) {
      return this._fromPool(this.value / _getValueFromParam(n));
    };

    Complex.prototype.divideSelf = function(n) {
      this.value /= _getValueFromParam(n);
      return this;
    };

    Complex.prototype.square = function() {
      return this._fromPool(this.value * this.value);
    };

    Complex.prototype.squareSelf = function() {
      this.value *= this.value;
      return this;
    };

    Complex.prototype.cube = function() {
      return this._fromPool(this.value * this.value * this.value);
    };

    Complex.prototype.squareSelf = function() {
      this.value *= this.value * this.value;
      return this;
    };

    Complex.prototype.sqrt = function() {
      return this._fromPool(mathJS.sqrt(this.value));
    };

    Complex.prototype.sqrtSelf = function() {
      this.value = mathJS.sqrt(this.value);
      return this;
    };

    Complex.prototype.pow = function(n) {
      return this._fromPool(mathJS.pow(this.value, _getValueFromParam(n)));
    };

    Complex.prototype.powSelf = function(n) {
      this.value = mathJS.pow(this.value, _getValueFromParam(n));
      return this;
    };

    Complex.prototype.sign = function() {
      return mathJS.sign(this.value);
    };

    Complex.prototype.toInt = function() {
      return mathJS.Int._fromPool(mathJS.floor(this.value));
    };

    Complex.prototype.toDouble = function() {
      return mathJS.Double._fromPool(this.value);
    };

    Complex.prototype.toString = function() {
      return "" + PARSE_KEY + (this.real.toString()) + "," + (this.img.toString());
    };

    Complex.prototype.clone = function() {
      return this._fromPool(this.value);
    };

    Complex.prototype.release = function() {
      this.constructor._pool.push(this);
      return this.constructor;
    };

    return Complex;

  })(mathJS.Number);

}).call(this);
