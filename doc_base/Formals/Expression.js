// Generated by CoffeeScript 1.9.3

/**
* Tree structure of expressions. It consists of 2 expression and 1 operation.
* @class Expression
* @constructor
* @param operation {Operation|String}
* @param expressions... {Expression}
*
 */

(function() {
  var slice = [].slice,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  mathJS.Expression = (function() {
    var CLASS;

    CLASS = Expression;

    Expression.fromString = function(str) {
      return new mathJS.Expression();
    };

    Expression.parse = Expression.fromString;

    Expression.parser = new mathJS.Algorithms.ShuntingYard({
      "!": {
        precedence: 5,
        associativity: "right"
      },
      "^": {
        precedence: 4,
        associativity: "right"
      },
      "*": {
        precedence: 3,
        associativity: "left"
      },
      "/": {
        precedence: 3,
        associativity: "left"
      },
      "+": {
        precedence: 2,
        associativity: "left"
      },
      "-": {
        precedence: 2,
        associativity: "left"
      }
    });

    Expression["new"] = function() {
      var expressions, operation;
      operation = arguments[0], expressions = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      return new CLASS(operation, expressions);
    };

    function Expression() {
      var expressions, operation;
      operation = arguments[0], expressions = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      if (typeof operation === "string") {
        if (mathJS.Operations[operation] != null) {
          operation = mathJS.Operations[operation];
        } else {
          throw new mathJS.Errors.InvalidParametersError("Invalid operation string given: \"" + operation + "\".");
        }
      }
      if (expressions.first instanceof Array) {
        expressions = expressions.first;
      }
      if (expressions.length === 0) {
        if (mathJS.Number.valueIsValid(operation)) {
          this.operation = null;
          this.expressions = [new mathJS.Number(operation)];
        } else {
          if (operation instanceof mathJS.Variable) {
            this.operation = null;
            this.expressions = [operation];
          } else {
            this.operation = null;
            this.expressions = [new mathJS.Variable(operation)];
          }
        }
      } else if (operation.arity === expressions.length) {
        this.operation = operation;
        this.expressions = expressions;
      } else {
        throw new mathJS.Errors.InvalidArityError("Invalid number of parameters (" + expressions.length + ") for Operation \"" + operation.name + "\". Expected number of parameters is " + operation.arity + ".");
      }
    }


    /**
    * This method tests for the equality of structure. So 2*3x does not equal 6x!
    * For that see mathEquals().
    * @method equals
    *
     */

    Expression.prototype.equals = function(expression) {
      var doneExpressions, e1, e2, exp, i, j, l, len, len1, len2, m, n, ref, ref1, ref2, res, x;
      if (this.expressions.length !== expression.expressions.length) {
        return false;
      }
      if (this.operation == null) {
        return (expression.operation == null) && expression.expressions.first.equals(this.expressions.first);
      }
      if (this.operation.commutative === true) {
        doneExpressions = [];
        ref = this.expressions;
        for (i = l = 0, len = ref.length; l < len; i = ++l) {
          exp = ref[i];
          res = false;
          ref1 = expression.expressions;
          for (j = m = 0, len1 = ref1.length; m < len1; j = ++m) {
            x = ref1[j];
            if (!(indexOf.call(doneExpressions, j) < 0 && x.equals(exp))) {
              continue;
            }
            doneExpressions.push(j);
            res = true;
            break;
          }
          if (!res) {
            return false;
          }
        }
        return true;
      } else {
        ref2 = this.expressions;
        for (i = n = 0, len2 = ref2.length; n < len2; i = ++n) {
          e1 = ref2[i];
          e2 = expression.expressions[i];
          if (!e1.equals(e2)) {
            return false;
          }
        }
        return true;
      }
    };


    /**
    * This method tests for the logical/mathematical equality of 2 expressions.
    *
     */

    Expression.prototype.mathEquals = function(expression) {
      return this.simplify().equals(expression.simplify());
    };


    /**
    * @method eval
    * @param values {Object}
    * An object of the form {varKey: varVal}.
    * @returns The value of the expression (specified by the values).
    *
     */

    Expression.prototype["eval"] = function(values) {
      var args, expression, k, l, len, ref, v, value;
      for (k in values) {
        v = values[k];
        if (mathJS.isPrimitive(v) && mathJS.Number.valueIsValid(v)) {
          values[k] = new mathJS.Number(v);
        }
      }
      if (this.operation == null) {
        return this.expressions.first["eval"](values);
      }
      args = [];
      ref = this.expressions;
      for (l = 0, len = ref.length; l < len; l++) {
        expression = ref[l];
        value = expression["eval"](values);
        if (value instanceof mathJS.Variable) {
          return this;
        }
        args.push(value);
      }
      return this.operation["eval"](args);
    };

    Expression.prototype.simplify = function() {
      var evaluated;
      evaluated = this["eval"]();
      return this;
    };

    Expression.prototype.getVariables = function() {
      var expression, l, len, ref, res, val;
      if (this.operation == null) {
        if ((val = this.expressions.first) instanceof mathJS.Variable) {
          return [val];
        }
        return [];
      }
      res = [];
      ref = this.expressions;
      for (l = 0, len = ref.length; l < len; l++) {
        expression = ref[l];
        res = res.concat(expression.getVariables());
      }
      return res;
    };

    Expression.prototype._getSet = function() {
      var expression, l, len, ref, res;
      if (this.operation == null) {
        return this.expressions.first._getSet();
      }
      res = null;
      ref = this.expressions;
      for (l = 0, len = ref.length; l < len; l++) {
        expression = ref[l];
        if (res != null) {
          res = res[this.operation.setEquivalent](expression._getSet());
        } else {
          res = expression._getSet();
        }
      }
      return res || new mathJS.Set();
    };


    /**
    * Get the "range" of the expression (the set of all possible results).
    * @method getSet
    *
     */

    Expression.prototype.getSet = function() {
      return this["eval"]()._getSet();
    };

    Expression.prototype.evaluatesTo = Expression.prototype.getSet;

    if (DEBUG) {
      Expression.test = function() {
        var e1, e2, e4, str;
        e1 = new CLASS(5);
        e2 = new CLASS(new mathJS.Variable("x", mathJS.Number));
        e4 = new CLASS("+", e1, e2);
        console.log(e4.getVariables());
        str = "(5x - 3)  ^ 2 * 2 / (4y + 3!)";
        return "test done";
      };
    }

    return Expression;

  })();

}).call(this);