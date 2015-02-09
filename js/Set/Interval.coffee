###*
* @class Interval
* @constructor
* @param leftOpen {Boolean}
* @param leftValue {Number|mathJS.Number}
* @param rightValue {Number|mathJS.Number}
* @param rightOpen {Boolean}
* @extends Set
*###
class mathJS.Interval extends mathJS.Set

    ###########################################################################
    # STATIC
    @fromString: (str) ->
        # remove spaces
        str = str.replace /\s+/g, ""
                 .split ","

        left =
            open: str.first[0] is "("
            value: new mathJS.Number(parseInt(str.first.slice(1), 10))
        right =
            open: str.second.last is ")"
            value: new mathJS.Number(parseInt(str.second.slice(0, -1), 10))

        return new mathJS.Interval(left, right)

    # MAKE ALIAS
    @parse: @fromString


    ###########################################################################
    # CONSTRUCTOR
    constructor: (parameters...) ->
        if parameters.length >= 2
            # first parameter has an .open property => assume ctor called from fromString()
            if parameters.first.open?
                @left = parameters.first
                @right = parameters.second
            else
                second = parameters.second
                fourth = parameters.fourth
                @left =
                    open: parameters.first
                    value: (if second instanceof mathJS.Number then second else new mathJS.Number(second))
                @right =
                    open: parameters.third
                    value: (if fourth instanceof mathJS.Number then fourth else new mathJS.Number(fourth))


    ###########################################################################
    # PROTECTED METHODS

    ###########################################################################
    # PUBLIC METHODS
    cartesianProduct: (set) ->

    clone: () ->
        return new mathJS.Interval(
            {
                open: @left.open
                value: @left.value.clone()
            }
            {
                open: @right.open
                value: @right.value.clone()
            }
        )

    contains: (elem) ->
        return @left.value.lessThanOrEqualTo(elem) and @right.value.greaterThanOrEqualTo(elem) 

    equals: (set) ->

    getElements: () ->

    intersection: (set) ->

    isSubsetOf: (set) ->

    size: () ->

    union: (set) ->

    without: (set) ->
