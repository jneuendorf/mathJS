// Generated by CoffeeScript 1.9.3
(function() {
  mathJS.Equation = (function() {
    function Equation(left, right) {
      this.left = left;
      this.right = right;
    }

    Equation.prototype.solve = function(variable) {
      var left, right, solutions, v, variables;
      left = this.left.simplify();
      right = this.right.simplify();
      solutions = new mathJS.Set();
      if (!(variable instanceof mathJS.Variable)) {
        variables = left.getVariables().concat(right.getVariables());
        variable = ((function() {
          var i, len, results;
          results = [];
          for (i = 0, len = variables.length; i < len; i++) {
            v = variables[i];
            if (v.name === variable) {
              results.push(v);
            }
          }
          return results;
        })()).first;
      }
      return solutions;
    };

    Equation.prototype["eval"] = function(values) {
      return this.left["eval"](values).equals(this.right["eval"](values));
    };

    Equation.prototype.simplify = function() {
      this.left = this.left.simplify();
      this.right = this.right.simplify();
      return this;
    };

    return Equation;

  })();

}).call(this);
