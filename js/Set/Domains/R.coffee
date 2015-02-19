class mathJS.Sets.R extends _mathJS.Sets.Domain

    CLASS = @

    @new: () ->
        return new CLASS()

    constructor: () ->
        super("R", 3, false)

    #################################################################################
    # STATIC


    #################################################################################
    # PUBLIC
    contains: (x) ->
        return new mathJS.Number(x).equals(x)

    clone: @new

    # equals: (set, n = mathJS.settings.set.maxIterations * 10) ->
    #     return set instanceof mathJS.Sets.R

    ###*
    * This method checks if `this` is a subset of the given set `set`. Since equality must be checked by checking an arbitrary number of values this method actually does the same as `this.equals()`. For `this.equals()` the number of compared elements is 10x bigger.
    *###
    isSubsetOf: (set, n = mathJS.settings.set.maxIterations) ->
        return @equals(set, n * 10)

    isSupersetOf: (set) ->
        if @_isSet set
            return set.isSubsetOf @
        return false

    # union: (set) ->
    #     if set.isDomain
    #         if @rank >= set.rank
    #             return @
    #         return set
    #     # TODO !!
    #     return @
    #
    # intersection: (set) ->
    #     if set.isDomain
    #         if @rank <= set.rank
    #             return @
    #         return set
    #     # TODO !!
    #     return set

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
        R:
            value: new mathJS.Sets.R()
            writable: false
            enumerable: true
            configurable: false
    }
