class _mathJS.Errors.Error extends Error

    constructor: (message, fileName, lineNumber, misc...) ->
        super(message, fileName, lineNumber)
        @misc = misc

    toString: () ->
        return "#{super()}\n more data: #{@misc.toString()}"




class mathJS.Errors.CalculationExceedanceError extends _mathJS.Errors.Error

class mathJS.Errors.InvalidVariableError extends _mathJS.Errors.Error

class mathJS.Errors.InvalidParametersError extends _mathJS.Errors.Error

class mathJS.Errors.InvalidArityError extends _mathJS.Errors.Error

class mathJS.Errors.NotImplementedError extends _mathJS.Errors.Error
