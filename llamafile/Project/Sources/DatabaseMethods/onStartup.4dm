var $llama : cs:C1710.llamafile

If (False:C215)
	$llama:=cs:C1710.llamafile.new()  //default
Else 
	var $homeFolder : 4D:C1709.Folder
	$homeFolder:=Folder:C1567(fk home folder:K87:24).folder(".llamafile")
	var $URL : Text
	var $file : 4D:C1709.File
	var $port : Integer
	
	var $event : cs:C1710.llamaEvent
	$event:=cs:C1710.llamaEvent.new()
/*
Function onError($params : Object; $error : cs._error)
Function onSuccess($params : Object)
*/
	$event.onError:=Formula:C1597(ALERT:C41($2.message))
	$event.onSuccess:=Formula:C1597(ALERT:C41(This:C1470.file.name+" loaded!"))
	
/*
embeddings
*/
	
	$file:=$homeFolder.file("nomic-embed-text-v1.Q8_0.gguf")
	$URL:="https://huggingface.co/nomic-ai/nomic-embed-text-v1-GGUF/resolve/main/nomic-embed-text-v1.Q8_0.gguf"
	$port:=8080
	$llamafile:=cs:C1710.llamafile.new($port; $file; $URL; $event)
	
/*
chat completion (with images)
*/
	
	//Qwen2-VL-2B-Instruct-Q4_K_M is not supported
	
	$file:=$homeFolder.file("Llama-3.1-8B-Instruct-Q4_K_M.gguf")
	$URL:="https://huggingface.co/bartowski/Meta-Llama-3.1-8B-Instruct-GGUF/resolve/main/Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf"
	$port:=8081
	$llamafile:=cs:C1710.llamafile.new($port; $file; $URL; $event)
	
End if 