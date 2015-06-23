# TODO: mathJS.Number should also somehow be a mathJS.Expression!!!
###*
 * @abstract
 * @class Number
 * @constructor
 * @param {Number} value
 * @extends Object
*###
class mathJS.Number extends _mathJS.AbstractNumber

    ###########################################################################################
    # STATIC
    @_getPrimitive: (param, skipCheck) ->
        if skipCheck is true
            return param

        if param instanceof mathJS.Number
            return param.value

        if param instanceof Number
            return param.valueOf()

        if mathJS.isNum(param)
            return param

        return null

    @getSet: () ->
        return mathJS.Domains.R

    # moved to AbstractNumber
    # @new: (value) ->
    #     return @_fromPool value

    ###########################################################################################
    # CONSTRUCTOR
    constructor: (value) ->
        @_value = null

        Object.defineProperties @, {
            value:
                get: @_getValue
                set: @_setValue
        }

        if (val = @_getPrimitive(value))?
            @_value = val
        else
            throw new mathJS.Errors.InvalidParametersError(
                "Can't instatiate number from given '#{value}'"
                "Number.coffee"
            )

    ###########################################################################################
    # PRIVATE METHODS

    ###########################################################################################
    # PROTECTED METHODS

    ###########################################################################################
    # PUBLIC METHODS

    ########################################################
    # IMPLEMENTING COMPARABLE
    # see AbstractNumber
    # END - IMPLEMENTING COMPARABLE

    ########################################################
    # IMPLEMENTING BASIC OPERATIONS
    # see AbstractNumber
    # END - IMPLEMENTING BASIC OPERATIONS

    # EVALUABLE INTERFACE
    eval: (values) ->
        return @

    # TODO: intercept destructor
    # .....

    _getSet: () ->
        return new mathJS.Set(@)

    in: (set) ->
        return set.contains(@)

    valueOf: @::_getValue
