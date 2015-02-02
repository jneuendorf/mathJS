###*
 * @module mathJS
 * @main mathJS
*###

if typeof DEBUG is "undefined"
    window.DEBUG = true

# create namespaces
window.mathJS =
    Domains: {} # contains instances of sets
    Errors: {}
    Geometry: {}
    Operations: {}
    Sets: {}
