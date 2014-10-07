class mathJS.EmpytSet extends mathJS.Set


    constructor: () ->

    clone: () ->
        return new mathJS.EmpytSet()

    equals: (set) ->
        return set instanceof mathJS.EmpytSet

    addElem: (elem) ->
        if DEBUG
            console.warn "prototype change!"
        @makeToDiscreteSet()
        return @

    size: () ->
        return 0


    makeToDiscreteSet: () ->
        @.__proto__ = mathJS.DiscreteSet.prototype
        return @

    makeToConditionalSet: () ->
        @.__proto__ = mathJS.ConditionalSet.prototype
        return @
