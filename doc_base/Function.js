// Generated by CoffeeScript 1.7.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  mathJS.Function = (function(_super) {
    __extends(Function, _super);

    function Function(fromSet, toSet, mapping) {
      this.fromSet = fromSet;
      this.toSet = toSet;
      this.mapping = mapping;
    }

    return Function;

  })(mathJS.ConditionalSet);

}).call(this);
