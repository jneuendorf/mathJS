class _mathJS.AbstractSet

    # constructor: () ->
    #     if arguments.callee.caller isnt mathJS.Set
    #         throw new mathJS.Errors.AbstractInstantiationError("mathJS.AbstractSet can\'t be instantiated!")

    cartesianProduct: (set) ->

    clone: () ->

    contains: (elem) ->

    equals: (set) ->

    getElements: () ->

    intersection: (set) ->

    isSubsetOf: (set) ->

    size: () ->

    union: (set) ->

    without: (set) ->

    min: () ->

    max: () ->

    infimum: () ->

    supremum: () ->

    ###########################################################################
    # PRE-IMPLEMENTED
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
    cardinality: @::size

    difference: @::without
    except: @::without
    minus: @::without

    has: @::contains

    intersect: @::intersection

    subsetOf: @::isSubsetOf

    supersetOf: @::isSupersetOf

    times: @::cartesianProduct
