---
layout: default
---

![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/llamafile)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/llamafile/total)

# Use llamafile from 4D

#### Abstract

[**llamafile**](https://github.com/mozilla-ai/llamafile) is an open-source project created by Mozilla that lets you distribute and run Large Language Models (LLMs) as a single, runnable file.

#### Usage

Instantiate `cs.llamafile.llamafile` in your *On Startup* database method:

```4d
var $LlamaEdge : cs.LlamaEdge.LlamaEdge

If (False)
    $LlamaEdge:=cs.LlamaEdge.LlamaEdge.new()  //default
Else 
    var $homeFolder : 4D.Folder
    $homeFolder:=Folder(fk home folder).folder(".LlamaEdge")
    var $model : cs.LlamaEdgeModel
    var $file : 4D.File
    var $URL : Text
    var $prompt_template : Text
    var $ctx_size : Integer
    
    var $models : Collection
    $models:=[]
    
    /*
        if file doesn't exist, it is downloaded from URL 
        paths are relative to $home which is mapped to . in wasm
    */
    
    //#1 is chat model
    
    $file:=$homeFolder.file("llama/Llama-3.2-3B-Instruct-Q4_K_M.gguf")
    $URL:="https://huggingface.co/second-state/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q4_K_M.gguf"
    $path:="./.LlamaEdge/llama/"+$file.fullName
    $prompt_template:="llama-3-chat"
    $ctx_size:=4096
    $model_name:="llama"
    $model_alias:="default"
    
    $model:=cs.LlamaEdgeModel.new($file; $URL; $path; $prompt_template; $ctx_size; $model_name; $model_alias)
    $models.push($model)
    
    //#2 is embedding model
    
    $file:=$homeFolder.file("nomic-ai/nomic-embed-text-v2-moe.Q5_K_M.gguf")
    $URL:="https://huggingface.co/nomic-ai/nomic-embed-text-v2-moe-GGUF/resolve/main/nomic-embed-text-v2-moe.Q5_K_M.gguf"
    $path:="./.LlamaEdge/nomic-ai/"+$file.fullName
    $prompt_template:="embedding"
    $ctx_size:=512
    $model_name:="nomic"
    $model_alias:="embedding"
    
    $model:=cs.LlamaEdgeModel.new($file; $URL; $path; $prompt_template; $ctx_size; $model_name; $model_alias)
    $models.push($model)
    
    var $port : Integer
    $port:=8080
    
    var $event : cs.event.event
    $event:=cs.event.event.new()
    /*
        Function onError($params : Object; $error : cs.event.error)
        Function onSuccess($params : Object; $models : cs.event.models)
    */
    $event.onError:=Formula(ALERT($2.message))
    $event.onSuccess:=Formula(ALERT($2.models.extract("name").join(",")+" loaded!"))
    $event.onData:=Formula(MESSAGE(String((This.range.end/This.range.length)*100; "###.00%")))  //onData@4D.HTTPRequest
    $event.onResponse:=Formula(ERASE WINDOW)  //onResponse@4D.HTTPRequest
    
    $LlamaEdge:=cs.LlamaEdge.LlamaEdge.new($port; $models; {home: $homeFolder}; $event)
    
End if 
```

Unless the server is already running (in which case the costructor does nothing), the following procedure runs in the background:

1. The specified model is downloaded via HTTP
2. The `llamafiler` program is started (the process name is `.ape-1.10`)

Now you can test the server:

```
curl -X POST http://127.0.0.1:8080/v1/embeddings \
     -H "Content-Type: application/json" \
     -d '{"input":"The quick brown fox jumps over the lazy dog."}'
```

Or, use AI Kit:

```4d
var $AIClient : cs.AIKit.OpenAI
$AIClient:=cs.AIKit.OpenAI.new()
$AIClient.baseURL:="http://127.0.0.1:8080/v1"

var $text : Text
$text:="The quick brown fox jumps over the lazy dog."

var $responseEmbeddings : cs.AIKit.OpenAIEmbeddingsResult
$responseEmbeddings:=$AIClient.embeddings.create($text)
```

Finally to terminate the server:

```4d
var $llama : cs.llamafile.llamafile
$llama:=cs.llamafile.llamafile.new()
$llama.terminate()
```

#### AI Kit compatibility

The API is compatibile with [Open AI](https://platform.openai.com/docs/api-reference/embeddings). 

|Class|API|Availability|
|-|-|:-:|
|Models|`/v1/models`|✅|
|Chat|`/v1/chat/completions`|✅|
|Images|`/v1/images/generations`||
|Moderations|`/v1/moderations`||
|Embeddings|`/v1/embeddings`|✅|
|Files|`/v1/files`||
