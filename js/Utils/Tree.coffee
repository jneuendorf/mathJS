class mathJS.Utils.Tree

    CLASS = @

    ###*
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
    *###
    @new = (node, options) ->
        if node instanceof @
            return new CLASS(node)

        if node.children?
            return CLASS.new.byChildRef(node)

        if node.parent?
            return CLASS.new.byParentRef(node)

        if options?
            if options.getChildren?
                return CLASS.new.byChildRef(node, options)
            if options.getParent?
                return CLASS.new.byParentRef(node, options)

        if DEBUG
            console.warn "No recusrive structure found! Use correct options."

        return null

    ###*
    * @method new.byChildRef
    * @static
    * @param node {Object}
    * @param options {Object}
    * Optional. Any given key will override the default. Here are the keys:
    * adjustLevels: Boolean value that indicates whether the tree is supposed to do its aftermath. Only set this to false if you're doing the aftermath later!!
    * afterInstatiate: Function to modify the node and/or the instance. Parameters are (1st) the node object and (2nd) the instance.
    * getChildren: Function that specifies how to retrieve the children from the node object.
    * instantiate: Function that specifies how to create an instance from the node object. Parameter is the node object.
    *###
    @new.byChildRef = (node, options) ->
        defaultOptions =
            getChildren: (nodeData) ->
                return nodeData.children
            instantiate: (nodeData) ->
                return new CLASS(nodeData)
            afterInstatiate: (nodeData, node) ->
                return false
            adjustLevels: true
        options = $.extend defaultOptions, options

        # cache value because it will be set to false for recursion calls
        adjustLevels = options.adjustLevels
        options.adjustLevels = false

        tree = options.instantiate node
        options.afterInstatiate node, tree

        for child in options.getChildren(node) or []
            childInstance = CLASS.new.byChildRef(child, options)
            tree.addChild(childInstance, false)

        if adjustLevels
            tree.adjustLevels 0

        return tree

    ###*
    * @method new.byParentRef
    * @static
    * @param node {Object}
    * @param options {Object}
    * Optional. Any given key will override the default. Here are the keys:
    * adjustLevels: Boolean value that indicates whether the tree is supposed to do its aftermath. Only set this to false if you're doing the aftermath later!!
    * afterInstatiate: Function to modify the node and/or the instance. Parameters are (1st) the node object and (2nd) the instance.
    * getParent: Function that specifies how to retrieve the parent from the node object.
    * instantiate: Function that specifies how to create an instance from the node object. Parameter is the node object.
    *###
    # TODO !!!
    @new.byParentRef = (node, getParent) ->
        tree = new CLASS()

    @fromRecursive = @new

    ##################################################################################################
    ##################################################################################################
    # CONSTRUCTOR
    constructor: (node, options) ->
        self = @

        @children       = []
        @parent         = null
        @descendants    = []
        @orderMode      = "postorder"

        if not node?
            @data = {}
        else
            @data = node

    ##################################################################################################
    # READ-ONLY PROPERTIES
    Object.defineProperties @::, {
        depth:
            get: () ->
                return @getDepth()
            set: () ->
                return @
        size:
            get: () ->
                return @getSize()
            set: () ->
                return @
        level:
            get: () ->
                return @getLevel()
            set: () ->
                return @
        root:
            get: () ->
                return @getRoot()
            set: () ->
                return @
    }

    ##################################################################################################
    # INTERNAL
    _cacheDescendants: () ->
        res = []
        for child in @children
            child._cacheDescendants()
            res = res.concat child.descendants

        @descendants = @children.concat res
        return @
        # res = []
        # @each (node) ->
        #     if node isnt @
        #         res.push node
        #     return true
        # @descendants = res
        # return @

    ##################################################################################################
    # INFORMATION ABOUT THE TREE
    ###*
    * Find (first occurence of) a node
    * @method findNode
    * @param nodeOrEqualsFunction {Function|App.Tree}
    *###
    findNode: (param) ->
        return @findNodes(param)?.first or null

    findDescendant: () ->
        return @findNode.apply(@, arguments)

    ###*
    * Find all occurences of a node.
    * @method findNodes
    * @param nodeOrEqualsFunction {Function|App.Tree}
    *###
    findNodes: (param) ->
        res = []
        # find by match criterea function
        if param instanceof Function
            res.push node for node in @descendants when param(node)
        # find by node ref
        if param instanceof App.Tree
            for node in @descendants when param is node
                res.push node
        # not found
        return res

    findDescendants: () ->
        return @findNodes.apply(@, arguments)

    getDepth: () ->
        if @children.length > 0
            maxLevel = @descendants.getMax (node) ->
                return node.level
            return maxLevel.first.level - @level
        return 0

    ###*
    * Get number of nodes in (sub)tree
    *###
    getSize: () ->
        return @descendants.length + 1

    getLevel: () ->
        return @_level

    getRoot: () ->
        if not (root = @parent)?
            return @

        while root.parent?
            root = root.parent

        return root

    ##################################################################################################
    # NODE RELATIONS
    getSiblings: () ->
        return @parent?.children.except(@) or []

    getLevelSiblings: () ->
        self = @
        siblings = @parent?.findNodes (node) ->
            return node.level is self.level and node isnt self
        return siblings or []

    getParent: () ->
        return @parent

    getChildren: () ->
        return @children

    ##################################################################################################
    # MODIFYING THE TREE
    # this can also move nodes within the tree or between trees
    addChild: (node, adjustLevels=true) ->
        if node not instanceof App.Tree
            node = new CLASS(node)

        @children.push node
        # @descendants.push node => done in adjustLevels()

        if node.parent? and node.parent isnt @ and node not in node.parent.children
            node.parent.children = node.parent.children.except node

        node.parent = @
        if adjustLevels
            node.adjustLevels @level

        return @

    appendChild: () ->
        return @addChild.apply(@, arguments)

    addChildren: (nodes, adjustLevels=true) ->
        for node in nodes
            @addChild node, false
        if adjustLevels
            @adjustLevels @level
        return @

    appendChildren: () ->
        return @addChildren.apply(@, arguments)

    setChildren: (nodes, clone=false, adjustLevels=true) ->
        @children = []

        if clone
            nodes = (node.clone() for node in nodes)

        for node in nodes
            @addChild node, false

        if adjustLevels
            @adjustLevels @level
        return @

    remove: () ->
        if @parent?
            @parent.children = (n for n in @parent.children when n isnt @)
            # recache descendatas
            @parent._cacheDescendants()
            @parent = null
        @adjustLevels()
        @_level = 0
        return @

    removeChild: (node) ->
        return node.remove()

    removeChildAt: (idx) ->
        return removeChild @children[idx]

    appendTo: (node) ->
        return node.addChild @

    adjustLevels: (startLevel=0) ->
        @_cacheDescendants().each (n, l, i) ->
            n._level = startLevel + l
            return true
        return @

    ##################################################################################################
    # TRAVERSING THE TREE

    ###*
    * @method traverse
    * @param callback {Function}
    * Gets the current node, the current level relative to the root of the current traversal, and iteration index as parameters.
    * @param orderMode {String}
    * Optional. Default is "postorder". Possible are "postorder", "preorder", "inorder", "levelorder".
    * @param searchMode {String}
    * Optional. Default is "depthFirst". Posible are "depthFirst", "breadthFirst".
    *###
    traverse: (callback, orderMode=@orderMode or "postorder", inorderIndex=null) ->
        return @[orderMode](callback, null, inorderIndex)

    each: () ->
        return @traverse.apply(@, arguments)

    postorder: (callback, level=0, info={idx: 0, ctx: @}) ->
        for child in @children
            child.postorder(callback, level + 1, info)
            info.idx++

        if callback.call(info.ctx, @, level, info.idx) is false
            return @
        return @

    preorder: (callback, level=0, info={idx: 0, ctx: @}) ->
        if callback.call(info.ctx, @, level, info.idx) is false
            return @

        for child in @children
            child.preorder(callback, level + 1, info)
            info.idx++

        return @

    inorder: (callback, level, index=@children.length // 2, info={idx: 0, ctx: @}) ->
        for i in [0...index]
            @children[i].inorder(callback, level + 1, index, info)
            info.idx++

        if callback.call(info.ctx, @, level, info.idx) is false
            return @

        for i in [index...@children.lenth]
            @children[i].inorder(callback, level + 1, index, info)
            info.idx++

        return @

    levelorder: (callback, level=0, info={idx: 0, ctx: @, levelIdx: 0}) ->
        list = [@]

        startLevel = @level
        prevLevel = 0

        while list.length > 0
            # remove 1st elem from list
            el = list.shift()

            currentLevel = el.level - startLevel

            # going to new level => reset level index
            if currentLevel > prevLevel
                info.levelIdx = 0

            if callback.call(info.ctx, el, currentLevel, info) is false
                return @

            prevLevel = currentLevel

            info.idx++
            info.levelIdx++

            list = list.concat el.children

        return @
