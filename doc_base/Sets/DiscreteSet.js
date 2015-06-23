// Generated by CoffeeScript 1.9.3

/**
* This class is a Setof explicitely listed elements (with no needed logic).
* @class DiscreteSet
* @constructor
* @param {Function|Class} type
* @param {Set} universe
* Optional. If given, the created Set will be interpreted as a sub set of the universe.
* @param {mixed} elems...
* Optional. This and the following parameters serve as elements for the new Set. They will be in the new Set immediately.
* @extends Set
*
 */

(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty,
    slice = [].slice;

  _mathJS.DiscreteSet = (function(superClass) {
    extend(DiscreteSet, superClass);

    function DiscreteSet() {
      var elem, elems, i, len;
      elems = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      if (elems.first instanceof Array) {
        elems = elems.first;
      }
      this.elems = [];
      for (i = 0, len = elems.length; i < len; i++) {
        elem = elems[i];
        if (!this.contains(elem)) {
          if (!mathJS.isNum(elem)) {
            this.elems.push(elem);
          } else {
            this.elems.push(new mathJS.Number(elem));
          }
        }
      }
    }

    DiscreteSet.prototype.cartesianProduct = function(set) {
      var e, elements, i, j, len, len1, ref, ref1, x;
      elements = [];
      ref = this.elems;
      for (i = 0, len = ref.length; i < len; i++) {
        e = ref[i];
        ref1 = set.elems;
        for (j = 0, len1 = ref1.length; j < len1; j++) {
          x = ref1[j];
          elements.push(new mathJS.Tuple(e, x));
        }
      }
      return new _mathJS.DiscreteSet(elements);
    };

    DiscreteSet.prototype.clone = function() {
      return new _mathJS.DiscreteSet(this.elems);
    };

    DiscreteSet.prototype.contains = function(elem) {
      var e, i, len, ref;
      ref = this.elems;
      for (i = 0, len = ref.length; i < len; i++) {
        e = ref[i];
        if (elem.equals(e)) {
          return true;
        }
      }
      return false;
    };

    DiscreteSet.prototype.equals = function(set) {
      var e, i, j, len, len1, ref, ref1;
      ref = this.elems;
      for (i = 0, len = ref.length; i < len; i++) {
        e = ref[i];
        if (!set.contains(e)) {
          return false;
        }
      }
      ref1 = set.elems;
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        e = ref1[j];
        if (!this.contains(e)) {
          return false;
        }
      }
      return true;
    };


    /**
    * Get the elements of the set.
    * @method getElements
    * @param sorted {Boolean}
    * Optional. If set to `true` returns the elements in ascending order.
    *
     */

    DiscreteSet.prototype.getElements = function(sorted) {
      if (sorted !== true) {
        return this.elems.clone();
      }
      return this.elems.clone().sort(mathJS.sortFunction);
    };

    DiscreteSet.prototype.intersection = function(set) {
      var elems, i, j, len, len1, ref, ref1, x, y;
      elems = [];
      ref = this.elems;
      for (i = 0, len = ref.length; i < len; i++) {
        x = ref[i];
        ref1 = set.elems;
        for (j = 0, len1 = ref1.length; j < len1; j++) {
          y = ref1[j];
          if (x.equals(y)) {
            elems.push(x);
          }
        }
      }
      return new _mathJS.DiscreteSet(elems);
    };

    DiscreteSet.prototype.isSubsetOf = function(set) {
      var e, i, len, ref;
      ref = this.elems;
      for (i = 0, len = ref.length; i < len; i++) {
        e = ref[i];
        if (!set.contains(e)) {
          return false;
        }
      }
      return true;
    };

    DiscreteSet.prototype.size = function() {
      return this.elems.length;
    };

    DiscreteSet.prototype.union = function(set) {
      return new _mathJS.DiscreteSet(set.elems.concat(this.elems));
    };

    DiscreteSet.prototype.without = function(set) {
      var elem;
      return (function() {
        var i, len, ref, results;
        ref = this.elems;
        results = [];
        for (i = 0, len = ref.length; i < len; i++) {
          elem = ref[i];
          if (!set.contains(elem)) {
            results.push(elem);
          }
        }
        return results;
      }).call(this);
    };

    DiscreteSet.prototype.min = function() {
      return mathJS.min(this.elems);
    };

    DiscreteSet.prototype.max = function() {
      return mathJS.max(this.elems);
    };

    DiscreteSet.prototype.infimum = function() {};

    DiscreteSet.prototype.supremum = function() {};

    DiscreteSet._makeAliases();

    return DiscreteSet;

  })(mathJS.Set);

}).call(this);
