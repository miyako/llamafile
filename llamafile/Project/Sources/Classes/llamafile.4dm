Class constructor($port : Integer; $file : 4D:C1709.File; $URL : Text; $event : cs:C1710.event.event)
	
	var $llama : cs:C1710.workers.worker
	$llama:=cs:C1710.workers.worker.new(cs:C1710._server)
	
	If (Not:C34($llama.isRunning()))
		
		If (Value type:C1509($file)#Is object:K8:27) || (Not:C34(OB Instance of:C1731($file; 4D:C1709.File))) || ($URL="")
			var $homeFolder : 4D:C1709.Folder
			$homeFolder:=Folder:C1567(fk home folder:K87:24).folder(".llamafile")
			
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
			
			$file:=$homeFolder.file("Qwen2-VL-2B-Instruct-Q4_K_M")
			$URL:="https://huggingface.co/bartowski/Qwen2-VL-2B-Instruct-GGUF/resolve/main/Qwen2-VL-2B-Instruct-Q4_K_M.gguf"
			$port:=8081
			$llamafile:=cs:C1710.llamafile.new($port; $file; $URL; $event)
			
		End if 
		
		If ($port=0) || ($port<0) || ($port>65535)
			$port:=8080
		End if 
		
		This:C1470._main($port; $file; $URL; $event)
		
	End if 
	
Function _onTCP($status : Object; $options : Object)
	
	If ($status.success)
		
		var $className : Text
		$className:=Split string:C1554(Current method name:C684; "."; sk trim spaces:K86:2).first()
		
		CALL WORKER:C1389($className; Formula:C1597(start); $options; Formula:C1597(onModel))
		
	Else 
		
		var $statuses : Text
		$statuses:="TCP port "+String:C10($status.port)+" is aready used by process "+$status.PID.join(",")
		var $error : cs:C1710.event.error
		$error:=cs:C1710.event.error.new(1; $statuses)
		
		If ($options.event#Null:C1517) && (OB Instance of:C1731($options.event; cs:C1710.event.event))
			$options.event.onError.call(This:C1470; $options; $error)
		End if 
		
	End if 
	
Function _main($port : Integer; $file : 4D:C1709.File; $URL : Text; $event : cs:C1710.event.event)
	
	main({port: $port; file: $file; URL: $URL; event: $event}; This:C1470._onTCP)
	
Function terminate()
	
	var $llama : cs:C1710.workers.worker
	$llama:=cs:C1710.workers.worker.new(cs:C1710._server)
	$llama.terminate()