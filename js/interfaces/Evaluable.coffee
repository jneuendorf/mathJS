class _mathJS.Evaluable extends _mathJS.Interface

    'eval': () ->
        throw new mathJS.Errors.NotImplementedError("eval() in #{@contructor.name}")
