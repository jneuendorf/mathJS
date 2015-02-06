class mathJS.SetSpec

    # f is mapping (bijection to N)
    constructor: (isFinite, f, f2) ->
        if isFinite is true or isFinite is "true"
            @isFinite = true
            @checker = f
            @generator = f2

        else if isFinite is false or isFinite is "false"
            @checker = f
            if isFinite is true
                @generator = generator
        else
            debugger
            throw new Error("mathJS: Expected (Function, boolean) for SetSpec! Given #{check} and #{isFinite}")

class mathJS.SetBuilder

    constructor: (expression, domain, conditions...) ->
        # try to evaluate conditions??
        


###
{7,3,15,31}
{a,b,c}
{1,2,3,...,100}
{0,1,2,...}

{x : x in R and x = x^2 } or {x | x in R and x = x^2 }
{ (x,y) | 0 < y < f(x) }
{ (t,2t+1) | t in Z }

[a,b] = { x | x in R and a <= x <= b }

equal predicates <=> equal sets (if expressions (in front) also equal)!!!
{ x | x in R and |x| = 1 } <=> { x | x in R and x^2 = 1 }


dicht oder nicht?
nicht dicht + bounded => diskret
N -> left boundary
mathJS.Root class for difference Q <-> R


###
