###*
* @class Variable
* @constructor
* @param {String} name
* This is name name of the variable (mathematically)
* @param {Function|Class} type
* @param {Object} value
* Optional. This param is passed upon evaluation.
*###
# TODO: make interfaces meta: eg. have a Variable@Evaluable.coffee file that contains the interface and inset on build
class mathJS.Variable extends mathJS.Evaluable

    constructor: (name, type=mathJS.Number) ->
        @name = name
        @type = type

    plus: (n) ->
        return new mathJS.Expression("+", @, n)

    eval: (values) ->
        if values? and (val = values[@name])?
            if val not instanceof @type
                console.warn "Given value '#{val}' doesn't match variable type '#{@type.name}'."
            return val

        return @
