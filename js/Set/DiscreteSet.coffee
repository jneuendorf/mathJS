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
class _mathJS.DiscreteSet extends mathJS.Set

    ###########################################################################
    # CONSTRUCTOR
    constructor: (elems...) ->
        if elems.first instanceof Array
            elems = elems.first

        @elems = []

        for elem in elems when not @contains(elem)
            if not mathJS.isNum(elem)
                @elems.push elem
            else
                @elems.push new mathJS.Number(elem)

    ###########################################################################
    # PROTECTED METHODS


    ###########################################################################
    # PUBLIC METHODS

    # discrete sets only!
    cartesianProduct: (set) ->
        elements = []
        for e in @elems
            for x in set.elems
                elements.push new mathJS.Tuple(e, x)

        return new _mathJS.DiscreteSet(elements)

    clone: () ->
        return new _mathJS.DiscreteSet(@elems)

    contains: (elem) ->
        for e in @elems when elem.equals e
            return true
        return false

    # discrete sets only!
    equals: (set) ->
        # return @isSubsetOf(set) and set.isSubsetOf(@)
        for e in @elems when not set.contains e
            return false

        for e in set.elems when not @contains e
            return false

        return true

    ###*
    * Get the elements of the set.
    * @method getElements
    * @param sorted {Boolean}
    * Optional. If set to `true` returns the elements in ascending order.
    *###
    getElements: (sorted=false) ->
        if sorted isnt true
            return @elems.clone()
        return @elems.clone().sort(mathJS.sortFunction)

    # discrete sets only!
    intersection: (set) ->
        elems = []
        for x in @elems
            for y in set.elems when x.equals y
                elems.push x

        return new _mathJS.DiscreteSet(elems)

    isSubsetOf: (set) ->
        for e in @elems when not set.contains e
            return false
        return true

    isSupersetOf: (set) ->
        return set.isSubsetOf @

    size: () ->
        # TODO: cache size
        return @elems.length

    # discrete sets only!
    union: (set) ->
        return new _mathJS.DiscreteSet(set.elems.concat(@elems))

    without: (set) ->
        return (elem for elem in @elems when not set.contains elem)
