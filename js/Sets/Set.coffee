###*
* @class Set
* @constructor
* @param {mixed} specifications
* To create an empty set pass no parameters.
* To create a discrete set list the elements. Those elements must implement the comparable interface and must not be arrays. Non-comparable elements will be ignored unless they are primitives.
* To create a set from set-builder notation pass the parameters must have the following types:
* mathJS.Expression|mathJS.Tuple|mathJS.Number, mathJS.Predicate
# TODO: package all those types (expression-like) into 1 prototype (Variable already is)
*###
class mathJS.Set extends _mathJS.AbstractSet

    ###########################################################################
    # STATIC

    ###*
    * Optionally the left and right configuration can be passed directly (each with an open- and value-property) or the Interval can be parsed from String (like "(2, 6 ]").
    * @static
    * @method createInterval
    * @param leftOpen {Boolean}
    * @param leftValue {Number|mathJS.Number}
    * @param rightValue {Number|mathJS.Number}
    * @param rightOpen {Boolean}
    *###
    @createInterval: (parameters...) ->
        if typeof (str = parameters.first) is "string"
            # remove spaces
            str = str.replace /\s+/g, ""
                     .split ","

            left =
                open: str.first[0] is "("
                value: new mathJS.Number(parseInt(str.first.slice(1), 10))
            right =
                open: str.second.last is ")"
                value: new mathJS.Number(parseInt(str.second.slice(0, -1), 10))
        # # first parameter has an .open property => assume ctor called from fromString()
        # else if parameters.first.open?
        #     left = parameters.first
        #     right = parameters.second
        else
            second = parameters.second
            fourth = parameters.fourth
            left =
                open: parameters.first
                value: (if second instanceof mathJS.Number then second else new mathJS.Number(second))
            right =
                open: parameters.third
                value: (if fourth instanceof mathJS.Number then fourth else new mathJS.Number(fourth))

        # an interval can be expressed with a conditional set: (a,b) = {x | x in R, a < x < b}
        expression = new mathJS.Variable("x", mathJS.Domains.N)
        predicate = null

        return new mathJS.Set(expression, predicate)


    ###########################################################################
    # CONSTRUCTOR
    constructor: (parameters...) ->
        # ANALYSE PARAMETERS
        # nothing passed => empty set
        if parameters.length is 0
            @discreteSet = new _mathJS.DiscreteSet()
            @conditionalSet = new _mathJS.ConditionalSet()

        # discrete and conditional set given (from internal calls like union())
        else if parameters.first instanceof _mathJS.DiscreteSet and parameters.second instanceof _mathJS.ConditionalSet
            @discreteSet = parameters.first
            @conditionalSet = parameters.second
        # set-builder notation
        else if parameters.first instanceof mathJS.Expression and parameters.second instanceof mathJS.Expression
            console.log "set builder"
            @discreteSet = new _mathJS.DiscreteSet()
            @conditionalSet = new _mathJS.ConditionalSet(parameters.first, parameters.slice(1))
        # discrete set
        else
            # array given -> make its elements the set elements
            if parameters.first instanceof Array
                parameters = parameters.first

            console.log "params:", parameters

            @discreteSet = new _mathJS.DiscreteSet(parameters)
            @conditionalSet = new _mathJS.ConditionalSet()


    ###########################################################################
    # PRIVATE METHODS
    # TODO: inline the following 2 if used nowhere else
    newFromDiscrete = (set) ->
        return new mathJS.Set(set.getElements())

    newFromConditional = (set) ->
        return new mathJS.Set(set.expression, set.domains, set.predicate)

    ###########################################################################
    # PROTECTED METHODS

    ###########################################################################
    # PUBLIC METHODS
    getElements: (n=mathJS.config.set.defaultNumberOfElements, sorted=false) ->
        res = @discreteSet.elems.concat(@conditionalSet.getElements(n, sorted))

        if sorted isnt true
            return res

        return res.sort(mathJS.sortFunction)

    size: () ->
        return @discreteSet.size() + @conditionalSet.size()

    clone: () ->
        return newFromDiscrete(@discreteSet).union(newFromConditional(@conditionalSet))

    equals: (set) ->
        if set.size() isnt @size()
            return false
        return set.discreteSet.equals(@discreteSet) and set.conditionalSet.equals(@conditionalSet)

    getSet: () ->
        return @

    isSubsetOf: (set) ->
        return @conditionalSet.isSubsetOf(set) or @discreteSet.isSubsetOf(set)

    isSupersetOf: (set) ->
        return @conditionalSet.isSupersetOf(set) or @discreteSet.isSupersetOf(set)

    contains: (elem) ->
        return @conditionalSet.contains(@conditionalSet) or @discreteSet.contains(@discreteSet)

    union: (set) ->
        # if domain (N, Z, Q, R, C) let it handle the union because it knows know more about itself than this does
        # also domains have neither discrete nor conditional sets
        if set.isDomain
            return set.union(@)
        return new mathJS.Set(@discreteSet.union(set.discreteSet), @conditionalSet.union(set.conditionalSet))

    intersection: (set) ->
        if set.isDomain
            return set.intersection(@)
        return new mathJS.Set(@discreteSet.intersection(set.discreteSet), @conditionalSet.intersection(set.conditionalSet))

    complement: () ->
        if @universe?
            return asdf
        return new mathJS.EmptySet()

    without: (set) ->

    cartesianProduct: (set) ->

    min: () ->
        return mathJS.min(@discreteSet.min().concat @conditionalSet.min())

    max: () ->
        return mathJS.max(@discreteSet.max().concat @conditionalSet.max())

    infimum: () ->

    supremum: () ->
