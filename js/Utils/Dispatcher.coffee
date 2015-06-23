class mathJS.Utils.Dispatcher extends _mathJS.Object

    # map: receiver -> list of dispatchers
    @registeredDispatchers = mathJS.Utils.Hash.new()

    # try to detect cyclic dispatching
    @registerDispatcher: (newReceiver, newTargets) ->
        registrationPossible = newTargets.indexOf(newReceiver) is -1

        if registrationPossible
            regReceivers = @registeredDispatchers.keys
            # IF
            # 1. the new receiver is in any of the lists and
            # 2. any of the registered receivers is in the new-targets list
            # THEN a cycle would be created
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
    # NOTE: super classes are ignored
    constructor: (receiver, targets=[]) ->
        @constructor.registerDispatcher(receiver, targets)

        @receiver = receiver
        @targets = targets

        console.log "dispatcher created!"



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
            )

        return null
