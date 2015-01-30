// Generated by CoffeeScript 1.8.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  mathJS.EmptySet = (function(_super) {
    __extends(EmptySet, _super);


    /**
    * @Override
    * see mathJS.Poolable
    * @static
    * @method fromPool
    *
     */

    EmptySet.fromPool = function() {
      if (this._pool.length > 0) {
        return this._pool.pop();
      }
      return new this();
    };

    EmptySet["new"] = function() {
      return this.fromPool();
    };

    function EmptySet() {}

    EmptySet.prototype.clone = function() {
      return mathJS.EmptySet["new"]();
    };

    EmptySet.prototype.equals = function(set) {
      return set instanceof mathJS.EmptySet;
    };

    EmptySet.prototype.addElem = function(elem) {
      if (DEBUG) {
        console.warn("prototype change!");
      }
      this.makeToDiscreteSet();
      return this;
    };

    EmptySet.prototype.addElems = function(elems) {
      var elem, set, _i, _len, _results;
      set = mathJS.EmptySet["new"]();
      _results = [];
      for (_i = 0, _len = elems.length; _i < _len; _i++) {
        elem = elems[_i];
        if (elem instanceof this.type) {
          _results.push(set.addElem(elem));
        }
      }
      return _results;
    };

    EmptySet.prototype.removeElem = function(elem) {
      if (elem instanceof this.type) {
        return this.without(new mathJS.DiscreteSet(this.type, elem));
      }
      return this;
    };

    EmptySet.prototype.contains = function(elem) {
      var subset, _i, _len, _ref;
      if (elem instanceof this.type) {
        _ref = this.subsets;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          subset = _ref[_i];
          if (subset.contains(elem)) {
            return true;
          }
        }
      }
      return false;
    };

    EmptySet.prototype.union = function(set) {
      if (this.intersects(set)) {
        set = set.without(this);
        this.subsets.push(set);
      } else {
        this.subsets.push(set);
      }
      return this;
    };

    EmptySet.prototype.intersect = function(set) {
      return mathJS.EmptySet["new"]();
    };

    EmptySet.prototype.intersects = function(set) {
      return false;
    };

    EmptySet.prototype.disjoint = function(set) {
      return true;
    };

    EmptySet.prototype.complement = function() {
      if (this.universe != null) {
        return this.universe;
      }
      return mathJS.EmptySet["new"]();
    };


    /**
    * a.without b => returns: removed all common elements from a
    *
     */

    EmptySet.prototype.without = function(set) {};

    EmptySet.prototype.size = function() {
      return 0;
    };


    /**
    * @Override mathJS.Poolable
    * see mathJS.Poolable
    * @method release
    *
     */

    EmptySet.prototype.release = function() {
      this.constructor._pool.push(this);
      return this.constructor;
    };

    return EmptySet;

  })(mathJS.Set);

}).call(this);
