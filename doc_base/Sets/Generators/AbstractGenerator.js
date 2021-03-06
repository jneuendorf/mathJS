// Generated by CoffeeScript 1.9.3
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty,
    slice = [].slice;

  _mathJS.AbstractGenerator = (function(superClass) {
    extend(AbstractGenerator, superClass);

    function AbstractGenerator(f, minX, maxX, stepSize, maxIndex, tuple) {
      if (minX == null) {
        minX = 0;
      }
      if (maxX == null) {
        maxX = Infinity;
      }
      if (stepSize == null) {
        stepSize = mathJS.config.number.real.distance;
      }
      if (maxIndex == null) {
        maxIndex = mathJS.config.generator.maxIndex;
      }
      this.f = f;
      this.inverseF = f.getInverse();
      this.minX = minX;
      this.maxX = maxX;
      this.stepSize = stepSize;
      this.maxIndex = maxIndex;
      this.tuple = tuple;
      this.x = minX;
      this.overflowed = false;
      this.index = 0;
    }

    Object.defineProperties(AbstractGenerator.prototype, {
      "function": {
        get: function() {
          return this.f;
        },
        set: function(f) {
          this.f = f;
          this.inverseF = f.getInverse();
          return this;
        }
      }
    });

    AbstractGenerator.product = function() {
      var generators;
      generators = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    };

    AbstractGenerator.or = function(gen1, gen2) {};

    AbstractGenerator.and = function(gen1, gen2) {};


    /**
    * Indicates whether the set the generator creates contains the given value or not.
    * @method generates
    *
     */

    AbstractGenerator.prototype.generates = function(y) {
      if (this.f.range.contains(y)) {
        if (this.inverseF != null) {
          return this.inverseF["eval"](y);
        }
        return;
      }
      return false;
    };

    AbstractGenerator.prototype["eval"] = function(n) {
      if (this.tuple != null) {
        return this.tuple["eval"](n);
      }
      if (this.f["eval"] != null) {
        this.f["eval"](n);
      }
      return this.f.call(this, n);
    };

    AbstractGenerator.prototype.hasNext = function() {
      var g, i, j, len, ref;
      if (this.tuple != null) {
        ref = this.tuple.elems;
        for (i = j = 0, len = ref.length; j < len; i = ++j) {
          g = ref[i];
          if (g.hasNext()) {
            return true;
          }
        }
        return false;
      }
      return !this.overflowed && this.x < this.maxX && this.index < this.maxIndex;
    };

    AbstractGenerator.prototype._incX = function() {
      this.index++;
      this.x = this.minX + this.index * this.stepSize;
      if (this.x > this.maxX) {
        this.x = this.minX;
        this.index = 0;
        this.overflowed = true;
      }
      return this.x;
    };

    AbstractGenerator.prototype.next = function() {
      var g, generator, i, maxI, res;
      if (this.tuple != null) {
        res = this["eval"]((function() {
          var j, len, ref, results;
          ref = this.tuple.elems;
          results = [];
          for (j = 0, len = ref.length; j < len; j++) {
            g = ref[j];
            results.push(g.x);
          }
          return results;
        }).call(this));

        /*
        0 0
        0 1
        1 0
        1 1
         */
        i = 0;
        maxI = this.tuple.length;
        generator = this.tuple.first;
        generator._incX();
        while (i < maxI && generator.overflowed) {
          generator.overflowed = false;
          generator = this.tuple.at(++i);
          if (generator != null) {
            generator._incX();
          }
        }
        return res;
      }
      res = this["eval"](this.x);
      this._incX();
      return res;
    };

    AbstractGenerator.prototype.reset = function() {
      this.x = this.minX;
      this.index = 0;
      return this;
    };

    if (DEBUG) {
      AbstractGenerator.test = function() {
        var g, g1, g2, res, tmp;
        g = new mathJS.Generator(function(x) {
          return 3 * x * x + 2 * x - 5;
        }, -10, 10, 0.2);
        res = [];
        while (g.hasNext()) {
          tmp = g.next();
          res.push(tmp);
        }
        tmp = g.next();
        res.push(tmp);
        console.log("simple test:", (res.length === ((g.maxX - g.minX) / g.stepSize + 1) ? "successful" : "failed"));
        g1 = new mathJS.Generator(function(x) {
          return x;
        }, 0, 5, 0.5);
        g2 = new mathJS.Generator(function(x) {
          return 2 * x;
        }, -2, 10, 2);
        g = mathJS.Generator.product(g1, g2);
        res = [];
        while (g.hasNext()) {
          tmp = g.next();
          res.push(tmp);
        }
        tmp = g.next();
        res.push(tmp);
        console.log("tuple test:", (res.length === ((g1.maxX - g1.minX) / g1.stepSize + 1) * ((g2.maxX - g2.minX) / g2.stepSize + 1) ? "successful" : "failed"));
        g = new mathJS.Generator(function(x) {
          return x;
        });
        while (g.hasNext()) {
          tmp = g.next();
        }
        tmp = g.next();
        return "done";
      };
    }

    return AbstractGenerator;

  })(_mathJS.Object);

}).call(this);
