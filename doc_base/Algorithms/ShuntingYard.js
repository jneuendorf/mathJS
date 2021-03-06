// Generated by CoffeeScript 1.9.3
(function() {
  var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    slice = [].slice;

  mathJS.Algorithms.ShuntingYard = (function() {
    var CLASS, isOperand;

    CLASS = ShuntingYard;

    ShuntingYard.specialOperators = {
      "+": "#",
      "-": "_"
    };

    ShuntingYard.init = function() {
      return this.specialOperations = {
        "#": mathJS.Operations.neutralPlus,
        "_": mathJS.Operations.negate
      };
    };

    function ShuntingYard(settings) {
      var op, opSettings;
      this.ops = "";
      this.precedence = {};
      this.associativity = {};
      for (op in settings) {
        opSettings = settings[op];
        this.ops += op;
        this.precedence[op] = opSettings.precedence;
        this.associativity[op] = opSettings.associativity;
      }
    }

    isOperand = function(token) {
      return mathJS.isNum(token);
    };

    ShuntingYard.prototype.toPostfix = function(str) {
      var associativity, i, l, len, o1, o2, ops, postfix, precedence, prevToken, stack, token;
      str = str.replace(/\s+/g, "");
      str = str.replace(/(\d+|\w)(\w)/g, "$1*$2");
      stack = [];
      ops = this.ops;
      precedence = this.precedence;
      associativity = this.associativity;
      postfix = "";
      postfix.postfix = true;
      for (i = l = 0, len = str.length; l < len; i = ++l) {
        token = str[i];
        if (indexOf.call(ops, token) >= 0) {
          o1 = token;
          o2 = stack.last();
          if (i === 0 || prevToken === "(") {
            if (CLASS.specialOperators[token] != null) {
              postfix += CLASS.specialOperators[token] + " ";
            }
          } else {
            while (indexOf.call(ops, o2) >= 0 && (associativity[o1] === "left" && precedence[o1] <= precedence[o2]) || (associativity[o1] === "right" && precedence[o1] < precedence[o2])) {
              postfix += o2 + " ";
              stack.pop();
              o2 = stack.last();
            }
            stack.push(o1);
          }
        } else if (token === "(") {
          stack.push(token);
        } else if (token === ")") {
          while (stack.last() !== "(") {
            postfix += (stack.pop()) + " ";
          }
          stack.pop();
        } else {
          postfix += token + " ";
        }
        prevToken = token;
      }
      while (stack.length > 0) {
        postfix += (stack.pop()) + " ";
      }
      return postfix.trim();
    };

    ShuntingYard.prototype.toExpression = function(str) {
      var endIdx, exp, i, idxOffset, j, k, l, len, op, ops, param, params, postfix, ref, startIdx, token, v;
      if (str.postfix == null) {
        postfix = this.toPostfix(str);
      } else {
        postfix = str;
      }
      postfix = postfix.split(" ");
      ops = this.ops;
      ref = CLASS.specialOperators;
      for (k in ref) {
        v = ref[k];
        ops += v;
      }
      i = 0;
      while (postfix.length > 1) {
        token = postfix[i];
        idxOffset = 0;
        if (indexOf.call(ops, token) >= 0) {
          if ((op = mathJS.Operations[token])) {
            startIdx = i - op.arity;
            endIdx = i;
          } else if ((op = CLASS.specialOperations[token])) {
            startIdx = i + 1;
            endIdx = i + op.arity + 1;
            idxOffset = -1;
          }
          params = postfix.slice(startIdx, endIdx);
          startIdx += idxOffset;
          for (j = l = 0, len = params.length; l < len; j = ++l) {
            param = params[j];
            if (typeof param === "string") {
              if (isOperand(param)) {
                params[j] = new mathJS.Expression(parseFloat(param));
              } else {
                params[j] = new mathJS.Variable(param);
              }
            }
          }
          exp = (function(func, args, ctor) {
            ctor.prototype = func.prototype;
            var child = new ctor, result = func.apply(child, args);
            return Object(result) === result ? result : child;
          })(mathJS.Expression, [op].concat(slice.call(params)), function(){});
          postfix.splice(startIdx, params.length + 1, exp);
          i = startIdx + 1;
        } else if (isOperand(token)) {
          postfix[i++] = new mathJS.Expression(parseFloat(token));
        } else {
          postfix[i++] = new mathJS.Variable(token);
        }
      }
      return postfix.first;
    };

    return ShuntingYard;

  })();

}).call(this);
