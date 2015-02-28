class mathJS.Sets.Q extends _mathJS.Sets.Domain

    CLASS = @

    @new: () ->
        return new CLASS()

    constructor: () ->
        super("Q", 2, true)

    #################################################################################
    # STATIC


    #################################################################################
    # PUBLIC
    contains: (x) ->
        return new mathJS.Number(x).equals(x)

    ###*
    * This method checks if `this` is a subset of the given set `set`. Since equality must be checked by checking an arbitrary number of values this method actually does the same as `this.equals()`. For `this.equals()` the number of compared elements is 10x bigger.
    *###
    isSubsetOf: (set, n = mathJS.settings.set.maxIterations) ->
        return @equals(set, n * 10)

    isSupersetOf: (set) ->
        if @_isSet set
            return set.isSubsetOf @
        return false

    complement: () ->
        if @universe?
            return @universe.without @
        return new mathJS.EmptySet()
    ###*
    * a.without b => returns: removed all common elements from a
    *###
    without: (set) ->

    cartesianProduct: (set) ->
        # size becomes the bigger one

    @_makeAliases()


do () ->
    # mathJS.Domains.N = new mathJS.Sets.N()
    Object.defineProperties mathJS.Domains, {
        Q:
            value: new mathJS.Sets.Q()
            writable: false
            enumerable: true
            configurable: false
    }
