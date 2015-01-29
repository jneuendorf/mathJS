###*
* Tree structure of terms
* @class Term

*###
class mathJS.Term

    fromString: (str) ->
        # TODO: parse string
        return new mathJS.Term()

    constructor: () ->
        l = arguments.length
        # given parameters are an odd number of terms and an even number of operations (in between the terms)
        if l >= 3 and l % 2 is 1
            # gather terms
            terms = []
            for arg in arguments by 2
                terms.push arg
            @terms = terms
            # gather operations
            operations = []
            for i in [1...l] when i % 2 is 1
                operations.push arguments[i]
            @operations = operations

        # just one param => assume 'this' term is a leaf in the tree
        else if l is 1
            @terms = [arguments[0]]
            # else
            #     @terms = []



    eval: (values) ->
        # go through terms and operations and check for precedence and associativity
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
        for term in @terms
            true


        # (2x+1)^2 - (8x+4)*4
        # tree:
        #             minus
        #     (2x+1)^2     (8x+4)*4
        #       pow            times
        #  2x+1      2    8x+4       4
        #  plus    none   plus      none
        # 2x   1     .   8x   4      .
