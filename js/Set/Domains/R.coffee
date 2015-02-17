class mathJS.Sets.R extends _mathJS.AbstractSet

    CLASS = @

    @new: () ->
        return new CLASS()

    constructor: () ->

        # define everything (and make things non-overwritable)
        Object.defineProperties @, {
            # PRIVATE
            # generator function.
            # generally it is a mapper from N -> X that has to be continuous and increasing
            generator:
                value: (n) ->
                    return n
                writable: false
                enumerable: false
                configurable: false
            expression:
                value: (x) ->
                    return x
                writable: false
                enumerable: false
                configurable: false
            # PROPERTIES
            name:
                value: "R"
                writable: false
                enumerable: true
                configurable: false
            isDomain:
                value: true
                enumerable: true
                writable: false
                configurable: false
            isCountable:
                value: true
                enumerable: true
                writable: false
                configurable: false
            # size:
            #     value: Infinity
            #     enumerable: true
            #     writable: false
                configurable: false
            isMutable:
                value: false
                writable: false
                enumerable: false
                configurable: false
            leftBoundary:
                value:
                    value: -Infinity
                    open: true # implicit but listed here for clarity
                writable: false
                enumerable: false
                configurable: false
            rightBoundary:
                value:
                    value: +Infinity
                    open: true # implicit but listed here for clarity
                writable: false
                enumerable: false
                configurable: false
        }


    #################################################################################
    # STATIC


    #################################################################################
    # PUBLIC
    contains: (x) ->
        return new mathJS.Number(x).equals(x)

    clone: @new

    equals: (set, n = mathJS.settings.set.maxIterations * 10) ->
        # TODO
        # what about {x | x in R and x >= 0 and floor(x) = x} ?? should become true but how?!
        # try n steps and see if values equal. if so assume the sets equal as well
        if @_isSet set
            if set.size is Infinity
                generator = @generator
                i = 0
                while i++ < n
                    # TODO: write intervall class that extends conditionalSet and sets implicit generators
                    val = generator(i)
                    if not set.contains val
                        return false
                    if DEBUG
                        console.log "japp"
                return true
            # set is finite => cant be equal
            return false
        # set has no generator => no infinite set => is finite => cant be equal
        return false

    ###*
    * This method checks if `this` is a subset of the given set `set`. Since equality must be checked by checking an arbitrary number of values this method actually does the same as `this.equals()`. For `this.equals()` the number of compared elements is 10x bigger.
    *###
    isSubsetOf: (set, n = mathJS.settings.set.maxIterations) ->
        return @equals(set, n * 10)

    isSupersetOf: (set) ->
        if @_isSet set
            return set.isSubsetOf @
        return false

    union: (set) ->
        # TODO !!
        return @

    intersection: (set) ->
        # TODO !!
        return set

    intersects: (set) ->
        return @intersection(set).size > 0

    disjoint: (set) ->
        return @intersection(set).size is 0

    complement: () ->
        if @universe?
            return @universe.without @
        return new mathJS.EmptySet()
    ###*
    * a.without b => returns: removed all common elements from a
    *###
    without: (set) ->

    cartesianProduct: (set) ->
        # size becomes the bigger one

    times: @::cartesianProduct

    # inherited
    # isEmpty: () ->
    #     return @size is 0



# MAKE MATHJS.DOMAINS.N AN INSTANCE
do () ->
    # mathJS.Domains.N = new mathJS.Sets.N()
    Object.defineProperties mathJS.Domains, {
        R:
            value: new mathJS.Sets.R()
            writable: false
            enumerable: true
            configurable: false
    }
