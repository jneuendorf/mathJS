// Generated by CoffeeScript 1.9.3
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  mathJS.Sets.N = (function(superClass) {
    var CLASS;

    extend(N, superClass);

    CLASS = N;

    N["new"] = function() {
      return new CLASS();
    };

    function N() {
      N.__super__.constructor.call(this, "N", 0, true);
    }

    N.prototype.contains = function(x) {
      return mathJS.isInt(x) || new mathJS.Int(x).equals(x);
    };


    /**
    * This method checks if `this` is a subset of the given set `set`. Since equality must be checked by checking an arbitrary number of values this method actually does the same as `this.equals()`. For `this.equals()` the number of compared elements is 10x bigger.
    *
     */

    N.prototype.isSubsetOf = function(set, n) {
      if (n == null) {
        n = mathJS.settings.set.maxIterations;
      }
      return this.equals(set, n * 10);
    };

    N.prototype.isSupersetOf = function(set) {
      if (this._isSet(set)) {
        return set.isSubsetOf(this);
      }
      return false;
    };

    N.prototype.union = function(set, n, matches) {
      var checker, generator, self;
      if (n == null) {
        n = mathJS.settings.set.maxIterations;
      }
      if (matches == null) {
        matches = mathJS.settings.set.maxMatches;
      }
      checker = function(elem) {
        return self.checker(elem) || set.checker(elem);
      };
      generator = function() {};
      if (set instanceof mathJS.DiscreteSet || (typeof set["instanceof"] === "function" ? set["instanceof"](mathJS.DiscreteSet) : void 0)) {

      } else if (set instanceof mathJS.Set || (typeof set["instanceof"] === "function" ? set["instanceof"](mathJS.Set) : void 0)) {
        if (mathJS["instanceof"](set, mathJS.Set.N)) {
          return this;
        }
        if (mathJS["instanceof"](set, mathJS.Domains.Q) || mathJS["instanceof"](set, mathJS.Domains.R)) {
          return set;
        }
        self = this;
      }
      return null;
    };

    N.prototype.intersect = function(set) {
      var checker, commonElements, elem, f1, f1Elem, f1Elems, f2, f2Elem, f2Elems, found, i, j, k, l, len, len1, len2, m, ops, x, y1, y2;
      checker = function(elem) {
        return self.checker(elem) && set.checker(elem);
      };
      commonElements = [];
      x = 0;
      m = 0;
      f1 = this.generator;
      f2 = set.generator;
      f1Elems = [];
      f2Elems = [];
      while (x < n && m < matches) {
        y1 = f1(x);
        y2 = f2(x);
        if (mathJS.gt(y1, y2)) {
          found = false;
          for (i = j = 0, len = f1Elems.length; j < len; i = ++j) {
            f1Elem = f1Elems[i];
            if (!(mathJS.equals(y2, f1Elem))) {
              continue;
            }
            m++;
            found = true;
            commonElements.push(y2);
            f1Elems = f1Elems.slice(i + 1);
            f2Elems = [];
            break;
          }
          if (!found) {
            f1Elems.push(y1);
            f2Elems.push(y2);
          }
        } else if (mathJS.lt(y1, y2)) {
          found = false;
          for (i = k = 0, len1 = f2Elems.length; k < len1; i = ++k) {
            f2Elem = f2Elems[i];
            if (!(mathJS.equals(y1, f2Elem))) {
              continue;
            }
            m++;
            found = true;
            commonElements.push(y1);
            f2Elems = f2Elems.slice(i + 1);
            f1Elems = [];
            break;
          }
          if (!found) {
            f1Elems.push(y1);
            f2Elems.push(y2);
          }
        } else {
          m++;
          commonElements.push(y1);
          f1Elems = [];
          f2Elems = [];
        }
        x++;
      }
      console.log("x=" + x, "m=" + m, commonElements);
      ops = [];
      for (l = 0, len2 = commonElements.length; l < len2; l++) {
        elem = commonElements[l];
        true;
      }
    };

    N.prototype.intersects = function(set) {
      return this.intersection(set).size > 0;
    };

    N.prototype.disjoint = function(set) {
      return this.intersection(set).size === 0;
    };

    N.prototype.complement = function() {
      if (this.universe != null) {
        return this.universe.without(this);
      }
      return new mathJS.EmptySet();
    };


    /**
    * a.without b => returns: removed all common elements from a
    *
     */

    N.prototype.without = function(set) {};

    N.prototype.cartesianProduct = function(set) {};

    N.prototype.times = N.prototype.cartesianProduct;

    return N;

  })(_mathJS.Sets.Domain);

  (function() {
    return Object.defineProperties(mathJS.Domains, {
      N: {
        value: new mathJS.Sets.N(),
        writable: false,
        enumerable: true,
        configurable: false
      }
    });
  })();

}).call(this);
