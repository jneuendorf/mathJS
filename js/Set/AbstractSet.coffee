class _mathJS.AbstractSet

    cartesianProduct: (set) ->

    clone: () ->

    contains: (elem) ->

    equals: (set) ->

    getElements: () ->

    infimum: () ->

    intersection: (set) ->

    isSubsetOf: (set) ->

    min: () ->

    max: () ->

    # PRE-IMPLEMENTED (may be inherited)
    size: () ->
        return Infinity

    supremum: () ->

    union: (set) ->

    intersection: (set) ->

    without: (set) ->


    ###########################################################################
    # PRE-IMPLEMENTED (to be inherited)
    complement: (universe) ->
        return universe.minus(@)

    intersects: (set) ->
        return not @disjoint(set)

    isEmpty: () ->
        return @size() is 0

    isSupersetOf: (set) ->
        return set.isSubsetOf @

    disjoint: (set) ->
        return @intersection(set).size() is 0

    ###########################################################################
    # ALIASES
    @_makeAliases: () ->
        aliasesData =
            size:               ["cardinality"]
            without:            ["difference", "except", "minus"]
            contains:           ["has"]
            intersection:       ["intersect"]
            isSubsetOf:         ["subsetOf"]
            isSupersetOf:       ["supersetOf"]
            cartesianProduct:   ["times"]

        for orig, aliases of aliasesData
            for alias in aliases
                @::[alias] = @::[orig]

        return @

    @_makeAliases()
