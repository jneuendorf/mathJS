window.mixOf = (base, mixins...) ->
    class Mixed extends base

    # earlier mixins override later ones
    for mixin in mixins by -1
        # static
        for name, method of mixin
            Mixed[name] = method
        # non-static
        for name, method of mixin.prototype
            Mixed::[name] = method


    # attach 'instanceof' equivalent method
    superClasses = Array::slice.call(arguments, 0)
    Mixed::instanceof = (cls) ->
        # real inheritance => normal check
        if @ instanceof cls
            return true
        # check mixed in classes
        for c in superClasses when c is cls
                return true

        return false

    return Mixed
