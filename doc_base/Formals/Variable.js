// Generated by CoffeeScript 1.9.3

/**
* @class Variable
* @constructor
* @param {String} name
* This is name name of the variable (mathematically)
* @param {mathJS.Set} type
*
 */

(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  mathJS.Variable = (function(superClass) {
    extend(Variable, superClass);

    function Variable(name, elementOf) {
      if (elementOf == null) {
        elementOf = mathJS.Domains.N;
      }
      this.name = name;
      if (elementOf.getSet != null) {
        this.elementOf = elementOf.getSet();
      } else {
        this.elementOf = elementOf;
      }
    }

    Variable.prototype._getSet = function() {
      return this.elementOf;
    };

    Variable.prototype.equals = function(variable) {
      return this.name === variable.name && this.elementOf.equals(variable.elementOf);
    };

    Variable.prototype.plus = function(n) {
      return new mathJS.Expression("+", this, n);
    };

    Variable.prototype.minus = function(n) {
      return new mathJS.Expression("-", this, n);
    };

    Variable.prototype.times = function(n) {
      return new mathJS.Expression("*", this, n);
    };

    Variable.prototype.divide = function(n) {
      return new mathJS.Expression("/", this, n);
    };

    Variable.prototype["eval"] = function(values) {
      var val;
      if ((values != null) && ((val = values[this.name]) != null)) {
        if (this.elementOf.contains(val)) {
          return val;
        }
        console.warn("Given value \"" + val + "\" is not in the set \"" + this.elementOf.name + "\".");
      }
      return this;
    };

    return Variable;

  })(mathJS.Expression);

}).call(this);
