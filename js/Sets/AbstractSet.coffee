class _mathJS.AbstractSet extends _mathJS.Object

    @implement _mathJS.Orderable, _mathJS.Poolable, _mathJS.Parseable

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

    disjoint: (set) ->
        return @intersection(set).size() is 0

    intersects: (set) ->
        return not @disjoint(set)

    isEmpty: () ->
        return @size() is 0

    isSupersetOf: (set) ->
        return set.isSubsetOf @

    pow: (exponent) ->
        sets = []
        for i in [0...exponent]
            sets.push @
        return @cartesianProduct.apply(@, sets)

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
