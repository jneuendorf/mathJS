class mathJS.AbstractSet

    constructor: () ->
        if arguments.callee.caller isnt mathJS.Set
            throw new mathJS.Errors.AbstractInstantiationError("mathJS.AbstractSet can\'t be instantiated!")

    size: () ->

    equals: (set) ->

    contains: (x) ->
        return @_c(x)

    clone: () ->

    union: (set) ->

    intersects: (set) ->
        return not @disjoint(set)

    intersection: (set) ->

    disjoint: (set) ->
        return @intersection(set).size() is 0

    isSubsetOf: (set) ->

    isSupersetOf: (set) ->

    complement: () ->

    without: (set) ->

    isEmpty: () ->
        return @size() is 0

    cartesianProduct: (set) ->


    # ALIASES
    except: @without
    minus: @without
    difference: @without
    supersetOf: @isSupersetOf
    subsetOf: @isSubsetOf
    has: @contains
    cardinality: @size
    times: @cartesianProduct
