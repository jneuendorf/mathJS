// Generated by CoffeeScript 1.9.3
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  mathJS.Sets.I = (function(superClass) {
    var CLASS;

    extend(I, superClass);

    CLASS = I;

    I["new"] = function() {
      return new CLASS();
    };

    function I() {
      I.__super__.constructor.call(this, "I", 2, false);
    }

    I.prototype.contains = function(x) {
      return new mathJS.Number(x).equals(x);
    };


    /**
    * This method checks if `this` is a subset of the given set `set`. Since equality must be checked by checking an arbitrary number of values this method actually does the same as `this.equals()`. For `this.equals()` the number of compared elements is 10x bigger.
    *
     */

    I.prototype.isSubsetOf = function(set, n) {
      if (n == null) {
        n = mathJS.settings.set.maxIterations;
      }
      return this.equals(set, n * 10);
    };

    I.prototype.isSupersetOf = function(set) {
      if (this._isSet(set)) {
        return set.isSubsetOf(this);
      }
      return false;
    };

    I.prototype.complement = function() {
      if (this.universe != null) {
        return this.universe.without(this);
      }
      return new mathJS.EmptySet();
    };


    /**
    * a.without b => returns: removed all common elements from a
    *
     */

    I.prototype.without = function(set) {};

    I.prototype.cartesianProduct = function(set) {};

    I._makeAliases();

    return I;

  })(_mathJS.Sets.Domain);

  (function() {
    return Object.defineProperties(mathJS.Domains, {
      I: {
        value: new mathJS.Sets.I(),
        writable: false,
        enumerable: true,
        configurable: false
      }
    });
  })();

}).call(this);