class mathJS.Poolable

    @_pool = []

    @fromPool: () ->
        # implementation should be something like:
        # if @_pool.length > 0
        #     return @_pool.pop()
        # return new @()
        throw new Error("To be implemented")

    @new: () ->
        if arguments.length > 0
            return @fromPool.apply(@, arguments)
        return @fromPool()

    # release instance to pool
    release: () ->
        @constructor._pool.push @
        return @constructor
