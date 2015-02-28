###*
 * @module mathJS
 * @main mathJS
*###

if typeof DEBUG is "undefined"
    window.DEBUG = true

# create namespaces
window.mathJS =
    Algorithms: {}
    Domains: {} # contains instances of sets
    Errors: {}
    Geometry: {}
    Operations: {}
    Sets: {}

# Take namespaces from mathJS
_mathJS = $.extend {}, mathJS

if DEBUG
    window._mathJS = _mathJS
    startTime = Date.now()
