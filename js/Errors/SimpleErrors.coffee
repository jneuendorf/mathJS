# class _mathJS.Errors.Error extends window.Error
#
#     constructor: (message, fileName, lineNumber, misc...) ->
#         super(message, fileName, lineNumber)
#         @misc = misc
#
#     toString: () ->
#         return "#{super()}\n more data: #{@misc.toString()}"


class mathJS.Errors.CalculationExceedanceError extends Error

class mathJS.Errors.CycleDetectedError extends Error

class mathJS.Errors.DivisionByZeroError extends Error

class mathJS.Errors.InvalidArityError extends Error

class mathJS.Errors.InvalidParametersError extends Error

class mathJS.Errors.InvalidVariableError extends Error

class mathJS.Errors.NotImplementedError extends Error

class mathJS.Errors.NotParseableError extends Error
