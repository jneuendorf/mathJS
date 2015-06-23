class mathJS.Utils.Dispatcher extends _mathJS.Object

    @registeredDispatchers = mathJS.Utils.Hash.new()

    # try to detect cyclic dispatching
    @registerDispatcher: (newReceiver, newTargets) ->
        registrationPossible = true

        regReceivers = @registeredDispatchers.keys
        @registeredDispatchers.each (regReceiver, regTargets, idx) ->
            for regTarget in regTargets when regTarget is newReceiver
                for newTarget in newTargets when regReceivers.indexOf(newTarget)
                    registrationPossible = false
                    return false
            return true

        if registrationPossible
            @registeredDispatchers.put(newReceiver, newTargets)
            return @

        throw new mathJS.Errors.CycleDetectedError("Can't register '#{newReceiver}' for dispatching - cycle detected!")

    # CONSTRUCTOR
    constructor: (receiver, targets=[]) ->
        @constructor.registerDispatcher(receiver, targets)

        @receiver = receiver
        @targets = targets

    # needsDispatching: (target) ->
    #     return (target.constructor or target) in @targets

    dispatch: (target, method, params...) ->
        dispatch = false
        # check instanceof and identity
        if @targets.indexOf(target.constructor or target) >= 0
            dispatch = true
        # check typeof (for primitives)
        else
            for t in @targets when typeof target is t
                dispatch = true
                break

        if dispatch
            if target[method] instanceof Function
                return target[method].apply(target, params)
            throw new mathJS.Errors.NotImplementedError(
                "Can't call '#{method}' on target '#{target}'"
                "Dispatcher.coffee"
                undefined
                target
            )

        return null
