###*
* This is the super class of all mathJS classes.
* Therefore all cross-class things are defined here.
* @class Object
*###
class _mathJS.Object

    @implements = []

    @implement = (classes...) ->
        if classes.first instanceof Array
            classes = classes.first

        for clss in classes
            clssPrototype = clss::
            prototypeKeys = window.Object.keys(clssPrototype)
            # static
            for name, method of clss when name not in prototypeKeys
                @[name] = method
            # non-static (from prototype)
            for name, method of clssPrototype
                @::[name] = method
            @implements.push clss
        return @

    isA: (clss) ->
        if not clss? or clss not instanceof Function
            return false

        if @ instanceof clss
            return true

        for c in @constructor.implements
            # direct hit
            if c is clss
                return true

            # check super classes
            while (c = c.__superClass__)?
                if c is clss
                    return true

        return false

    instanceof: () ->
        return @isA.apply(@, arguments)
