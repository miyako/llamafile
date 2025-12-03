//%attributes = {"invisible":true}
var $llama : cs:C1710.llamafile

If (True:C214)
	$llama:=cs:C1710.llamafile.new()  //default
Else 
	var $modelsFolder : 4D:C1709.Folder
	$modelsFolder:=Folder:C1567(fk home folder:K87:24).folder(".llamafile")
	var $lang; $URL : Text
	var $file : 4D:C1709.File
	$lang:=Get database localization:C1009(Current localization:K5:22)
	Case of 
		: ($lang="ja")
			$file:=$modelsFolder.file("Llama-3-ELYZA-JP-8B-q4_k_m.gguf")
			$URL:="https://huggingface.co/elyza/Llama-3-ELYZA-JP-8B-GGUF/resolve/main/Llama-3-ELYZA-JP-8B-q4_k_m.gguf"
		Else 
			$file:=$modelsFolder.file("nomic-embed-text-v1.5.f16.gguf")
			$URL:="https://huggingface.co/nomic-ai/nomic-embed-text-v1.5-GGUF/resolve/main/nomic-embed-text-v1.5.f16.gguf"
	End case 
	var $port : Integer
	$port:=8080
	$llama:=cs:C1710.llamafile.new($port; $file; $URL)
End if 