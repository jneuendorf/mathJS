###*
* This class is a Setof explicitely listed elements (with no needed logic).
* @class DiscreteSet
* @constructor
* @param {Function|Class} type
* @param {Set} universe
* Optional. If given, the created Set will be interpreted as a sub set of the universe.
* @param {mixed} elems...
* Optional. This and the following parameters serve as elements for the new Set. They will be in the new Set immediately.
* @extends Set
*###
class mathJS.DiscreteSet extends mathJS.Set

    ###########################################################################
    # CONSTRUCTOR
    constructor: (elems = []) ->
        @leftBoundary = null
        @rightBoundary = null
        @condition = null
        @elems = []

        for elem in elems when mathJS.isComparable(elem) and not @contains(elem)
            @elems.push elem

        Object.defineProperties @, {
            elems:
                value: @elems
                enumerable: false
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
                value: @elems.length
                enumerable: false
                writable: false
                configurable: true # for overwriting in case of in-place union
        }

    ###########################################################################
    # PROTECTED METHODS


    ###########################################################################
    # PUBLIC METHODS

    isSubsetOf: (set) ->
        for e in @elems
            if not set.contains e
                return false
        return true

    isSupersetOf: (set) ->
        return set.isSubsetOf @

    clone: () ->
        return new mathJS.DiscreteSet(@elems)

    ###*
    * @Override
    *###
    equals: (set) ->
        return @isSubsetOf(set) and set.isSubsetOf(@)

    contains: (elem) ->
        if mathJS.isComparable elem
            for e in @elems when e is elem or e.equals?(elem)
                return true
        return false

    union: (set) ->
        if set instanceof mathJS.DiscreteSet
            # console.log "here we are!", @elems.concat set.elems
            return new mathJS.DiscreteSet(@elems.concat set.elems)
        else if set instanceof mathJS.ConditionalSet
            # throw new Error("Todo!") TODO
            return "asdf"

    intersect: (set) ->
        if set instanceof mathJS.DiscreteSet
            elems = []
            for x in @elems
                for y in set.elems
                    if x.equals y
                        elems.push x
            if elems.length > 0
                res = new mathJS.DiscreteSet(@type, @universe)



        else if set instanceof mathJS.ConditionalSet

        else if set instanceof mathJS.EmptySet
            return new mathJS.EmptySet()
        return null



    complement: () ->
        if @universe?
            return
        return new mathJS.EmptySet()
    ###*
    * a.without b => returns: removed all common elements from a
    *###
    without: (set) ->
