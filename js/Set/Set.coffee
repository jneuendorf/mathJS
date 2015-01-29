###*
* @class Set
* @constructor
* @param {Object} boundarySettings
* @param {Function} condition
* Optional. If given, the created Set will bounded by that condition
* @param {Array} elems
* Optional. This parameter serves as elements for the new Set. They will be in the new Set immediately.
* It is an array of comparable elements (that means if `mathJS.isComparable() === true`); non-comparables will be ignored.
*###
class mathJS.Set extends mixOf mathJS.Poolable, mathJS.Comparable, mathJS.Parseable
    ###########################################################################
    # STATIC

    # @disjoint: (set1, set2) ->
    #     return set1.intersects set2

    # predefined set conditions (should be used!)
    # @isInt: new mathJS.SetSpec(
    #     (x) ->
    #         return new mathJS.Int(x).equals(x)
    #     false
    # )
    # @range: new mathJS.SetSpec(
    #     (x) ->
    #         return new mathJS.Int(x).equals(x)
    #     false
    # )


    @_isSet = (set) ->
        return set instanceof mathJS.Set or set.instanceof(mathJS.Set)

    ###########################################################################
    # CONSTRUCTOR
    # TODO: make constructor to be able to take 3 configurations of parameters (set, ConditionalSet, DiscreteSet)
    constructor: (boundarySettings, condition, elems = []) ->
        # nothing passed => assume a domain is created
        if arguments.length is 0
            return


        if not boundarySettings?
            boundarySettings =
                leftBoundary: null
                rightBoundary: null

        @leftBoundary = boundarySettings.leftBoundary
        @rightBoundary = boundarySettings.rightBoundary

        if condition instanceof Function
            @condition = condition
        else
            @condition = null


        @_discreteSet = new mathJS.DiscreteSet()
        @_conditionalSet = new mathJS.ConditionalSet()

        for elem in elems when mathJS.isComparable elem
            # discrete set => union w/ discrete set
            if elem instanceof mathJS.DiscreteSet or elem.instanceof?(mathJS.DiscreteSet)
                @_discreteSet = @_discreteSet.union elem
            # conditional set  => union w/ conditional set
            else if elem instanceof mathJS.ConditionalSet or elem.instanceof?(mathJS.ConditionalSet)
                @_conditionalSet = @_conditionalSet.union elem
            # mathJS.Number or primitive => union w/ discrete set
            else
                @_discreteSet = @_discreteSet.union new mathJS.DiscreteSet( [elem] )

        # console.log ">>", @_discreteSet, @_conditionalSet

        Object.defineProperties @, {
            _universe:
                value: null
                enumerable: false
                writable: true
            universe:
                get: () ->
                    return @_universe
                set: (universe) ->
                    if universe instanceof mathJS.Set or universe is null
                        @_universe = universe
                    return @
                enumerable: true
            size:
                value: @_discreteSet.size + @_conditionalSet.size
                enumerable: true
                writable: false
                configurable: true # for overwriting in case of in-place union
        }

    ###########################################################################
    # PRIVATE METHODS

    ###########################################################################
    # PROTECTED METHODS

    ###########################################################################
    # PUBLIC METHODS

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

    has: @::contains

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

    intersect: (set) ->
        return

    intersects: (set) ->
        return @intersection.size() > 0

    disjoint: (set) ->
        return @intersection.size() is 0

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

    # size: () ->
    #     return @_discreteSet.size + @_conditionalSet.size

    isEmpty: () ->
        return @size is 0

    # cardinality: @::size

    # makeToDiscreteSet: () ->
    #     @.__proto__ = mathJS.DiscreteSet.prototype
    #     return @
    #
    # makeToConditionalSet: () ->
    #     @.__proto__ = mathJS.ConditionalSet.prototype
    #     return @
