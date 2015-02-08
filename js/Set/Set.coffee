###*
* @class Set
* @constructor
* @param {mixed} specifications
* To create an empty set pass no parameters.
* To create a discrete set list the elements. Those elements must implement the comparable interface and must not be arrays. Non-comparable elements will be ignored unless they are primitives.
* To create a set from set-builder notation pass the parameters must have the following types:
* mathJS.Expression, [mathJS.Domains], mathJS.Predicate
*###
class mathJS.Set extends _mathJS.AbstractSet
# class mathJS.Set extends mixOf mathJS.Poolable, mathJS.Comparable, mathJS.Parseable

    ###########################################################################
    # STATIC
    # @_isSet = (set) ->
    #     return set instanceof mathJS.Set or set.instanceof(mathJS.Set)

    ###########################################################################
    # CONSTRUCTOR
    constructor: (parameters...) ->
        # ANALYSE PARAMETERS
        # nothing passed => empty set
        if parameters.length is 0
            @discreteSet = new _mathJS.DiscreteSet()
            @conditionalSet = new _mathJS.ConditionalSet()
            true

        # setset-builder notation
        else if parameters.length is 3 and parameters.second instanceof Array
            console.log "set builder"
        # discrete and conditional set given (from internal calls like union())
        else if parameters.first instanceof _mathJS.DiscreteSet and parameters.second instanceof _mathJS.ConditionalSet
            @discreteSet = parameters.first.clone()
            @conditionalSet = parameters.second.clone()
        # discrete set
        else
            # array given -> make its elements the set elements
            if parameters.first instanceof Array
                parameters = parameters.first

            console.log "params:", parameters

            # list of set elements -> discrete
            @discreteSet = new _mathJS.DiscreteSet(parameters)
            @conditionalSet = new _mathJS.ConditionalSet()
            # for param in parameters
            #     @discreteSet.add param


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
        res = @discreteSet.elems.concat(@conditionalSet.getElements(n, false))

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

    isSubsetOf: (set) ->
        # TODO
        throw new Error("todo!")

    isSupersetOf: (set) ->
        # TODO
        throw new Error("todo!")

    contains: (elem) ->
        return set.conditionalSet.contains(@conditionalSet) or set.discreteSet.contains(@discreteSet)

    union: (set) ->
        return new mathJS.Set(@discreteSet.union(set.discreteSet), @conditionalSet.union(set.conditionalSet))

    complement: () ->
        if @universe?
            return asdf
        return new mathJS.EmptySet()
    ###*
    * a.without b => returns: removed all common elements from a
    *###
    without: (set) ->

    cartesianProduct: (set) ->
