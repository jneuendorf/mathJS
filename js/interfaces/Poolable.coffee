class _mathJS.Poolable extends _mathJS.Interface

    @_pool = []

    @_fromPool: () ->
        # implementation should be something like:
        # if @_pool.length > 0
        #     return @_pool.pop()
        # return new @()
        throw new mathJS.Errors.NotImplementedError("static _fromPool in #{@name}")

    ###*
    * Releases the instance to the pool of its class.
    * @method release
    * @return This intance
    * @chainable
    *###
    release: () ->
        if @constructor._pool.length < mathJS.settings.maxPoolSize
            @constructor._pool.push @
        if DEBUG
            if @constructor._pool.length >= mathJS.settings.maxPoolSize
                console.warn "#{@constructor.name}-pool is full:", @constructor._pool
        return @
