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
var $llamafile : cs.llamafile.llamafile

If (False)
    $llamafile:=cs.llamafile.llamafile.new()  //default
Else 
    var $homeFolder : 4D.Folder
    $homeFolder:=Folder(fk home folder).folder(".llamafile")
    var $URL : Text
    var $file : 4D.File
    var $port : Integer
    
    var $event : cs.event.event
    $event:=cs.event.event.new()
    /*
        Function onError($params : Object; $error : cs.event.error)
        Function onSuccess($params : Object; $models : cs.event.models)
        Function onData($request : 4D.HTTPRequest; $event : Object)
        Function onResponse($request : 4D.HTTPRequest; $event : Object)
        Function onTerminate($worker : 4D.SystemWorker; $params : Object)
    */
    
    $event.onError:=Formula(ALERT($2.message))
    $event.onSuccess:=Formula(ALERT($2.models.extract("name").join(",")+" launch requested"))  //not yet ready; poll /v1/models
    $event.onData:=Formula(LOG EVENT(Into 4D debug message; "download:"+String((This.range.end/This.range.length)*100; "###.00%")))
    $event.onResponse:=Formula(LOG EVENT(Into 4D debug message; "download complete"))
    $event.onTerminate:=Formula(LOG EVENT(Into 4D debug message; (["process"; $1.pid; "terminated!"].join(" "))))
    
    /*
        embeddings
    */
    
    $file:=$homeFolder.file("nomic-embed-text-v1.Q8_0.gguf")
    $URL:="https://huggingface.co/nomic-ai/nomic-embed-text-v1-GGUF/resolve/main/nomic-embed-text-v1.Q8_0.gguf"
    $port:=8080
    $llamafile:=cs.llamafile.llamafile.new($port; $file; $URL; $event)
    
    /*
        chat completion
    */
    
    $file:=$homeFolder.file("Llama-3.1-8B-Instruct-Q4_K_M.gguf")
    $URL:="https://huggingface.co/bartowski/Meta-Llama-3.1-8B-Instruct-GGUF/resolve/main/Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf"
    $port:=8081
    $llamafile:=cs.llamafile.llamafile.new($port; $file; $URL; $event)
    
End if  
```

If the component already started a server on the port, the constructor does nothing. If the TCP port is used by another process, `event.onError` receives an error with code `1` and nothing is started. Otherwise the following procedure runs in the background:

1. The specified model is downloaded via HTTP, unless the file already exists
2. The `llamafiler` program is started (the process name is `.ape-1.10`)

`onSuccess` means that the launch was requested, not that the server is ready to accept requests; poll an endpoint such as `/v1/models` until it responds. If the model cannot be downloaded (failed `HEAD`, an unsuccessful `GET` or a network error), `event.onError` receives an error with code `2` and the server is not started. The model is downloaded to a temporary `{name}.download` file in the same folder and renamed only when the download is complete, so an interrupted download is never taken for the model.

`event` may be omitted or `Null`, in which case no callbacks are delivered. Without arguments (or without a valid `$file` and `$URL`), the constructor starts the default models: an embedding model on port `8080` and a chat completion model on port `8081`, each launched once and skipped when already started on its port. The example above starts its own models on the same ports. The server's stdout/stderr are intentionally not forwarded to `event` (a long-running server can produce a large amount of output); `onData` and `onResponse` report the model download only.

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
//$llamafile is an instance created as above
$llamafile.terminate()
```

`terminate()` stops every server started by the component. Call it on an instance you already have: `cs.llamafile.llamafile.new()` without arguments is not a lightweight handle, it starts the default models on ports `8080` and `8081` unless those ports are in use.

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
