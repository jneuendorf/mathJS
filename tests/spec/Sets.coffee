describe "Domains", () ->

    it "N", () ->
        set = mathJS.Domains.N

        expect(set.size).toBe(Infinity)

        expect(set.contains(0)).toBe(true)

        expect(set.contains(0.5)).toBe(false)

        expect(set.contains(-5)).toBe(false)

        expect(set.infimum).toBe(0)

        expect(set.supremum).toBe(Infinity)

    it "Z", () ->
        set = mathJS.Domains.Z

        expect(set.size).toBe(Infinity)

        expect(set.contains(0)).toBe(true)

        expect(set.contains(0.5)).toBe(false)

        expect(set.contains(-5)).toBe(true)

        expect(set.infimum).toBe(Infinity)

        expect(set.supremum).toBe(Infinity)

    it "Q", () ->
        set = mathJS.Domains.Q

        expect(set.size).toBe(Infinity)

        expect(set.contains(0)).toBe(true)

        expect(set.contains(0.5)).toBe(true)

        expect(set.contains(-5)).toBe(true)

        expect(set.infimum).toBe(Infinity)

        expect(set.supremum).toBe(Infinity)

    it "I", () ->
        set = mathJS.Domains.I

        expect(set.size).toBe(Infinity)

        expect(set.contains(0)).toBe(true)

        expect(set.contains(0.5)).toBe(false)

        expect(set.contains(-5)).toBe(true)

        expect(set.contains(mathJS.pi)).toBe(true)

        expect(set.infimum).toBe(Infinity)

        expect(set.supremum).toBe(Infinity)

    it "R", () ->
        set = mathJS.Domains.R

        expect(set.size).toBe(Infinity)

        expect(set.contains(0)).toBe(true)

        expect(set.contains(0.5)).toBe(true)

        expect(set.contains(-5)).toBe(true)

        expect(set.contains(mathJS.pi)).toBe(true)

        expect(set.infimum).toBe(Infinity)

        expect(set.supremum).toBe(Infinity)


describe "Sets", () ->


    describe "should be able be parsed from string:", () ->

        it "ellipsis", () ->
            set = mathJS.Set.fromString("{1, 2, 3, ...}")
            expect(set.size).toBe(Infinity)

        it "simple expression (variable) + domain", () ->
            set = mathJS.Set.fromString("{ x | x in R}")
            expect(set.size).toBe(Infinity)

            set2 = mathJS.Set.fromString("{ x : x in R}")
            expect(set.size).toBe(Infinity)
