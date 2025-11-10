# llamafile
Local inference engine

When `--server` is passed, `llamafile` seems to become `llamafiler`. However in this mode, arguments like `--port` or `--alias` are no longer available. `llamafiler` is smaller than `llamafile` but has less options. The `--port` option is mapped to `--listen 0.0.0.0:{port}`. 
