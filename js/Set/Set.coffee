###*
* @class Set
* @constructor
* @param {Function|Class} type
* @param {Set} universe
* Optional. If given, the created Set will be interpreted as a sub set of the universe.
* @param {mixed} elems...
* Optional. This and the following parameters serve as elements for the new Set. They will be in the new Set immediately.
*###
class mathJS.Set extends mathJS.Comparable
    ###########################################################################
    # STATIC

    @disjoint: (set1, set2) ->
        return set1.intersects set2

    ###########################################################################
    # CONSTRUCTOR
    constructor: (type, universe, leftBoundary, rightBoundary, elems...) ->
        if type instanceof mathJS.Comparable
            @type = type
            @universe = universe
            @leftBoundary = leftBoundary
            @rightBoundary = rightBoundary
            if elems.length > 0
                @subsets = [new mathJS.DiscreteSet(type, universe, elems...)]
            else
                @subsets = []
        else
            throw new Error("Wrong (incomparable) type given ('#{type.name}'')! Sets must consist of comparable elements!")

    ###########################################################################
    # PROTECTED METHODS
    _getValueFromParam: (value) ->
        # 'normal' case
        if value instanceof @type
            return value

        # make primitives also valid for numeric sets

        isNum = mathJS.isNum(value)

        # double or number  -> allow any number
        if (@type is mathJS.Double or @type is mathJS.Number) and isNum
            return new @type(value)

        # int -> allow only ints
        if @type is mathJS.Int and isNum and ~~value is value
            return new @type(value)

        return null


    ###########################################################################
    # PUBLIC METHODS
    clone: () ->
        return

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

    addElems: (elems) ->
        set = new mathJS.EmptySet()
        for elem in elems when elem instanceof @type
            set.addElem elem



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
            for subset in @subsets
                if subset.contains elem
                    return true
        return false

    in: @::contains

    union: (set) ->
        # TODO: how to avoid doubles?
        # see if the set matches any already existing set
        if @intersects set
            # remove duplicates from given set
            set = set.without @
            @subsets.push set
        # disjoint sets
        else
            @subsets.push set

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

    size: () ->
        size = @elems.length
        for subset in @subsets
            size += subset.size()
            if size is Infinity
                return size
        return size

    cardinality: @::size

#
#
# ###*
#  * This is an implementation of a dictionary/hash that does not convert its keys into Strings. Keys can therefore actually by anything! :)
#  * @class Configurator
#  * @constructor
# *###
# class App.Hash
#
#     constructor: () ->
#         @keys = []
#         @values = []
#
#     ###*
#      * Creates a new Hash from a given JavaScript object.
#      * @static
#      * @method fromObject
#      * @param object {Object}
#     *###
#     @fromObject: (obj) ->
#         hash = new Hash()
#         for key, val of obj
#             hash.put key, val
#         return hash
#
#     ###*
#      * Adds a new key-value pair or overwrites an existing one.
#      * @private
#      * @method _putObject
#      * @param object {Object}
#      * @return {Hash} This instance.
#      * @chainable
#     *###
#     _putObject = (obj) ->
#         for key, val of obj
#             @put key, val
#         return @
#
#     ###*
#      * Adds a new key-value pair or overwrites an existing one.
#      * @method put
#      * @param key {mixed}
#      * @param val {mixed}
#      * @return {Hash} This instance.
#      * @chainable
#     *###
#     put: (key, val) ->
#         # no value given => assume an object was passed
#         if not val?
#             return _putObject.call(@, key)
#
#         idx = @keys.indexOf key
#         # add new entry
#         if idx < 0
#             @keys.push key
#             @values.push val
#         # overwrite entry
#         else
#             @keys[idx] = key
#             @values[idx] = val
#
#         return @
#
#     ###*
#      * Returns the value (or null) for the specified key.
#      * @method get
#      * @param key {mixed}
#      * @param [equalityFunction] {Function}
#      * This optional function can overwrite the test for equality between keys. This function expects the parameters ('key' and the current key in the key iteration). If this parameters is omitted '===' is used.
#      * @return {mixed}
#     *###
#     get: (key, eqFunc) ->
#         if not eqFunc?
#             idx = @keys.indexOf key
#         else
#             idx = (i for k, i in @keys when eqFunc(key, k) is true)[0]
#
#         if idx >= 0
#             return @values[idx]
#
#         return null
#
#     ###*
#      * Returns a list of all key-value pairs. Each pair is an Array with the 1st element being the key, the 2nd being the value.
#      * @method getAll
#      * @return {Array} Key-value pairs.
#     *###
#     getAll: () ->
#         res = []
#
#         for key, idx in @keys
#             res.push [ key, @values[idx] ]
#
#         return res
#
#     ###*
#      * Indicates whether the Hash has the specified key.
#      * @method hasKey
#      * @param key {mixed}
#      * @return {Boolean}
#     *###
#     hasKey: (key) ->
#         return key in @keys
#
#     ###*
#      * Returns the number of entries in the Hash.
#      * @method size
#      * @return {Integer}
#     *###
#     size: () ->
#         return @keys.length
#
#     ###*
#      * Returns all the keys of the Hash.
#      * @method getKeys()
#      * @return {Array}
#     *###
#     getKeys: () ->
#         return @keys
#
#     ###*
#      * Returns all the values of the Hash.
#      * @method getValues()
#      * @return {Array}
#     *###
#     getValues: () ->
#         return @values
#
#     ###*
#      * Returns a list of keys that have val (or anything equal as specified in 'eqFunc') as value.
#      * @method getKeysForValue
#      * @param val {mixed}
#      * @param [equalityFunction] {Function}
#      * This optional function can overwrite the test for equality between values. This function expects the parameters ('value' and the current value in the value iteration). If this parameters is omitted '===' is used.
#      * @return {mixed}
#     *###
#     getKeysForValue: (value, eqFunc) ->
#         if not eqFunc?
#             idxs = (idx for val, idx in @values when val is value)
#         else
#             idxs = (idx for val, idx in @values when eqFunc(val, value) is true)
#
#         res = []
#         res.push(@keys[idx]) for idx in idxs
#
#         return res
