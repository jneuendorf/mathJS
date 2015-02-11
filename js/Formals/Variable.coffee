###*
* @class Variable
* @constructor
* @param {String} name
* This is name name of the variable (mathematically)
* @param {mathJS.Set} type
*###
# TODO: make interfaces meta: eg. have a Variable@Evaluable.coffee file that contains the interface and inset on build
# class mathJS.Variable extends mathJS.Evaluable
class mathJS.Variable extends mathJS.Expression

    constructor: (name, elementOf=mathJS.Domains.N) ->
        @name = name
        @elementOf = elementOf

    equals: (variable) ->
        return @name is variable.name and @elementOf.equals variable.elementOf

    plus: (n) ->
        return new mathJS.Expression("+", @, n)

    minus: (n) ->
        return new mathJS.Expression("-", @, n)

    times: (n) ->
        return new mathJS.Expression("*", @, n)

    divide: (n) ->
        return new mathJS.Expression("/", @, n)

    eval: (values) ->
        if values? and (val = values[@name])?
            if @elementOf.equals val
                console.warn "Given value '#{val}' doesn't match variable elementOf '#{@elementOf.name}'."
            return val
        return @
