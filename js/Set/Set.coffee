###*
* @class Set
* @constructor
* @param {mixed} specifications
* To create an empty set pass no parameters.
* To create a discrete set list the elements.
* To create a set from set-builder notation pass the parameters must have the following types:
* mathJS.Expression, [mathJS.Domains], mathJS.Predicate
*###
class mathJS.Set extends mathJS.AbstractSet
# class mathJS.Set extends mixOf mathJS.Poolable, mathJS.Comparable, mathJS.Parseable
    ###########################################################################
    # STATIC

    @_isSet = (set) ->
        return set instanceof mathJS.Set or set.instanceof(mathJS.Set)

    ###########################################################################
    # CONSTRUCTOR
    constructor: (parameters...) ->
        @discreteSet = new mathJS.DiscreteSet()
        @conditionalSet = new mathJS.ConditionalSet()
        @_size = null

        # ANALYSE PARAMETERS
        # nothing passed => empty set
        if parameters.length is 0
            # @_size = 0
            true

        # setset-builder notation
        else if parameters.length is 3 and parameters.second instanceof Array
            console.log "set builder"
        # list of set elements -> discrete
        else
            for param in parameters
                @discreteSet.add param


    ###########################################################################
    # PRIVATE METHODS

    ###########################################################################
    # PROTECTED METHODS

    ###########################################################################
    # PUBLIC METHODS
    size: () ->
        if @_size?
            @_size = @discreteSet.size() + @conditionalSet.size()
        return @_size

    clone: () ->
        # TODO
        throw new Error("todo!")
        return

    equals: (set) ->
        # TODO
        throw new Error("todo!")

    isSubsetOf: (set) ->
        # TODO
        throw new Error("todo!")

    isSupersetOf: (set) ->
        # TODO
        throw new Error("todo!")

    forAll: () ->

    exists: () ->

    contains: (elem) ->
        if elem instanceof @type
            for subset in @subsets
                if subset.contains elem
                    return true
        return false

    union: (set) ->
        # TODO: how to avoid doubles?
        # see if the set matches any already existing set
        # if @intersects set
        #     # remove duplicates from given set
        #     set = set.without @
        #     @subsets.push set
        # # disjoint sets
        # else
        #     @subsets.push set

        return @

    complement: () ->
        if @universe?
            return asdf
        return new mathJS.EmptySet()
    ###*
    * a.without b => returns: removed all common elements from a
    *###
    without: (set) ->

    cartesianProduct: (set) ->

    times: @::cartesianProduct
