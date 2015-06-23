// Generated by CoffeeScript 1.9.3

/**
* Domain ranks are like so:
* N -> 0
* Z -> 1
* Q -> 2
* I -> 2
* R -> 3
* C -> 4
* ==> union: take greater rank (if equal (and unequal names) take next greater rank)
* ==> intersection: take smaller rank (if equal (and unequal names) take empty set)
*
 */

(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  _mathJS.Sets.Domain = (function(superClass) {
    var CLASS;

    extend(Domain, superClass);

    CLASS = Domain;

    Domain["new"] = function() {
      return new CLASS();
    };

    Domain._byRank = function(rank) {
      var domain, name, ref;
      ref = mathJS.Domains;
      for (name in ref) {
        domain = ref[name];
        if (domain.rank === rank) {
          return domain;
        }
      }
      return null;
    };

    function Domain(name, rank, isCountable) {
      this.isDomain = true;
      this.name = name;
      this.rank = rank;
      this.isCountable = isCountable;
    }

    Domain.prototype.clone = function() {
      return this.constructor["new"]();
    };

    Domain.prototype.size = function() {
      return Infinity;
    };

    Domain.prototype.equals = function(set) {
      return set instanceof this.constructor;
    };

    Domain.prototype.intersection = function(set) {
      if (set.isDomain) {
        if (this.name === set.name) {
          return this;
        }
        if (this.rank < set.rank) {
          return this;
        }
        if (this.rank > set.rank) {
          return set;
        }
        return new mathJS.Set();
      }
      return false;
    };

    Domain.prototype.union = function(set) {
      if (set.isDomain) {
        if (this.name === set.name) {
          return this;
        }
        if (this.rank > set.rank) {
          return this;
        }
        if (this.rank < set.rank) {
          return set;
        }
        return CLASS._byRank(this.rank + 1);
      }
      return false;
    };

    Domain._makeAliases();

    return Domain;

  })(_mathJS.AbstractSet);

}).call(this);
