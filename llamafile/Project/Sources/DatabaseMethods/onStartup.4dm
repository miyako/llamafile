var $llama : cs:C1710.llamafile

If (False:C215)
	$llama:=cs:C1710.llamafile.new()  //default
Else 
	var $homeFolder : 4D:C1709.Folder
	$homeFolder:=Folder:C1567(fk home folder:K87:24).folder(".llamafile")
	var $URL : Text
	var $file : 4D:C1709.File
	var $port : Integer
	
	var $event : cs:C1710.event.event
	$event:=cs:C1710.event.event.new()
/*
Function onError($params : Object; $error : cs.event.error)
Function onSuccess($params : Object; $models : cs.event.models)
*/
	$event.onError:=Formula:C1597(ALERT:C41($2.message))
	$event.onSuccess:=Formula:C1597(ALERT:C41($2.models.extract("name").join(",")+" loaded!"))
	$event.onData:=Formula:C1597(MESSAGE:C88(String:C10((This:C1470.range.end/This:C1470.range.length)*100; "###.00%")))  //onData@4D.HTTPRequest
	$event.onResponse:=Formula:C1597(ERASE WINDOW:C160)  //onResponse@4D.HTTPRequest
	
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
	
	$file:=$homeFolder.file("Llama-3.1-8B-Instruct-Q4_K_M.gguf")
	$URL:="https://huggingface.co/bartowski/Meta-Llama-3.1-8B-Instruct-GGUF/resolve/main/Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf"
	$port:=8081
	$llamafile:=cs:C1710.llamafile.new($port; $file; $URL; $event)
	
End if 