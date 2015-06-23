# TODO: mathJS.Number should also somehow be a mathJS.Expression!!!
###*
 * @abstract
 * @class Number
 * @constructor
 * @param {Number} value
 * @extends Object
*###
# TODO: make number extend expression
# class mathJS.Number extends mixOf mathJS.Orderable, mathJS.Poolable, mathJS.Parseable
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

    # ###*
    # * @Override mathJS.Poolable
    # * @static
    # * @method _fromPool
    # *###
    # @_fromPool: (val) ->
    #     if @_pool.length > 0
    #         if @valueIsValid val
    #             number = @_pool.pop()
    #             number.value = val.value or val
    #             return number
    #         return null
    #     else
    #         # param check is done in constructor
    #         return new @(val)

    # ###*
    # * @Override mathJS.Parseable
    # * @static
    # * @method parse
    # *###
    # @parse: (str) ->
    #     if mathJS.isNum(parsed = parseFloat(str))
    #         return @_fromPool parsed
    #     return parsed

    # @random: (max, min) ->
    #     return @_fromPool mathJS.randNum(max, min)

    # @toNumber: (n) ->
    #     if n instanceof mathJS.Number
    #         return n
    #     return new mathJS.Number(n)

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
                undefined
                value
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
