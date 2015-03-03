mathJS.Initializer.start()

if DEBUG
    diff = Date.now() - startTime
    console.log "time to load mathJS: ", diff, "ms"
    if diff > 100
        console.warn "LOADING TIME CRITICAL!"
