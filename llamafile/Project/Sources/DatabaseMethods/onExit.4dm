//stop the servers started by the component; cs.llamafile.new() would start the default models
var $llama : cs:C1710.workers.worker
$llama:=cs:C1710.workers.worker.new(cs:C1710._server)
$llama.terminate()