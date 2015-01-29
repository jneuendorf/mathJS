class mathJS.ConditionalSet extends mathJS.Set

    constructor: (condition, universe = null) ->
        if condition instanceof mathJS.SetSpec
            @condition = condition
        else
            @condition = null

        @leftBoundary = null
        @rightBoundary = null

        Object.defineProperties @, {
            # elems:
            #     value: @elems
            #     enumerable: false
            _universe:
                value: universe
                enumerable: false
                writable: true
            universe:
                get: () ->
                    return @_universe
                set: (universe) ->
                    if universe instanceof mathJS.Set or universe is null
                        @_universe = universe
                    return @
                enumerable: true
            size:
                value: @elems.length
                enumerable: false
                writable: false
                configurable: true # for overwriting in case of in-place union
        }



    clone: () ->
        # TODO
        throw new Error("todo!")
        return

    equals: (set) ->
        # TODO
        throw new Error("todo!")

    isSubsetOf: (set) ->
        # TODO
        throw new Error("todo!")

    isSupersetOf: (set) ->
        # TODO
        throw new Error("todo!")

    forAll: () ->

    exists: () ->

    # addElem: (elem) ->
    #     if elem instanceof @type
    #         return @union(new mathJS.DiscreteSet(@type, elem))
    #     return @
        # elem = @_getValueFromParam(elem)
        #
        # if elem?
        #     for subset in @subsets
        #         # element already in some subset => return
        #         if subset.contains elem
        #             return @
        #
        #     # element is in no subset and not in elements
        #     for e in @elems when e.equals?(elem) or e is elem
        #         return @
        #
        #     # at this point we know that the element is not in the set
        #     @elems.push elem
        #
        # return @

    # addElems: (elems) ->
    #     set = new mathJS.EmptySet()
    #     for elem in elems when elem instanceof @type
    #         set.addElem elem

    # removeElem: (elem) ->
    #     if elem instanceof @type
    #         return @without(new mathJS.DiscreteSet(@type, elem))
    #         # subset.remove elem for subset in @subsets
    #         #
    #         # elems = []
    #         # for e in @elems
    #         #     if e.equals(elem) or e is elem
    #         #         continue
    #         #     elems.push e
    #         #
    #         # @elems = elems
    #     return @

    contains: (elem) ->
        if mathJS.isComparable elem
            if @condition?.check(elem) is true
                return true
        return false

    union: (set) ->
        # TODO: how to avoid doubles?
        # see if the set matches any already existing set
        # if @intersects set
        #     # remove duplicates from given set
        #     set = set.without @
        #     @subsets.push set
        # # disjoint sets
        # else
        #     @subsets.push set

        return @

    intersect: (set) ->
        return

    intersects: (set) ->
        return @intersection.size() > 0

    disjoint: (set) ->
        return @intersection.size() is 0

    complement: () ->
        if @universe?
            return asdf
        return new mathJS.EmptySet()
    ###*
    * a.without b => returns: removed all common elements from a
    *###
    without: (set) ->

    cartesianProduct: (set) ->

    times: @::cartesianProduct

    # size: () ->
    #     return @_discreteSet.size + @_conditionalSet.size

    isEmpty: () ->
        return @size > 0

    cardinality: @::size
