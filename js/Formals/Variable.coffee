###*
* @class Variable
* @constructor
* @param {String} symbol
* This is name name of the variable (mathematically)
* @param {Function|Class} type
* @param {Object} value
* Optional. This param is passed upon evaluation.
*###
class mathJS.Variable

    constructor: (symbol, type=mathJS.Number, value) ->
        @symbol = symbol
        @type = type
        @value = value

    plus: (x) ->
        return @value.plus?(x) or null

    minus: (x) ->
        return @value.minus?(x) or null

    times: (x) ->
        return @value.times?(x) or null

    divide: (x) ->
        return @value.divide?(x) or null
