###*
* This is the super class of all mathJS classes.
* Therefore all cross-class things are defined here.
* @class Object
*###
class _mathJS.Object

    @_implements    = []
    @_implementedBy = []

    @implements = (classes...) ->
        if classes.first instanceof Array
            classes = classes.first

        for clss in classes
            # make the class / interface know what classes implement it
            if @ not in clss._implementedBy
                clss._implementedBy.push @

            # implement class / interface
            clssPrototype = clss.prototype
            # "window." necessary because coffee creates an "Object" variable for this class
            prototypeKeys = window.Object.keys(clssPrototype)
            # static
            for name, method of clss when name not in prototypeKeys
                @[name] = method
            # non-static (from prototype)
            for name, method of clssPrototype
                @::[name] = method
            @_implements.push clss

        return @

    isA: (clss) ->
        if not clss? or clss not instanceof Function
            return false

        if @ instanceof clss
            return true

        for c in @constructor._implements
            # direct hit
            if c is clss
                return true

            # check super classes ("__superClass__" is set when coffee extends classes using macros...see macros.js)
            while (c = c.__superClass__)?
                if c is clss
                    return true

        return false

    instanceof: () ->
        return @isA.apply(@, arguments)
