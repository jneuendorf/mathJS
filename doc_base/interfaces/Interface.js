// Generated by CoffeeScript 1.9.3
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  _mathJS.Interface = (function(superClass) {
    extend(Interface, superClass);

    function Interface() {
      return Interface.__super__.constructor.apply(this, arguments);
    }

    Interface.implementedBy = [];

    Interface.isImplementedBy = function() {
      return this.implementedBy;
    };

    return Interface;

  })(_mathJS.Object);

}).call(this);