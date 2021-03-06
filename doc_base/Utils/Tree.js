// Generated by CoffeeScript 1.9.3
(function() {
  var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  mathJS.Utils.Tree = (function() {
    var CLASS;

    CLASS = Tree;


    /**
    * @method new
    * @static
    * @param node {Object}
    * @param options {Object}
    * Optional. Any given key will override the default. Here are the keys:
    * adjustLevels: Boolean value that indicates whether the tree is supposed to do its aftermath. Only set this to false if you're doing the aftermath later!!
    * afterInstatiate: Function to modify the node and/or the instance. Parameters are (1st) the node object and (2nd) the instance.
    * getChildren: Function that specifies how to retrieve the children from the node object.
    * getParent: Function that specifies how to retrieve the parent from the node object. getChildren is checked 1st so it doesn't make sense to pass getChildren AND getParent!
    * instantiate: Function that specifies how to create an instance from the node object. Parameter is the node object.
    *
     */

    Tree["new"] = function(node, options) {
      if (node instanceof this) {
        return new CLASS(node);
      }
      if (node.children != null) {
        return CLASS["new"].byChildRef(node);
      }
      if (node.parent != null) {
        return CLASS["new"].byParentRef(node);
      }
      if (options != null) {
        if (options.getChildren != null) {
          return CLASS["new"].byChildRef(node, options);
        }
        if (options.getParent != null) {
          return CLASS["new"].byParentRef(node, options);
        }
      }
      if (DEBUG) {
        console.warn("No recusrive structure found! Use correct options.");
      }
      return null;
    };


    /**
    * @method new.byChildRef
    * @static
    * @param node {Object}
    * @param options {Object}
    * Optional. Any given key will override the default. Here are the keys:
    * adjustLevels: Boolean value that indicates whether the tree is supposed to do its aftermath. Only set this to false if you're doing the aftermath later!!
    * afterInstatiate: Function to modify the node and/or the instance. Parameters are (1st) the node object and (2nd) the instance.
    * getChildren: Function that specifies how to retrieve the children from the node object.
    * instantiate: Function that specifies how to create an instance from the node object. Parameter is the node object.
    *
     */

    Tree["new"].byChildRef = function(node, options) {
      var adjustLevels, child, childInstance, defaultOptions, j, len, ref, tree;
      defaultOptions = {
        getChildren: function(nodeData) {
          return nodeData.children;
        },
        instantiate: function(nodeData) {
          return new CLASS(nodeData);
        },
        afterInstatiate: function(nodeData, node) {
          return false;
        },
        adjustLevels: true
      };
      options = $.extend(defaultOptions, options);
      adjustLevels = options.adjustLevels;
      options.adjustLevels = false;
      tree = options.instantiate(node);
      options.afterInstatiate(node, tree);
      ref = options.getChildren(node) || [];
      for (j = 0, len = ref.length; j < len; j++) {
        child = ref[j];
        childInstance = CLASS["new"].byChildRef(child, options);
        tree.addChild(childInstance, false);
      }
      if (adjustLevels) {
        tree.adjustLevels(0);
      }
      return tree;
    };


    /**
    * @method new.byParentRef
    * @static
    * @param node {Object}
    * @param options {Object}
    * Optional. Any given key will override the default. Here are the keys:
    * adjustLevels: Boolean value that indicates whether the tree is supposed to do its aftermath. Only set this to false if you're doing the aftermath later!!
    * afterInstatiate: Function to modify the node and/or the instance. Parameters are (1st) the node object and (2nd) the instance.
    * getParent: Function that specifies how to retrieve the parent from the node object.
    * instantiate: Function that specifies how to create an instance from the node object. Parameter is the node object.
    *
     */

    Tree["new"].byParentRef = function(node, getParent) {
      var tree;
      return tree = new CLASS();
    };

    Tree.fromRecursive = Tree["new"];

    function Tree(node, options) {
      var self;
      self = this;
      this.children = [];
      this.parent = null;
      this.descendants = [];
      this.orderMode = "postorder";
      if (node == null) {
        this.data = {};
      } else {
        this.data = node;
      }
    }

    Object.defineProperties(Tree.prototype, {
      depth: {
        get: function() {
          return this.getDepth();
        },
        set: function() {
          return this;
        }
      },
      size: {
        get: function() {
          return this.getSize();
        },
        set: function() {
          return this;
        }
      },
      level: {
        get: function() {
          return this.getLevel();
        },
        set: function() {
          return this;
        }
      },
      root: {
        get: function() {
          return this.getRoot();
        },
        set: function() {
          return this;
        }
      }
    });

    Tree.prototype._cacheDescendants = function() {
      var child, j, len, ref, res;
      res = [];
      ref = this.children;
      for (j = 0, len = ref.length; j < len; j++) {
        child = ref[j];
        child._cacheDescendants();
        res = res.concat(child.descendants);
      }
      this.descendants = this.children.concat(res);
      return this;
    };


    /**
    * Find (first occurence of) a node
    * @method findNode
    * @param nodeOrEqualsFunction {Function|App.Tree}
    *
     */

    Tree.prototype.findNode = function(param) {
      var ref;
      return ((ref = this.findNodes(param)) != null ? ref.first : void 0) || null;
    };

    Tree.prototype.findDescendant = function() {
      return this.findNode.apply(this, arguments);
    };


    /**
    * Find all occurences of a node.
    * @method findNodes
    * @param nodeOrEqualsFunction {Function|App.Tree}
    *
     */

    Tree.prototype.findNodes = function(param) {
      var j, k, len, len1, node, ref, ref1, res;
      res = [];
      if (param instanceof Function) {
        ref = this.descendants;
        for (j = 0, len = ref.length; j < len; j++) {
          node = ref[j];
          if (param(node)) {
            res.push(node);
          }
        }
      }
      if (param instanceof App.Tree) {
        ref1 = this.descendants;
        for (k = 0, len1 = ref1.length; k < len1; k++) {
          node = ref1[k];
          if (param === node) {
            res.push(node);
          }
        }
      }
      return res;
    };

    Tree.prototype.findDescendants = function() {
      return this.findNodes.apply(this, arguments);
    };

    Tree.prototype.getDepth = function() {
      var maxLevel;
      if (this.children.length > 0) {
        maxLevel = this.descendants.getMax(function(node) {
          return node.level;
        });
        return maxLevel.first.level - this.level;
      }
      return 0;
    };


    /**
    * Get number of nodes in (sub)tree
    *
     */

    Tree.prototype.getSize = function() {
      return this.descendants.length + 1;
    };

    Tree.prototype.getLevel = function() {
      return this._level;
    };

    Tree.prototype.getRoot = function() {
      var root;
      if ((root = this.parent) == null) {
        return this;
      }
      while (root.parent != null) {
        root = root.parent;
      }
      return root;
    };

    Tree.prototype.getSiblings = function() {
      var ref;
      return ((ref = this.parent) != null ? ref.children.except(this) : void 0) || [];
    };

    Tree.prototype.getLevelSiblings = function() {
      var ref, self, siblings;
      self = this;
      siblings = (ref = this.parent) != null ? ref.findNodes(function(node) {
        return node.level === self.level && node !== self;
      }) : void 0;
      return siblings || [];
    };

    Tree.prototype.getParent = function() {
      return this.parent;
    };

    Tree.prototype.getChildren = function() {
      return this.children;
    };

    Tree.prototype.addChild = function(node, adjustLevels) {
      if (adjustLevels == null) {
        adjustLevels = true;
      }
      if (!(node instanceof App.Tree)) {
        node = new CLASS(node);
      }
      this.children.push(node);
      if ((node.parent != null) && node.parent !== this && indexOf.call(node.parent.children, node) < 0) {
        node.parent.children = node.parent.children.except(node);
      }
      node.parent = this;
      if (adjustLevels) {
        node.adjustLevels(this.level);
      }
      return this;
    };

    Tree.prototype.appendChild = function() {
      return this.addChild.apply(this, arguments);
    };

    Tree.prototype.addChildren = function(nodes, adjustLevels) {
      var j, len, node;
      if (adjustLevels == null) {
        adjustLevels = true;
      }
      for (j = 0, len = nodes.length; j < len; j++) {
        node = nodes[j];
        this.addChild(node, false);
      }
      if (adjustLevels) {
        this.adjustLevels(this.level);
      }
      return this;
    };

    Tree.prototype.appendChildren = function() {
      return this.addChildren.apply(this, arguments);
    };

    Tree.prototype.setChildren = function(nodes, clone, adjustLevels) {
      var j, len, node;
      if (clone == null) {
        clone = false;
      }
      if (adjustLevels == null) {
        adjustLevels = true;
      }
      this.children = [];
      if (clone) {
        nodes = (function() {
          var j, len, results;
          results = [];
          for (j = 0, len = nodes.length; j < len; j++) {
            node = nodes[j];
            results.push(node.clone());
          }
          return results;
        })();
      }
      for (j = 0, len = nodes.length; j < len; j++) {
        node = nodes[j];
        this.addChild(node, false);
      }
      if (adjustLevels) {
        this.adjustLevels(this.level);
      }
      return this;
    };

    Tree.prototype.remove = function() {
      var n;
      if (this.parent != null) {
        this.parent.children = (function() {
          var j, len, ref, results;
          ref = this.parent.children;
          results = [];
          for (j = 0, len = ref.length; j < len; j++) {
            n = ref[j];
            if (n !== this) {
              results.push(n);
            }
          }
          return results;
        }).call(this);
        this.parent._cacheDescendants();
        this.parent = null;
      }
      this.adjustLevels();
      this._level = 0;
      return this;
    };

    Tree.prototype.removeChild = function(node) {
      return node.remove();
    };

    Tree.prototype.removeChildAt = function(idx) {
      return removeChild(this.children[idx]);
    };

    Tree.prototype.appendTo = function(node) {
      return node.addChild(this);
    };

    Tree.prototype.adjustLevels = function(startLevel) {
      if (startLevel == null) {
        startLevel = 0;
      }
      this._cacheDescendants().each(function(n, l, i) {
        n._level = startLevel + l;
        return true;
      });
      return this;
    };


    /**
    * @method traverse
    * @param callback {Function}
    * Gets the current node, the current level relative to the root of the current traversal, and iteration index as parameters.
    * @param orderMode {String}
    * Optional. Default is "postorder". Possible are "postorder", "preorder", "inorder", "levelorder".
    * @param searchMode {String}
    * Optional. Default is "depthFirst". Posible are "depthFirst", "breadthFirst".
    *
     */

    Tree.prototype.traverse = function(callback, orderMode, inorderIndex) {
      if (orderMode == null) {
        orderMode = this.orderMode || "postorder";
      }
      if (inorderIndex == null) {
        inorderIndex = null;
      }
      return this[orderMode](callback, null, inorderIndex);
    };

    Tree.prototype.each = function() {
      return this.traverse.apply(this, arguments);
    };

    Tree.prototype.postorder = function(callback, level, info) {
      var child, j, len, ref;
      if (level == null) {
        level = 0;
      }
      if (info == null) {
        info = {
          idx: 0,
          ctx: this
        };
      }
      ref = this.children;
      for (j = 0, len = ref.length; j < len; j++) {
        child = ref[j];
        child.postorder(callback, level + 1, info);
        info.idx++;
      }
      if (callback.call(info.ctx, this, level, info.idx) === false) {
        return this;
      }
      return this;
    };

    Tree.prototype.preorder = function(callback, level, info) {
      var child, j, len, ref;
      if (level == null) {
        level = 0;
      }
      if (info == null) {
        info = {
          idx: 0,
          ctx: this
        };
      }
      if (callback.call(info.ctx, this, level, info.idx) === false) {
        return this;
      }
      ref = this.children;
      for (j = 0, len = ref.length; j < len; j++) {
        child = ref[j];
        child.preorder(callback, level + 1, info);
        info.idx++;
      }
      return this;
    };

    Tree.prototype.inorder = function(callback, level, index, info) {
      var i, j, k, ref, ref1, ref2;
      if (index == null) {
        index = Math.floor(this.children.length / 2);
      }
      if (info == null) {
        info = {
          idx: 0,
          ctx: this
        };
      }
      for (i = j = 0, ref = index; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
        this.children[i].inorder(callback, level + 1, index, info);
        info.idx++;
      }
      if (callback.call(info.ctx, this, level, info.idx) === false) {
        return this;
      }
      for (i = k = ref1 = index, ref2 = this.children.lenth; ref1 <= ref2 ? k < ref2 : k > ref2; i = ref1 <= ref2 ? ++k : --k) {
        this.children[i].inorder(callback, level + 1, index, info);
        info.idx++;
      }
      return this;
    };

    Tree.prototype.levelorder = function(callback, level, info) {
      var currentLevel, el, list, prevLevel, startLevel;
      if (level == null) {
        level = 0;
      }
      if (info == null) {
        info = {
          idx: 0,
          ctx: this,
          levelIdx: 0
        };
      }
      list = [this];
      startLevel = this.level;
      prevLevel = 0;
      while (list.length > 0) {
        el = list.shift();
        currentLevel = el.level - startLevel;
        if (currentLevel > prevLevel) {
          info.levelIdx = 0;
        }
        if (callback.call(info.ctx, el, currentLevel, info) === false) {
          return this;
        }
        prevLevel = currentLevel;
        info.idx++;
        info.levelIdx++;
        list = list.concat(el.children);
      }
      return this;
    };

    return Tree;

  })();

}).call(this);
