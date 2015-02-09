class mathJS.Tuple

    ###########################################################################
    # CONSTRUCTOR
    constructor: (elems...) ->
        if elems.first instanceof Array
            elems = elems.first

        temp = []

        for elem in elems
            if not mathJS.isNum(elem)
                temp.push elem
            else
                temp.push new mathJS.Number(elem)

        @elems = temp
        @_size = temp.length

    ###########################################################################
    # PUBLIC METHODS
    add: (elems...) ->
        return new mathJS.Tuple(@elems.concat(elems))

    at: (idx) ->
        return @elems[idx]

    clone: () ->
        return new mathJS.Tuple(@elems)

    contains: (elem) ->
        for e in @elems when e.equals elem
            return true
        return false

    equals: (tuple) ->
        if @_size isnt tuple._size
            return false

        elements = tuple.elems

        for elem, idx in @elems when not elem.equals elements[idx]
            return false

        return true

    eval: (values) ->
        elems = (elem.eval(values) for elem in @elems)
        return new mathJS.Tuple(elems)

    ###*
    * Get the elements of the Tuple.
    * @method getElements
    *###
    getElements: () ->
        return @elems.clone()

    insert: (idx, elems...) ->
        elements = []
        for elem, i in @elems
            if i is idx
                elements = elements.concat(elems)
            elements.push elem

        return new mathJS.Tuple(elements)

    isEmpty: () ->
        return @_size() is 0

    ###*
    * Removes the first occurences of the given elements.
    *###
    remove: (elems...) ->
        elements = @elems.clone()
        for e in elems
            for elem, i in elements when elem.equals e
                elements.splice i, 1
                break

        return new mathJS.Tuple(elements)

    removeAt: (idx, n=1) ->
        elems = []
        for elem, i in @elems when i < idx or i >= idx + n
            elems.push elem

        return new mathJS.Tuple(elems)

    size: () ->
        return @_size

    slice: (startIdx, endIdx=@_size) ->
        return new mathJS.Tuple(@elems.slice(startIdx, endIdx))

    ###########################################################################
    # ALIASES
    cardinality: @::size

    extendBy: @::add

    get: @::at

    has: @::contains

    addAt: @::insert
    insertAt: @::insert

    reduceBy: @::remove
