class mathJS.EmptySet extends mathJS.Set

    ###*
    * @Override
    * see mathJS.Poolable
    * @static
    * @method fromPool
    *###
    @fromPool: () ->
        if @_pool.length > 0
            return @_pool.pop()
        return new @()

    @new: () ->
        return @fromPool()

    ###########################################################################################
    # CONSTRUCTOR
    constructor: () ->

    ###########################################################################################
    # PUBLIC METHODS
    clone: () ->
        return mathJS.EmptySet.new()

    equals: (set) ->
        return set instanceof mathJS.EmptySet

    addElem: (elem) ->
        if DEBUG
            console.warn "prototype change!"
        @makeToDiscreteSet()
        return @

    addElems: (elems) ->
        set = mathJS.EmptySet.new()
        for elem in elems when elem instanceof @type
            set.addElem elem

    removeElem: (elem) ->
        if elem instanceof @type
            return @without(new mathJS.DiscreteSet(@type, elem))
            # subset.remove elem for subset in @subsets
            #
            # elems = []
            # for e in @elems
            #     if e.equals(elem) or e is elem
            #         continue
            #     elems.push e
            #
            # @elems = elems
        return @

    contains: (elem) ->
        if elem instanceof @type
            for subset in @subsets
                if subset.contains elem
                    return true
        return false

    union: (set) ->
        # TODO: how to avoid doubles?
        # see if the set matches any already existing set
        if @intersects set
            # remove duplicates from given set
            set = set.without @
            @subsets.push set
        # disjoint sets
        else
            @subsets.push set

        return @

    intersect: (set) ->
        return mathJS.EmptySet.new()

    intersects: (set) ->
        return false

    disjoint: (set) ->
        return true

    complement: () ->
        if @universe?
            return @universe
        return mathJS.EmptySet.new()
        
    ###*
    * a.without b => returns: removed all common elements from a
    *###
    without: (set) ->
        return

    size: () ->
        return 0

    ###*
    * @Override mathJS.Poolable
    * see mathJS.Poolable
    * @method release
    *###
    release: () ->
        @constructor._pool.push @
        return @constructor
