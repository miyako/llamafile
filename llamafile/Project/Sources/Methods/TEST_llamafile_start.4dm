//%attributes = {"invisible":true}
var $llamafile : cs:C1710.server
$llamafile:=cs:C1710.server.new()

$isRunning:=$llamafile.isRunning()

//$file:=File("/Users/miyako/.lmstudio/models/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/tinyllama-1.1b-chat-v1.0.Q8_0.gguf")
//$file:=File("/Users/miyako/Library/Application Support/nomic.ai/GPT4All/DeepSeek-R1-Distill-Qwen-1.5B-Q4_0.gguf")
$file:=File:C1566("/Users/miyako/.ollama/models/blobs/sha256-96c415656d377afbff962f6cdb2394ab092ccbcbaab4b82525bc4ca800fe8a49")
//$file:=File("/Users/miyako/.ollama/models/blobs/sha256-970aa74c0a90ef7482477cf803618e776e173c007bf957f635f1015bfcfef0e6")
//$file:=File("/Users/miyako/.ollama/models/blobs/sha256-f5074b1221da0f5a2910d33b642efa5b9eb58cfdddca1c79e16d7ad28aa2b31f")

$llamafile.start({model: $file; port: 8080})