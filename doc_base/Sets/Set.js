// Generated by CoffeeScript 1.9.3

/**
* @class Set
* @constructor
* @param {mixed} specifications
* To create an empty set pass no parameters.
* To create a discrete set list the elements. Those elements must implement the comparable interface and must not be arrays. Non-comparable elements will be ignored unless they are primitives.
* To create a set from set-builder notation pass the parameters must have the following types:
* mathJS.Expression|mathJS.Tuple|mathJS.Number, mathJS.Predicate
 * TODO: package all those types (expression-like) into 1 prototype (Variable already is)
*
 */

(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty,
    slice = [].slice;

  mathJS.Set = (function(superClass) {
    var newFromConditional, newFromDiscrete;

    extend(Set, superClass);


    /**
    * Optionally the left and right configuration can be passed directly (each with an open- and value-property) or the Interval can be parsed from String (like "(2, 6 ]").
    * @static
    * @method createInterval
    * @param leftOpen {Boolean}
    * @param leftValue {Number|mathJS.Number}
    * @param rightValue {Number|mathJS.Number}
    * @param rightOpen {Boolean}
    *
     */

    Set.createInterval = function() {
      var expression, fourth, left, parameters, predicate, right, second, str;
      parameters = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      if (typeof (str = parameters.first) === "string") {
        str = str.replace(/\s+/g, "").split(",");
        left = {
          open: str.first[0] === "(",
          value: new mathJS.Number(parseInt(str.first.slice(1), 10))
        };
        right = {
          open: str.second.last === ")",
          value: new mathJS.Number(parseInt(str.second.slice(0, -1), 10))
        };
      } else {
        second = parameters.second;
        fourth = parameters.fourth;
        left = {
          open: parameters.first,
          value: (second instanceof mathJS.Number ? second : new mathJS.Number(second))
        };
        right = {
          open: parameters.third,
          value: (fourth instanceof mathJS.Number ? fourth : new mathJS.Number(fourth))
        };
      }
      expression = new mathJS.Variable("x", mathJS.Domains.N);
      predicate = null;
      return new mathJS.Set(expression, predicate);
    };

    function Set() {
      var parameters;
      parameters = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      if (parameters.length === 0) {
        this.discreteSet = new _mathJS.DiscreteSet();
        this.conditionalSet = new _mathJS.ConditionalSet();
      } else if (parameters.first instanceof _mathJS.DiscreteSet && parameters.second instanceof _mathJS.ConditionalSet) {
        this.discreteSet = parameters.first;
        this.conditionalSet = parameters.second;
      } else if (parameters.first instanceof mathJS.Expression && parameters.second instanceof mathJS.Expression) {
        console.log("set builder");
        this.discreteSet = new _mathJS.DiscreteSet();
        this.conditionalSet = new _mathJS.ConditionalSet(parameters.first, parameters.slice(1));
      } else {
        if (parameters.first instanceof Array) {
          parameters = parameters.first;
        }
        console.log("params:", parameters);
        this.discreteSet = new _mathJS.DiscreteSet(parameters);
        this.conditionalSet = new _mathJS.ConditionalSet();
      }
    }

    newFromDiscrete = function(set) {
      return new mathJS.Set(set.getElements());
    };

    newFromConditional = function(set) {
      return new mathJS.Set(set.expression, set.domains, set.predicate);
    };

    Set.prototype.getElements = function(n, sorted) {
      var res;
      if (n == null) {
        n = mathJS.config.set.defaultNumberOfElements;
      }
      if (sorted == null) {
        sorted = false;
      }
      res = this.discreteSet.elems.concat(this.conditionalSet.getElements(n, sorted));
      if (sorted !== true) {
        return res;
      }
      return res.sort(mathJS.sortFunction);
    };

    Set.prototype.size = function() {
      return this.discreteSet.size() + this.conditionalSet.size();
    };

    Set.prototype.clone = function() {
      return newFromDiscrete(this.discreteSet).union(newFromConditional(this.conditionalSet));
    };

    Set.prototype.equals = function(set) {
      if (set.size() !== this.size()) {
        return false;
      }
      return set.discreteSet.equals(this.discreteSet) && set.conditionalSet.equals(this.conditionalSet);
    };

    Set.prototype.getSet = function() {
      return this;
    };

    Set.prototype.isSubsetOf = function(set) {
      return this.conditionalSet.isSubsetOf(set) || this.discreteSet.isSubsetOf(set);
    };

    Set.prototype.isSupersetOf = function(set) {
      return this.conditionalSet.isSupersetOf(set) || this.discreteSet.isSupersetOf(set);
    };

    Set.prototype.contains = function(elem) {
      return this.conditionalSet.contains(this.conditionalSet) || this.discreteSet.contains(this.discreteSet);
    };

    Set.prototype.union = function(set) {
      if (set.isDomain) {
        return set.union(this);
      }
      return new mathJS.Set(this.discreteSet.union(set.discreteSet), this.conditionalSet.union(set.conditionalSet));
    };

    Set.prototype.intersection = function(set) {
      if (set.isDomain) {
        return set.intersection(this);
      }
      return new mathJS.Set(this.discreteSet.intersection(set.discreteSet), this.conditionalSet.intersection(set.conditionalSet));
    };

    Set.prototype.complement = function() {
      if (this.universe != null) {
        return asdf;
      }
      return new mathJS.EmptySet();
    };

    Set.prototype.without = function(set) {};

    Set.prototype.cartesianProduct = function(set) {};

    Set.prototype.min = function() {
      return mathJS.min(this.discreteSet.min().concat(this.conditionalSet.min()));
    };

    Set.prototype.max = function() {
      return mathJS.max(this.discreteSet.max().concat(this.conditionalSet.max()));
    };

    Set.prototype.infimum = function() {};

    Set.prototype.supremum = function() {};

    return Set;

  })(_mathJS.AbstractSet);

}).call(this);