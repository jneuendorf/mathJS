class _mathJS.Parseable extends _mathJS.Interface

    @parse: (str) ->
        throw new mathJS.Errors.NotImplementedError("static parse in #{@name}")

    toString: (args) ->
        throw new mathJS.Errors.NotImplementedError("toString in #{@contructor.name}")
