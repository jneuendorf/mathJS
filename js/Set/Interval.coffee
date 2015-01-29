###*
*
* @class Interval
* @constructor
* @param {Number} leftBoundary
* @param {String} leftKind
* Either "open" or "bounded" (case insensitive).
* @param {Number} rightBoundary
* @param {String} rightKind
* Either "open" or "bounded" (case insensitive).
* @param {Set} set
* @extends Set
*###
class mathJS.Interval extends mathJS.ConditionalSet

    ###########################################################################
    # STATIC
    @_valueIsValid: (value) ->
        return (value instanceof mathJS.Number and value not instanceof mathJS.Complex) or mathJS.isNum(value)

    @_kindIsValid: (kind) ->
        return kind.toLowerCase() in ["open", "bounded"]

    ###########################################################################
    # CONSTRUCTOR
    constructor: (leftBoundary, leftKind, rightBoundary, rightKind, set) ->
        if @_valueIsValid(leftBoundary) and @_valueIsValid(rightBoundary) and @_kindIsValid(leftKind) and @_kindIsValid(rightKind)
            @leftBoundary   = leftBoundary.value or leftBoundary
            @leftKind       = leftKind
            @rightBoundary  = rightBoundary.value or rightBoundary
            @rightKind      = rightKind
        else
            fStr = arguments.callee.caller.toString()
            throw new Error("mathJS: Expected (number, string, number, string) number! Given (#{leftBoundary}, #{leftKind}, #{rightBoundary}, #{rightKind}) in '#{fStr.substring(0, fStr.indexOf(")") + 1)}'")

    ###########################################################################
    # PROTECTED METHODS
    _valueIsValid = @_valueIsValid

    _kindIsValid = @_kindIsValid

    ###########################################################################
    # PUBLIC METHODS
    shiftRight: (value) ->
        if @_valueIsValid(value)
            v = value.value or value
            @leftBoundary += v
            @rightBoundary += v
        return @

    shiftLeft: (value) ->
        if @_valueIsValid(value)
            v = value.value or value
            @leftBoundary -= v
            @rightBoundary -= v
        return @

    setLeftBoundary: (value, kind) ->
        if @_valueIsValid(value) and @_kindIsValid(kind)
            @leftBoundary = value.value or value
            @leftKind = kind
        return @

    seRightBoundary: (value, kind) ->
        if @_valueIsValid(value) and @_kindIsValid(kind)
            @rightBoundary = value.value or value
            @rightKind = kind
        return @
