# from http://rosettacode.org/wiki/Parsing/Shunting-yard_algorithm
class mathJS.Algorithms.ShuntingYard

    CLASS = @

    @specialOperators =
        # unary plus/minus
        "+" : "#"
        "-" : "_"

    constructor: (settings) ->
        @ops = ""
        @precedence = {}
        @associativity = {}

        for op, opSettings of settings
            @ops += op
            @precedence[op] = opSettings.precedence
            @associativity[op] = opSettings.associativity

    toPostfix: (str) ->
        # remove spaces
        str = str.replace /\s+/g, ""

        stack = []
        ops = @ops
        precedence = @precedence
        associativity = @associativity
        postfix = ""

        for token, i in str
            # if token is operand (here limited to 0 <= x <= 9)
            if token > "0" and token < "9"
                postfix += "#{token} "
            # if token is an operator
            else if token in ops
                o1 = token
                o2 = stack.last()

                # handle unary plus/minus => just add special char
                if i is 0 or prevToken is "("
                    if CLASS.specialOperators[token]?
                        postfix += "#{CLASS.specialOperators[token]} "
                    # if token is "-"
                    #     postfix += "_ "
                    # else if token is "+"
                    #     postfix += "# "
                else
                    # while operator token, o2, on top of the stack
                    # and o1 is left-associative and its precedence is less than or equal to that of o2
                    # (the algorithm on wikipedia says: or o1 precedence < o2 precedence, but I think it should be)
                    # or o1 is right-associative and its precedence is less than that of o2
                    while o2 in ops and (associativity[o1] is "left" and precedence[o1] <= precedence[o2]) or (associativity[o1] is "right" and precedence[o1] < precedence[o2])
                        # add o2 to output queue
                        postfix += "#{o2} "
                        # pop o2 of the stack
                        stack.pop()
                        # next round
                        o2 = stack.last()
                    # push o1 onto the stack
                    stack.push(o1)
            # if token is left parenthesis
            else if token is "("
                # then push it onto the stack
                stack.push(token)
            # if token is right parenthesis
            else if token is ")"
                # until token at top is (
                while stack.last() isnt "("
                    postfix += "#{stack.pop()} "
                # pop (, but not onto the output queue
                stack.pop()

            prevToken = token

            # console.log token, stack

        while stack.length > 0
          postfix += "#{stack.pop()} "

        return postfix

    toExpression: (str) ->
        postfix = @toPostfix(str)
