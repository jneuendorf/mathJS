// Generated by CoffeeScript 1.9.3
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  mathJS.Double = (function(superClass) {
    extend(Double, superClass);

    function Double() {
      return Double.__super__.constructor.apply(this, arguments);
    }

    return Double;

  })(mathJS.Number);

}).call(this);
