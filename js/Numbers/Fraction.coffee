class mathJS.Fraction extends mathJS.Number

    constructor: (enumerator, denominator) ->
        @enumerator = enumerator
        @denominator = denominator
        Object.defineProperty @, "value", {
            # writable: false
            get: () ->
                return @enumerator / @denominator
        }
