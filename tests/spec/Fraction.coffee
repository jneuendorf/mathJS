describe "Fraction (fractions)", () ->

    it "creation", () ->
        expect(mathJS.Fraction.new(1, 2).numerator)
            .toBe(1)

        expect(mathJS.Fraction.new(1, 2).denominator)
            .toBe(2)

        expect(mathJS.Fraction.parse("12e-2").equals(mathJS.Fraction.new(12, 100)))
            .toBe(true)

    it "comparison", () ->
        n1 = mathJS.Fraction.new(42)
        n2 = mathJS.Fraction.new(1337.123)

        expect(mathJS.Fraction.new(42).equals(n1))
            .toBe(true)

        expect(n1.lessThan(n2))
            .toBe(true)
        expect(n1.greaterThan(n2))
            .toBe(false)

        expect(n2.lessThan(n1))
            .toBe(false)
        expect(n2.greaterThan(n1))
            .toBe(true)

        expect(n1.lessThanOrEqualTo(n1))
            .toBe(true)
        expect(n1.greaterThanOrEqualTo(n1))
            .toBe(true)

        expect(n1.lessThanOrEqualTo(n2))
            .toBe(true)
        expect(n1.greaterThanOrEqualTo(n2))
            .toBe(false)

        expect(n2.lessThanOrEqualTo(n1))
            .toBe(false)
        expect(n2.greaterThanOrEqualTo(n1))
            .toBe(true)


    it "basic operations", () ->
        n1          = mathJS.Number.new(4)
        n2          = mathJS.Number.new(5)

        sum         = mathJS.Number.new(9)
        diff        = mathJS.Number.new(-1)
        product     = mathJS.Number.new(20)
        quotient    = mathJS.Number.new(0.8)

        # plus
        expect(n1.plus(n2).equals(9))
            .toBe(true)
        expect(n1.plus(n2).equals(sum))
            .toBe(true)

        # minus
        expect(n1.minus(n2).equals(-1))
            .toBe(true)
        expect(n1.minus(n2).equals(diff))
            .toBe(true)

        # times
        expect(n1.times(n2).equals(20))
            .toBe(true)
        expect(n1.times(n2).equals(product))
            .toBe(true)

        # divide
        expect(n1.divide(n2).equals(0.8))
            .toBe(true)
        expect(n1.divide(n2).equals(quotient))
            .toBe(true)

    it "advanced operations", () ->
        n1          = mathJS.Number.new(4)
        n2          = mathJS.Number.new(8)
        n3          = mathJS.Number.new(625)
        n4          = mathJS.Number.new(-42)

        square      = mathJS.Number.new(16)
        cube        = mathJS.Number.new(64)
        sqrt        = mathJS.Number.new(2)
        curt        = mathJS.Number.new(2)
        root        = mathJS.Number.new(5)
        reciprocal  = mathJS.Number.new(1/8)
        pow         = mathJS.Number.new(625)
        sign        = mathJS.Number.new(1)

        # square: 4^2 = 16
        expect(n1.square().equals(16))
            .toBe(true)
        expect(n1.square().equals(square))
            .toBe(true)

        # cube: 4^3 = 64
        expect(n1.cube().equals(64))
            .toBe(true)
        expect(n1.cube().equals(cube))
            .toBe(true)

        # sqrt: 4^(1/2) = 2
        expect(n1.sqrt().equals(2))
            .toBe(true)
        expect(n1.sqrt().equals(sqrt))
            .toBe(true)

        # curt: 8^(1/3) = 2
        expect(n2.curt().equals(2))
            .toBe(true)
        expect(n2.curt().equals(curt))
            .toBe(true)

        # root: 625^(1/4) = 5
        expect(n3.root(4).equals(5))
            .toBe(true)
        expect(n3.root(mathJS.Number.new(4)).equals(root))
            .toBe(true)

        # reciprocal: 1/8 = 0.125
        expect(n2.reciprocal().equals(0.125))
            .toBe(true)
        expect(n2.reciprocal().equals(reciprocal))
            .toBe(true)

        # pow: inverse of root
        expect(n1.pow(4).root(4).equals(n1))
            .toBe(true)
        expect(n2.pow(mathJS.Number.new(8)).root(8).equals(n2))
            .toBe(true)

        # sign: pos and neg
        expect(n1.sign())
            .toBe(1)
        expect(n1.sign(true))
            .toBe(1)
        expect(n1.sign(false).equals(mathJS.Number.new(1)))
            .toBe(true)
        expect(n4.sign())
            .toBe(-1)
        expect(n4.sign(false).equals(mathJS.Number.new(-1)))
            .toBe(true)

        # negation
        expect(n1.negate().equals(-4))
            .toBe(true)
        expect(n4.negate().equals(42))
            .toBe(true)

    it "conversion", () ->
        n1 = mathJS.Number.new(0.8)
        n2 = mathJS.Number.new(1e-14)
        n3 = mathJS.Number.new(1e-5)

        expect(n1.toString()).toBe("0.8")
        expect(n2.toString()).toBe("1e-14")
        expect(n2.toString("0.00000000000000000000")).toBe("0.00000000000001000000")
        expect(n3.toString()).toBe("0.00001")

        expect(n1.toNumber().equals(n1)).toBe(true)

        expect(n1.toInt().equals(mathJS.Int.new(n1))).toBe(true)
