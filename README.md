![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/llamafile)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/llamafile/total)

# llamafile
Local inference engine

**aknowledgements**: [mozilla-ai/llamafile](https://github.com/mozilla-ai/llamafile)

When `--server` is passed, `llamafile` seems to become `llamafiler`. However in this mode, arguments like `--port` or `--alias` are no longer available. `llamafiler` is smaller than `llamafile` but has less options. The `--port` option is mapped to `--listen 0.0.0.0:{port}`. 
