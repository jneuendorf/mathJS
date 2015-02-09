class _mathJS.ConditionalSet extends mathJS.Set

    constructor: (condition, universe = null) ->
        # if condition instanceof mathJS.SetSpec
        #     @condition = condition
        # else
        #     @condition = null
        #
        # @leftBoundary = null
        # @rightBoundary = null
        #
        # Object.defineProperties @, {
        #     # elems:
        #     #     value: @elems
        #     #     enumerable: false
        #     _universe:
        #         value: universe
        #         enumerable: false
        #         writable: true
        #     universe:
        #         get: () ->
        #             return @_universe
        #         set: (universe) ->
        #             if universe instanceof mathJS.Set or universe is null
        #                 @_universe = universe
        #             return @
        #         enumerable: true
        #     size:
        #         value: @elems.length
        #         enumerable: false
        #         writable: false
        #         configurable: true # for overwriting in case of in-place union
        # }

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
