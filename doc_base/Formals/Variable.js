// Generated by CoffeeScript 1.8.0

/**
* @class Variable
* @constructor
* @param {String} symbol
* This is name name of the variable (mathematically)
* @param {Function|Class} type
* @param {Object} value
* Optional. This param is passed upon evaluation.
*
 */

(function() {
  mathJS.Variable = (function() {
    function Variable(symbol, type, value) {
      if (type == null) {
        type = mathJS.Number;
      }
      this.symbol = symbol;
      this.type = type;
      this.value = value;
    }

    Variable.prototype.plus = function(x) {
      var _base;
      return (typeof (_base = this.value).plus === "function" ? _base.plus(x) : void 0) || null;
    };

    Variable.prototype.minus = function(x) {
      var _base;
      return (typeof (_base = this.value).minus === "function" ? _base.minus(x) : void 0) || null;
    };

    Variable.prototype.times = function(x) {
      var _base;
      return (typeof (_base = this.value).times === "function" ? _base.times(x) : void 0) || null;
    };

    Variable.prototype.divide = function(x) {
      var _base;
      return (typeof (_base = this.value).divide === "function" ? _base.divide(x) : void 0) || null;
    };

    return Variable;

  })();

}).call(this);
