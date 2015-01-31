###*
* Tree structure of expressions. It consists of 2 term and 1 operation.
* @class Expression

*###
class mathJS.Expression

    fromString: (str) ->
        # TODO: parse string
        return new mathJS.Expression()

    constructor: (term1, operation, term2) ->
        @term1 = term1
        if operation? and term2?
            @operation = operation
            @term2 = term2
            @_isLeaf = false
        else
            @operation = null
            @term2 = null
            @_isLeaf = true





    eval: (values) ->
        # go through expressions and operations and check for precedence and associativity
        ops = @operations.clone()

        # look for highest precedence first
        for precedence in [1...20] # TODO: adjust max value according to defined operations
            for op in @operations
                if op.precedence is precedence
                    term1 = @operations[idx]
                    term2 = @operations[idx + 1]



        for op in ops
            precedence = op.precedence

        ops.sortProp (op) ->
            return op.precedence

        console.log ops

        # in order, depth first
        res = null
        for term in @expressions
            true


        # (2x+1)^2 - (8x+4)*4
        # tree:
        #             minus
        #     (2x+1)^2     (8x+4)*4
        #       pow            times
        #  2x+1      2    8x+4       4
        #  plus    none   plus      none
        # 2x   1     .   8x   4      .
