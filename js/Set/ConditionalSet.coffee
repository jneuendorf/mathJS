class _mathJS.ConditionalSet extends mathJS.Set

    constructor: (expression, predicate) ->
        # TODO: try to find out if the set is actually discrete!
        if expression not instanceof mathJS.Generator
            @expression = expression
            @predicate = predicate
        else
            true


    cartesianProduct: (sets...) ->
        generators = [@generator].concat(set.generator for set in sets)
        return new _mathJS.ConditionalSet(mathJS.Generator.newFromMany(generators...))

    clone: () ->

    contains: (elem) ->
        if mathJS.isComparable elem
            if @condition?.check(elem) is true
                return true
        return false

    equals: (set) ->

    getElements: (n, sorted) ->
        res = []
        # TODO
        return res

    intersection: (set) ->

    isSubsetOf: (set) ->

    size: () ->

    union: (set) ->

    without: (set) ->
