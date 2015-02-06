class mathJS.AbstractSet

    equals: (set) ->

    contains: (x) ->

    clone: () ->

    union: (set) ->

    intersect: (set) ->

    isSubsetOf: (set) ->

    isSupersetOf: (set) ->

    complement: () ->

    without: (set) ->

    # ALIASES
    except: @without
    supersetOf: @isSupersetOf
    subsetOf: @isSubsetOf
    intersection: @intersect
