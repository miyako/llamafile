# llamafile
Local inference engine

When `--server` is passed, `llamafile` seems to become `llamafiler`. However in this mode, arguments like `--port` or `--alias` are no longer available. `llamafiler` is smaller than `llamafile` but has less options. The `--port` option is mapped to `--listen 0.0.0.0:{port}`. 

## Usage

```4d
var $llamafile : cs.llamafile.server
$llamafile:=cs.llamafile.server.new()
$isRunning:=$llamafile.isRunning()
$file:=File("/Users/miyako/Library/Application Support/nomic.ai/GPT4All/DeepSeek-R1-Distill-Qwen-1.5B-Q4_0.gguf")
$llamafile.start({model: $file; port: 8080})
```
