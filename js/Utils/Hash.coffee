###*
 * This is an implementation of a dictionary/hash that does not convert its keys into Strings. Keys can therefore actually by anything!
 * @class Hash
 * @constructor
*###
class mathJS.Utils.Hash

    ###*
     * Creates a new Hash from a given JavaScript object.
     * @static
     * @method fromObject
     * @param object {Object}
    *###
    @fromObject: (obj) ->
        return new mathJS.Utils.Hash(obj)

    @new: (obj) ->
        return new mathJS.Utils.Hash(obj)

    constructor: (obj) ->
        @keys   = []
        @values = []

        if obj?
            @put key, val for key, val of obj

    clone: () ->
        res         = new mathJS.Utils.Hash()
        res.keys    = @keys.clone()
        res.values  = @values.clone()
        return res

    invert: () ->
        res         = new mathJS.Utils.Hash()
        res.keys    = @values.clone()
        res.values  = @keys.clone()
        return res

    ###*
     * Adds a new key-value pair or overwrites an existing one.
     * @method put
     * @param key {mixed}
     * @param val {mixed}
     * @return {Hash} This instance.
     * @chainable
    *###
    put: (key, val) ->
        idx = @keys.indexOf key
        # add new entry
        if idx < 0
            @keys.push key
            @values.push val
        # overwrite entry
        else
            @keys[idx] = key
            @values[idx] = val

        return @

    ###*
     * Returns the value (or null) for the specified key.
     * @method get
     * @param key {mixed}
     * @param [equalityFunction] {Function}
     * This optional function can overwrite the test for equality between keys. This function expects the parameters: (the current key in the key iteration, 'key'). If this parameters is omitted '===' is used.
     * @return {mixed}
    *###
    get: (key) ->
        if (idx = @keys.indexOf(key)) >= 0
            return @values[idx]
        return null

    ###*
     * Indicates whether the Hash has the specified key.
     * @method hasKey
     * @param key {mixed}
     * @return {Boolean}
    *###
    hasKey: (key) ->
        return key in @keys

    has: (key) ->
        return @hasKey(key)

    ###*
     * Returns the number of entries in the Hash.
     * @method size
     * @return {Integer}
    *###
    size: () ->
        return @keys.length

    empty: () ->
        @keys   = []
        @values = []
        return @

    remove: (key) ->
        if (idx = @keys.indexOf(key)) >= 0
            @keys.splice idx, 1
            @values.splice idx, 1
        else
            console.warn "Could not remove key '#{key}'!"
        return @

    each: (callback) ->
        for key, i in @keys when callback(key, @values[i], i) is false
            return @
        return @
