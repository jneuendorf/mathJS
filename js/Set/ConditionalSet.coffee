class _mathJS.ConditionalSet extends mathJS.Set

    constructor: (expression, domains, predicate) ->
        # TODO: try to find out if the set is actually discrete!


    cartesianProduct: (sets...) ->
        # generator = new mathJS.Generator()
        # generator.tuple = new mathJS.Tuple([@generator].concat(set.generator for set in sets))
        # generator.func = (n) ->
        #     return @tuple.eval(n)

        generators = [@generator].concat(set.generator for set in sets)

        mathJS.Generator.newFromMany(generators...)

        return new _mathJS.ConditionalSet(generator)

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
