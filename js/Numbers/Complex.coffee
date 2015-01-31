###*
 * @abstract
 * @class Complex
 * @constructor
 * @param {Number} real
 * Real part of the number. Either a mathJS.Number or primitive number.
 * @param {Number} image
 * Real part of the number. Either a mathJS.Number or primitive number.
 * @extends Number
*###
# TODO: maybe extend mathJS.Vector instead?! or mix 'em
class mathJS.Complex extends mathJS.Number

    PARSE_KEY = "0c"

    ###########################################################################
    # STATIC

    # ###*
    # * @Override
    # *###
    # @_valueIsValid: (value) ->
    #     return value instanceof mathJS.Number or mathJS.isNum(value)

    ###*
    * @Override
    * This method creates an object with the keys 'real' and 'img' which have primitive numbers as their values.
    * @static
    * @method _getValueFromParam
    * @param {Complex|Number} real
    * @param {Number} img
    * @return {Object}
    *###
    @_getValueFromParam: (real, img) ->
        if real instanceof mathJS.Complex
            return {
                real: real.real
                img: real.img
            }

        if real instanceof mathJS.Number and img instanceof mathJS.Number
            return {
                real: real.value
                img: img.value
            }

        if mathJS.isNum(real) and mathJS.isNum(img)
            return {
                real: real
                img: img
            }

        return null


    @fromPool: (real, img) ->
        if @_pool.length > 0
            if @_valueIsValid(real) and @_valueIsValid(img)
                number = @_pool.pop()
                number.real = real
                number.img = img
                return number
            return null
        else
            return new @(real, img)

    @parse: (str) ->
        idx = str.toLowerCase().indexOf(PARSE_KEY)
        if idx >= 0
            parts = str.substring(idx + PARSE_KEY.length).split ","
            if mathJS.isNum(real = parseFloat(parts[0])) and mathJS.isNum(img = parseFloat(parts[1]))
                return @fromPool real, img

        return NaN

    @random: (max1, min1, max2, min2) ->
        return @fromPool mathJS.randNum(max1, min1), mathJS.randNum(max2, min2)


    ###########################################################################
    # CONSTRUCTOR
    constructor: (real, img) ->
        values = @_getValueFromParam(real, img)

        if not values?
            fStr = arguments.callee.caller.toString()
            throw new Error("mathJS: Expected 2 numbers or a complex number! Given (#{real}, #{img}) in '#{fStr.substring(0, fStr.indexOf(")") + 1)}'")

        Object.defineProperties @, {
            real:
                get: @_getReal
                set: @_setReal
            img:
                get: @_getImg
                set: @_setImg
            fromPool:
                value: @constructor.fromPool.bind(@constructor)
                writable: false
                enumarable: false
                configurable: false
        }

        @real = values.real
        @img = values.img

    ###########################################################################
    # PRIVATE METHODS

    ###########################################################################
    # PROTECTED METHODS
    _setReal: (value) ->
        if @_valueIsValid(value)
            @_real = value.value or value.real or value
        return @

    _getReal: () ->
        return @_real

    _setImg: (value) ->
        if @_valueIsValid(value)
            @_img = value.value or value.img or value
        return @

    _getImg: () ->
        return @_img

    _getValueFromParam: @_getValueFromParam


    ###########################################################################
    # PUBLIC METHODS

    ###*
    * This method check for mathmatical equality. This means new mathJS.Double(4.2).equals(4.2)
    * @method equals
    * @param {Number} n
    * @return {Boolean}
    *###
    equals: (r, i) ->
        values = @_getValueFromParam(r, i)
        if values?
            return @real is values.real and @img is values.img
        return false

    plus: (r, i) ->
        values = @_getValueFromParam(r, i)
        if values?
            return @fromPool(@real + values.real, @img + values.img)
        return NaN

    increase: (r, i) ->
        values = @_getValueFromParam(r, i)
        if values?
            @real += values.real
            @img += values.img
        return @

    plusSelf: @increase

    minus: (n) ->
        values = @_getValueFromParam(r, i)
        if values?
            return @fromPool(@real - values.real, @img - values.img)
        return NaN

    decrease: (n) ->
        values = @_getValueFromParam(r, i)
        if values?
            @real -= values.real
            @img -= values.img
        return @

    minusSelf: @decrease

    # TODO: adjust last functions for complex numbers
    times: (r, i) ->
        # return @fromPool(@value * _getValueFromParam(n))
        values = @_getValueFromParam(r, i)
        if values?
            return @fromPool(@real * values.real, @img * values.img)
        return NaN

    timesSelf: (n) ->
        @value *= _getValueFromParam(n)
        return @

    divide: (n) ->
        return @fromPool(@value / _getValueFromParam(n))

    divideSelf: (n) ->
        @value /= _getValueFromParam(n)
        return @

    square: () ->
        return @fromPool(@value * @value)

    squareSelf: () ->
        @value *= @value
        return @

    cube: () ->
        return @fromPool(@value * @value * @value)

    squareSelf: () ->
        @value *= @value * @value
        return @

    sqrt: () ->
        return @fromPool(mathJS.sqrt @value)

    sqrtSelf: () ->
        @value = mathJS.sqrt @value
        return @

    pow: (n) ->
        return @fromPool(mathJS.pow @value, _getValueFromParam(n))

    powSelf: (n) ->
        @value = mathJS.pow @value, _getValueFromParam(n)
        return @

    sign: () ->
        return mathJS.sign @value

    toInt: () ->
        return mathJS.Int.fromPool mathJS.floor(@value)

    toDouble: () ->
        return mathJS.Double.fromPool @value

    toString: () ->
        return "#{PARSE_KEY}#{@real.toString()},#{@img.toString()}"

    clone: () ->
        return @fromPool(@value)

    # add instance to pool
    release: () ->
        @constructor._pool.push @
        return @constructor
