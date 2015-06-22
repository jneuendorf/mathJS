###*
* Domain ranks are like so:
* N -> 0
* Z -> 1
* Q -> 2
* I -> 2
* R -> 3
* C -> 4
* ==> union: take greater rank (if equal (and unequal names) take next greater rank)
* ==> intersection: take smaller rank (if equal (and unequal names) take empty set)
*###
class _mathJS.Sets.Domain extends _mathJS.AbstractSet

    CLASS = @

    @new: () ->
        return new CLASS()

    @_byRank: (rank) ->
        for name, domain of mathJS.Domains when domain.rank is rank
            return domain
        return null

    constructor: (name, rank, isCountable) ->
        @isDomain   = true
        @name       = name
        @rank       = rank
        @isCountable = isCountable

    clone: () ->
        return @constructor.new()

    size: () ->
        return Infinity

    equals: (set) ->
        return set instanceof @constructor

    intersection: (set) ->
        if set.isDomain
            if @name is set.name
                return @
            if @rank < set.rank
                return @
            if @rank > set.rank
                return set
            return new mathJS.Set()
        # TODO !!
        return false

    union: (set) ->
        if set.isDomain
            if @name is set.name
                return @
            if @rank > set.rank
                return @
            if @rank < set.rank
                return set
            return CLASS._byRank(@rank + 1)
        # TODO !!
        return false

    @_makeAliases()
