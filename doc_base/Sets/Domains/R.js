// Generated by CoffeeScript 1.9.3
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  mathJS.Sets.R = (function(superClass) {
    var CLASS;

    extend(R, superClass);

    CLASS = R;

    R["new"] = function() {
      return new CLASS();
    };

    function R() {
      R.__super__.constructor.call(this, "R", 3, false);
    }

    R.prototype.contains = function(x) {
      return new mathJS.Number(x).equals(x);
    };


    /**
    * This method checks if `this` is a subset of the given set `set`. Since equality must be checked by checking an arbitrary number of values this method actually does the same as `this.equals()`. For `this.equals()` the number of compared elements is 10x bigger.
    *
     */

    R.prototype.isSubsetOf = function(set, n) {
      if (n == null) {
        n = mathJS.settings.set.maxIterations;
      }
      return this.equals(set, n * 10);
    };

    R.prototype.isSupersetOf = function(set) {
      if (this._isSet(set)) {
        return set.isSubsetOf(this);
      }
      return false;
    };

    R.prototype.complement = function() {
      if (this.universe != null) {
        return this.universe.without(this);
      }
      return new mathJS.EmptySet();
    };


    /**
    * a.without b => returns: removed all common elements from a
    *
     */

    R.prototype.without = function(set) {};

    R.prototype.cartesianProduct = function(set) {};

    R._makeAliases();

    return R;

  })(_mathJS.Sets.Domain);

  (function() {
    return Object.defineProperties(mathJS.Domains, {
      R: {
        value: new mathJS.Sets.R(),
        writable: false,
        enumerable: true,
        configurable: false
      }
    });
  })();

}).call(this);
