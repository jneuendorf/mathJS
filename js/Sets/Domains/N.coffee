class mathJS.Sets.N extends _mathJS.Sets.Domain

    CLASS = @

    @new: () ->
        return new CLASS()

    constructor: () ->
        super("N", 0, true)


    #################################################################################
    # STATIC


    #################################################################################
    # PUBLIC
    contains: (x) ->
        return mathJS.isInt(x) or new mathJS.Int(x).equals(x)

    ###*
    * This method checks if `this` is a subset of the given set `set`. Since equality must be checked by checking an arbitrary number of values this method actually does the same as `this.equals()`. For `this.equals()` the number of compared elements is 10x bigger.
    *###
    isSubsetOf: (set, n = mathJS.settings.set.maxIterations) ->
        return @equals(set, n * 10)

    isSupersetOf: (set) ->
        if @_isSet set
            return set.isSubsetOf @
        return false

    union: (set, n = mathJS.settings.set.maxIterations, matches = mathJS.settings.set.maxMatches) ->
        # AND both checker functions
        checker = (elem) ->
            return self.checker(elem) or set.checker(elem)

        generator = () ->

        # TODO: how to avoid doubles? implementations that use boolean arrays => XOR operations on elements
        # discrete set
        if set instanceof mathJS.DiscreteSet or set.instanceof?(mathJS.DiscreteSet)

        # non-discrete set (empty or conditional set, or domain)
        else if set instanceof mathJS.Set or set.instanceof?(mathJS.Set)
            # check for domains. if set is a domain this or the set can directly be returned because they are immutable
            # N
            if mathJS.instanceof(set, mathJS.Set.N)
                return @
            # Q, R # TODO: other domains like I, C
            if mathJS.instanceof(set, mathJS.Domains.Q) or mathJS.instanceof(set, mathJS.Domains.R)
                return set


            self = @



        # param was no set
        return null

    intersect: (set) ->
        # AND both checker functions
        checker = (elem) ->
            return self.checker(elem) and set.checker(elem)

        # if the f2-invert of the y-value of f1 lies within f2" domain/universe both ranges include that value
        # or vice versa
        # we know this generator function has N as domain (and as range of course)
        # we even know the set"s generator function also has N as domain as we assume that (because the mapping is always a bijection from N -> X)
        # so we can only check a single value at a time so we have to have to boundaries for the number of iterations and the number of matches
        # after x matches we try to find a series that produces those matches (otherwise a discrete set will be created)
        commonElements = []
        x = 0 # current iteration = current x value
        m = 0 # current matches
        f1 = @generator
        f2 = set.generator
        f1Elems = [] # in ascending order because generators are increasing
        f2Elems = [] # in ascending order because generators are increasing

        while x < n and m < matches
            y1 = f1(x) # TODO: maybe inline generator function here?? but that would mean every sub class has to overwrite
            y2 = f2(x)

            # f1 is bigger than f2 at current x => check for y2 in f1Elems
            if mathJS.gt(y1, y2)
                found = false
                for f1Elem, i in f1Elems when mathJS.equals(y2, f1Elem)
                    # new match!
                    m++
                    found = true
                    # y2 found in f1Elems => add to common elements
                    commonElements.push y2
                    # because both functions are increasing dispose of earlier elements
                    # remove all unneeded elements from f1Elems incl. (current) y1
                    f1Elems = f1Elems.slice(i + 1)
                    # y2 was a match (the last in f2Elems) and y1 is bigger than y2 so we can forget everything in f2Elems
                    f2Elems = []
                    # exit loop
                    break

                if not found
                    f1Elems.push y1
                    f2Elems.push y2
            # f2 is bigger than f1 at current x => check for y1 in f2Elems
            else if mathJS.lt(y1, y2)
                found = false
                for f2Elem, i in f2Elems when mathJS.equals(y1, f2Elem)
                    # new match!
                    m++
                    found = true
                    # y1 found in f2Elems => add to common elements
                    commonElements.push y1
                    # because both functions are increasing dispose of earlier elements
                    # remove all unneeded elements from f2Elems incl. (current) y1
                    f2Elems = f2Elems.slice(i + 1)
                    # y1 was a match (the last in f2Elems) and y1 is bigger than y1 so we can forget everything in f1Elems
                    f1Elems = []
                    # exit loop
                    break

                if not found
                    f1Elems.push y1
                    f2Elems.push y2
            # equal
            else
                m++
                commonElements.push y1
                # all previous values are unimportant because in the next iteration the new values will BOTH be greater than y1=y2 and the 2 lists contain only smaller elements than y1=y2 so there can"t be a match with the next elements
                f1Elems = []
                f2Elems = []
            # increment
            x++

        console.log "x=#{x}", "m=#{m}", commonElements

        # try to find formular from series (supported is: +,-,*,/)
        ops = []
        for elem in commonElements
            true


        # example: c1 = x^2, c2 = 2x+1
        # c1: 0, 1, 4, 9, 16, 25, 36, 49, 64, 81...
        # c2: 1, 3, 5, 7, 9, 11, 13, 15, 17, ...
        # => 1, 9, 25, 49, 81, 121, 169, 225, 289, 361, 441, 529, 625, 729, 841, 961, 1089, 1225, 1369, 1521, 1681, 1849
        # this is all odd squares (all odd numbers squared!) ==> f(x) = (2x + 1)^2
        # ==> slower increasing function = f, faster increasing function = g -> new-f(x) = g(f(x)) = (g o f)(x)
        # actually it is the "bigger function" with a constraint

        # inserting smaller in bigger works also for 2x, 3x
        # what about 2x, 3x+1 -> 3(2x) + 1 = 6x+1
        # but 2x, 2x => 2(2x) = 4x wrong!

        # series like   *2, +1, *3, -1, *4, +1,  *5,  -1,  *6,  +1, ...
        # would create 1, 2,  3,  9,  8, 32, 33, 165, 164, 984, 985
        # indices:     0  1   2   3   4   5   6    7    8    9   10
        # f would be y = x^2 + (-1)^x
        return

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
        N:
            value: new mathJS.Sets.N()
            writable: false
            enumerable: true
            configurable: false
    }
