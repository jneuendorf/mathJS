# ###*
# * @class ConditionalSet
# * @constructor
# * @param {mathJS.Expression}
# *###
class _mathJS.ConditionalSet extends mathJS.Set

    CLASS = @

    ###
    {2x^2 | x in R and 0 <= x < 20 and x = x^2} ==> {0, 1}
    x in R and 0 <= x < 20 and x = x^2 <=> R intersect [0, 20) intersect {0,1} (where 0 and 1 have to be part of the previous set)
    do the following:
    1. map domains to domains
    2. map unequations to intervals
    3. map equations to (discrete?!) sets
    4. create intersection of all!

    simplifications:
    1.  domains intersect interval = interval (because in this notation the domain is the superset)
        so it wouldnt make sense to say: x in N and x in [0, 10] and expect the set to be infinite!!
        the order does not matter (otherwise (x in [0, 10] and x in N) would be infinite!!)
    2.  when trying to get equation solutions numerically (should this ever happen??) look for interval first to get boundaries
    ###

    # predicate is an boolean expression
    # TODO: try to find out if the set is actually discrete!
    # TODO: maybe a 3rd parameter "baseSet" should be passed to indicate where the generator comes from
    constructor: (expression, predicate) ->
        # empty set
        if arguments.length is 0
            @generator = null
        # non-empty set
        else if expression instanceof mathJS.Generator
            @generator = expression
        # no generator passed => standard parameters
        else
            if predicate instanceof mathJS.Expression
                predicate = predicate.getSet()

            # f, minX=0, maxX=Infinity, stepSize=mathJS.config.number.real.distance, maxIndex=mathJS.config.generator.maxIndex, tuple
            @generator = new mathJS.Generator(
                # f: predicate -> ?? (expression.getSet())
                # x |-> expression(x)
                new mathJS.Function("f", expression, predicate, expression.getSet())
                predicate.min()
                predicate.max()
            )

    cartesianProduct: (sets...) ->
        generators = [@generator].concat(set.generator for set in sets)
        return new _mathJS.ConditionalSet(mathJS.Generator.newFromMany(generators...))

    clone: () ->
        return new CLASS()

    contains: (elem) ->
        if mathJS.isComparable elem
            if @condition?.check(elem) is true
                return true
        return false

    equals: (set) ->
        if set instanceof CLASS
            return @generator.f.equals set.generator.f
        # normal set
        return set.discreteSet.isEmpty() and @generator.f.equals set.conditionSet.generator.f

    getElements: (n, sorted) ->
        res = []
        # TODO
        return res

    # TODO: "and" generators
    intersection: (set) ->

    isSubsetOf: (set) ->

    isSupersetOf: (set) ->

    size: () ->
        return @generator.f.range.size()

    # TODO: "or" generators
    union: (set) ->

    without: (set) ->


    @_makeAliases()

    if DEBUG
        @test = () ->
            e1 = new mathJS.Expression(5)
            e2 = new mathJS.Expression(new mathJS.Variable("x", mathJS.Number))
            e3 = new mathJS.Expression("+", e1, e2)

            p1 = new mathJS.Expression(new mathJS.Variable("x", mathJS.Number))
            p2 = new mathJS.Expression(4)
            p3 = new mathJS.Expression("=", p1, p2)

            console.log p3.eval(x: 4)

            console.log p3.getSet()

            console.log AAA

            # set = new _mathJS.ConditionalSet(e3, p3)

            # console.log set

            return "done"
