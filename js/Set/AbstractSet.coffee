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

    isSupersetOf: (set) ->

    size: () ->

    union: (set) ->

    without: (set) ->

    ###########################################################################
    # PRE-IMPLEMENTED
    complement: (universe) ->
        return universe.minus(@)

    isEmpty: () ->
        return @size() is 0

    intersects: (set) ->
        return not @disjoint(set)

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
