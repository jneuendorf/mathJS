# from http://rosettacode.org/wiki/Parsing/Shunting-yard_algorithm
class mathJS.Algorithms.ShuntingYard

    CLASS = @

    @specialOperators =
        # unary plus/minus
        "+" : "#"
        "-" : "_"

    @init = () ->
        @specialOperations =
            "#": mathJS.Operations.neutralPlus
            "_": mathJS.Operations.negate


    constructor: (settings) ->
        @ops = ""
        @precedence = {}
        @associativity = {}

        for op, opSettings of settings
            @ops += op
            @precedence[op] = opSettings.precedence
            @associativity[op] = opSettings.associativity

    isOperand = (token) ->
        return mathJS.isNum(token)

    toPostfix: (str) ->
        # remove spaces
        str = str.replace /\s+/g, ""
        # make implicit multiplication explicit (3x=> 3*x, xy => x*y)
        # TODO: what if a variable/function has more than 1 character: 3*abs(-3)
        str = str.replace /(\d+|\w)(\w)/g,"$1*$2"

        stack = []
        ops = @ops
        precedence = @precedence
        associativity = @associativity
        postfix = ""
        # set string property to indicate format
        postfix.postfix = true

        for token, i in str
            # if token is an operator
            if token in ops
                o1 = token
                o2 = stack.last()

                # handle unary plus/minus => just add special char
                if i is 0 or prevToken is "("
                    if CLASS.specialOperators[token]?
                        postfix += "#{CLASS.specialOperators[token]} "
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
            # token is an operand or a variable
            else
                postfix += "#{token} "

            prevToken = token

            # console.log token, stack

        while stack.length > 0
          postfix += "#{stack.pop()} "

        return postfix.trim()

    toExpression: (str) ->
        if not str.postfix?
            postfix = @toPostfix(str)
        else
            postfix = str

        postfix = postfix.split " "

        # gather all operators
        ops = @ops
        for k, v of CLASS.specialOperators
            ops += v

        i = 0

        # while expression tree is not complete
        while postfix.length > 1
            token = postfix[i]
            idxOffset = 0

            if token in ops
                if (op = mathJS.Operations[token])
                    startIdx = i - op.arity
                    endIdx = i
                else if (op = CLASS.specialOperations[token])
                    startIdx = i + 1
                    endIdx = i + op.arity + 1
                    idxOffset = -1

                params = postfix.slice(startIdx, endIdx)

                startIdx += idxOffset

                # # convert parameter strings to mathJS objects
                for param, j in params when typeof param is "string"
                    if isOperand(param)
                        params[j] = new mathJS.Expression(parseFloat(param))
                    else
                        params[j] = new mathJS.Variable(param)

                # create expression from parameters
                exp = new mathJS.Expression(op, params...)
                # this expression replaces the operation and its parameters
                postfix.splice(startIdx, params.length + 1, exp)

                # reset i to the first replaced element index -> increase in next iteration -> new element
                i = startIdx + 1

            # constants
            else if isOperand(token)
                postfix[i++] = new mathJS.Expression(parseFloat(token))
            # variables
            else
                postfix[i++] = new mathJS.Variable(token)

        return postfix.first
