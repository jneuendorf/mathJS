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

    # TODO: change this to mathJS.Domains.R when R is implemented
    constructor: (name, elementOf=mathJS.Domains.N) ->
        @name = name
        if elementOf.getSet?
            @elementOf = elementOf.getSet()
        else
            @elementOf = elementOf


    getSet: () ->
        return @elementOf

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
            if @elementOf.contains val
                return val
            console.warn "Given value '#{val}' is not in the set '#{@elementOf.name}'."
        return @
