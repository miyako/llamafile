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
var $llama : cs.llamafile.llamafile

If (True)
    $llama:=cs.llamafile.llamafile.new()  //default
Else 
    var $modelsFolder : 4D.Folder
    $modelsFolder:=Folder(fk home folder).folder(".llamafile")
    var $lang; $URL : Text
    var $file : 4D.File
    $lang:=Get database localization(Current localization)
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
    $llama:=cs.llamafile.llamafile.new($port; $file; $URL; Formula(ALERT(This.file.name+($1.success ? " started!" : " did not start..."))))
End if
```

Unless the server is already running (in which case the costructor does nothing), the following procedure runs in the background:

1. The specified model is download via HTTP
2. The `llamafiler` program is started

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
|Files|`v1/files`||
