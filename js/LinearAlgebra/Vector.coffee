class mathJS.Vector

    _isVectorLike: (v) ->
        return v instanceof mathJS.Vector or v.instanceof?(mathJS.Vector)# or v instanceof mathJS.Tuple or v.instanceof?(mathJS.Tuple)

    @_isVectorLike: @::_isVectorLike

    # CONSTRUCTOR
    constructor: (values) ->
        # check values for
        @values = values
        if DEBUG
            for val in values when not mathJS.isMathJSNum(val)
                console.warn "invalid value:", val

    equals: (v) ->
        if not @_isVectorLike(v)
            return false

        for val, i in @values
            vValue = v.values[i]
            if not val.equals?(vValue) and val isnt vValue
                return false
        return true

    clone: () ->
        return new TD.Vector(@values)

    move: (v) ->
        if not @_isVectorLike v
            return @

        for val, i in v.values
            vValue = v.values[i]
            @values[i] = vValue.plus?(val) or val.plus?(vValue) or (vValue + val)

        return @

    moveBy: @move

    moveTo: (p) ->
        if not @_isVectorLike v
            return @

        for val, i in v.values
            vValue = v.values[i]
            @values[i] = vValue.value or vValue
        return @

    multiply: (r) ->
        if Math.isNum r
            return new TD.Point(@x * r, @y * r)
        return null

    # make alias
    times: @multiply

    magnitude: () ->
        sum = 0
        for val, i in @values
            sum += val * val

        return Math.sqrt(sum)

    ###*
     * This method calculates the distance between 2 points.
     * It"s a shortcut for substracting 2 vectors and getting that vector"s magnitude (because no new object is created).
     * For that reason this method should be used for pure distance calculations.
     *
     * @method distanceTo
     * @param {Point} p
     * @return {Number} Distance between this point and p.
    *###
    distanceTo: (v) ->
        sum = 0

        for val, i in @values
            sum += (val - v.values[i]) * (val - v.values[i])

        return Math.sqrt(sum)

    add: (v) ->
        if not @_isVectorLike v
            return null

        values = []
        for val, i in v.values
            vValue = v.values[i]
            values.push(vValue.plus?(val) or val.plus?(vValue) or (vValue + val))

        return new mathJS.Vector(values)

    # make alias
    plus: @add

    substract: (p) ->
        if isPointLike p
            return new TD.Point(@x - p.x, @y - p.y)
        return null

    # make alias
    minus: @substract

    xyRatio: () ->
        return @x / @y

    toArray: () ->
        return [@x, @y]

    isPositive: () ->
        return @x >= 0 and @y >= 0

    ###*
     * Returns the angle of a vector. Beware that the angle is measured in counter clockwise direction beginning at 0˚ which equals the x axis in positive direction.
     * So on a computer grid the angle won"t be what you expect! Use anglePC() in that case!
     *
     * @method angle
     * @return {Number} Angle of the vector in degrees. 0 degrees means pointing to the right.
    *###
    angle: () ->
        # 1st quadrant (and zero)
        if @x >= 0 and @y >= 0
            return Math.radToDeg( Math.atan( Math.abs(@y) / Math.abs(@x) ) ) % 360
        # 2nd quadrant
        if @x < 0 and @y > 0
            return (90 + Math.radToDeg( Math.atan( Math.abs(@x) / Math.abs(@y) ) )) % 360
        # 3rd quadrant
        if @x < 0 and @y < 0
            return (180 + Math.radToDeg( Math.atan( Math.abs(@y) / Math.abs(@x) ) )) % 360
        # 4th quadrant
        return (270 + Math.radToDeg( Math.atan( Math.abs(@x) / Math.abs(@y) ) )) % 360

    ###*
     * Returns the angle of a vector. 0˚ means pointing to the top. Clockwise.
     *
     * @method anglePC
     * @return {Number} Angle of the vector in degrees. 0 degrees means pointing to the right.
    *###
    anglePC: () ->
        # 1st quadrant: pointing to bottom right
        if @x >= 0 and @y >= 0
            return (90 + Math.radToDeg( Math.atan( Math.abs(@y) / Math.abs(@x) ) )) % 360
        # 2nd quadrant: pointing to bottom left
        if @x < 0 and @y > 0
            return (180 + Math.radToDeg( Math.atan( Math.abs(@x) / Math.abs(@y) ) )) % 360
        # 3rd quadrant: pointing to top left
        if @x < 0 and @y < 0
            return (270 + Math.radToDeg( Math.atan( Math.abs(@y) / Math.abs(@x) ) )) % 360
        # 4th quadrant: pointing to top right
        return Math.radToDeg(Math.atan( Math.abs(@x) / Math.abs(@y) ) ) % 360

    ###*
     * Returns a random Point within a given radius.
     *
     * @method randPointInRadius
     * @param {Number} radius
     * Default is 10 (pixels). Must not be smaller than 0.
     * @param {Boolean} random
     * Indicates whether the given radius is the maximum or exact distance between the 2 points.
     * @return {Number} Random Point.
    *###
    randPointInRadius: (radius = 5, random = false) ->
        angle        = Math.degToRad(Math.randNum(0, 360))
        if random is true
            radius    = Math.randNum(0, radius)

        x = radius * Math.cos angle
        y = radius * Math.sin angle

        return @add( new TD.Point(x, y) )
