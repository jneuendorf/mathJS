# from http://rosettacode.org/wiki/Parsing/Shunting-yard_algorithm
# mathJS.Algorithms.ShuntingYard = (str, options) ->
#     # remove spaces, so str[i]!=" "
#     str = str.replace /\s+/g, ""
#
#     # s = new Stack()
#     s = []
#     ops = "-+/*^"
#     precedence =
#         "^": 4
#         "*": 3
#         "/": 3
#         "+": 2
#         "-": 2
#     associativity =
#         "^": "right"
#         "*": "left"
#         "/": "left"
#         "+": "left"
#         "-": "left"
#     postfix = ""
#
#     for token, i in str
#         # if token is operand (here limited to 0 <= x <= 9)
#         if token > "0" and token < "9"
#             postfix += "#{token} "
#         # if token is an operator
#         else if token in ops
#             o1 = token
#             o2 = s.last()
#
#             # while operator token, o2, on top of the stack
#             # and o1 is left-associative and its precedence is less than or equal to that of o2
#             # (the algorithm on wikipedia says: or o1 precedence < o2 precedence, but I think it should be)
#             # or o1 is right-associative and its precedence is less than that of o2
#             while o2 in ops and (associativity[o1] is "left" and precedence[o1] <= precedence[o2]) or (associativity[o1] is "right" and precedence[o1] < precedence[o2])
#                 # add o2 to output queue
#                 postfix += "#{o2} "
#                 # pop o2 of the stack
#                 s.pop()
#                 # next round
#                 o2 = s.last()
#             # push o1 onto the stack
#             s.push(o1)
#         # if token is left parenthesis
#         else if token is "("
#             # then push it onto the stack
#             s.push(token)
#         # if token is right parenthesis
#         else if token is ")"
#             # until token at top is (
#             while s.last() isnt "("
#                 postfix += "#{s.pop()} "
#             # pop (, but not onto the output queue
#             s.pop()
#
#     # while s.length() > 0
#     while s.length > 0
#       postfix += "#{s.pop()} "
#
#     return postfix

class mathJS.Algorithms.ShuntingYard

    constructor: (settings) ->
        @ops = ""
        @precedence = {}
        @associativity = {}

        for op, opSettings of settings
            @ops += op
            @precedence[op] = opSettings.precedence
            @associativity[op] = opSettings.associativity

    parse: (str) ->
        # remove spaces
        str = str.replace /\s+/g, ""

        s = []
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
                o2 = s.last()

                # while operator token, o2, on top of the stack
                # and o1 is left-associative and its precedence is less than or equal to that of o2
                # (the algorithm on wikipedia says: or o1 precedence < o2 precedence, but I think it should be)
                # or o1 is right-associative and its precedence is less than that of o2
                while o2 in ops and (associativity[o1] is "left" and precedence[o1] <= precedence[o2]) or (associativity[o1] is "right" and precedence[o1] < precedence[o2])
                    # add o2 to output queue
                    postfix += "#{o2} "
                    # pop o2 of the stack
                    s.pop()
                    # next round
                    o2 = s.last()
                # push o1 onto the stack
                s.push(o1)
            # if token is left parenthesis
            else if token is "("
                # then push it onto the stack
                s.push(token)
            # if token is right parenthesis
            else if token is ")"
                # until token at top is (
                while s.last() isnt "("
                    postfix += "#{s.pop()} "
                # pop (, but not onto the output queue
                s.pop()

        # while s.length() > 0
        while s.length > 0
          postfix += "#{s.pop()} "

        return postfix
