Class extends _llamafile

Class constructor($controller : 4D:C1709.Class)
	
	Super:C1705($controller)
	
Function start($option : Object) : 4D:C1709.SystemWorker
	
	var $command : Text
	$command:=This:C1470.escape(This:C1470.executablePath)
	
	$command+=" --server --v2 "
	//$command+=" --server "
	
	Case of 
		: (Value type:C1509($option.model)=Is object:K8:27) && (OB Instance of:C1731($option.model; 4D:C1709.File)) && ($option.model.exists)
			$command+=" --model "
			$command+=This:C1470.escape(This:C1470.expand($option.model).path)
	End case 
	
	If (Value type:C1509($option.port)=Is real:K8:4) && ($option.port>0)
		$command+=" --listen 0.0.0.0:"+String:C10($option.port)
	End if 
	
	var $arg : Object
	var $valueType : Integer
	var $key : Text
	
	For each ($arg; OB Entries:C1720($option))
		Case of 
			: (["v2"; "server"; "model"; \
				"port"; "listen"; "alias"; \
				"chat"; \
				"cli"; "embeddings"; "embedding"].includes($arg.key))
				continue
		End case 
		$valueType:=Value type:C1509($arg.value)
		$key:=Replace string:C233($arg.key; "_"; "-"; *)
		Case of 
			: ($valueType=Is real:K8:4)
				$command+=(" --"+$key+" "+String:C10($arg.value)+" ")
			: ($valueType=Is text:K8:3)
				$command+=(" --"+$key+" "+This:C1470.escape($arg.value)+" ")
			: ($valueType=Is boolean:K8:9) && ($arg.value)
				$command+=(" --"+$key+" ")
			Else 
				//
		End case 
	End for each 
	
	return This:C1470.controller.execute($command; $isStream ? $option.model : Null:C1517; $option.data).worker
	
	