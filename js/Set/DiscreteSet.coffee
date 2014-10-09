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
    constructor: (type, universe, elems...) ->
        # if type instanceof mathJS.Comparable
        #     @type = type
        #     @universe = universe
        #     @subsets = []
        # else
        #     throw new Error("Wrong (incomparable) type given ('#{type.name}')! Sets must consist of comparable elements!")

    ###########################################################################
    # PROTECTED METHODS


    ###########################################################################
    # PUBLIC METHODS
    getElements: () ->
        return @elems

    ###*
    * @Override
    *###
    equals: (set) ->
        throw new Error("todo!")

    addElem: (elem) ->
        if elem instanceof @type
            return @union(new mathJS.DiscreteSet(@type, elem))
        return @
        # elem = @_getValueFromParam(elem)
        #
        # if elem?
        #     for subset in @subsets
        #         # element already in some subset => return
        #         if subset.contains elem
        #             return @
        #
        #     # element is in no subset and not in elements
        #     for e in @elems when e.equals?(elem) or e is elem
        #         return @
        #
        #     # at this point we know that the element is not in the set
        #     @elems.push elem
        #
        # return @

    removeElem: (elem) ->
        if elem instanceof @type
            return @without(new mathJS.DiscreteSet(@type, elem))
            # subset.remove elem for subset in @subsets
            #
            # elems = []
            # for e in @elems
            #     if e.equals(elem) or e is elem
            #         continue
            #     elems.push e
            #
            # @elems = elems
        return @

    contains: (elem) ->
        if elem instanceof @type
            for e in @elems when e.equals(elem)
                return true
        return false

    in: @::contains

    unionSelf: (set) ->
        if set instanceof mathJS.DiscreteSet
            # some common elements
            if (intersection = @intersect(set)).size() > 0
                @elems.push.apply @elems, set.without intersection
            # disjoint sets => add 'em all
            else
                @elems.push.apply @elems, set.elems
        else if set instanceof mathJS.ConditionalSet

        else if set instanceof mathJS.EmptySet
            return
        # TODO: how to avoid doubles?
        # see if the set matches any already existing set
        # if @intersects set
        #     # remove duplicates from given set
        #     set = set.without @
        #     @subsets.push set
        # # disjoint sets
        # else
        #     @subsets.push set
        #
        # return @

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


    size: () ->
        # return @elems.length
        return 42
