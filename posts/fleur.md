---
title: My Gopher application framework
date: "2026-06-10"
---

## Introduction

I've always really liked the Gopher protocol for its simplicity, lightness, and accessibility. A while back, I wanted to have my own solution for creating custom Gopher applications. That’s why I decided to write a framework in Go that allows you to implement an [RFC 1436](https://www.rfc-editor.org/rfc/rfc1436.html) compliant Gopher server, as well as add evaluation extensions for the gophermap format and dynamic and virtual routes.

The name of the project is [fleur](https://github.com/theobori/fleur), pronounced \\flœʁ\\, which means flower.

## My goal

My goal is to provide an API for implementing Gopher applications. I want it to be easy to use while remaining low-level enough to allow for a high degree of flexibility.

## How it works

There are a few core components to introduce in order to fully understand how the framework works.

### Route

A route is a pair consisting of a regular expression and a function used by a router.

### Router

This is an interface that manages routes. If one of the regexes matches the request path, the associated function is called. For example, a client requesting a path matching the regex `^/dice$` would receive a gophermap page containing the result of a dice roll.

### Server

A server is essential since it is responsible for receiving Gopher requests from clients and responding to them. Before serving a file, it will ask its router if there is a routing rule for the path requested by the client. If there is one, the associated function will be called first to respond to the client.

Note that before serving a directory, the server will check if there is a `gophermap` file at its root; if so, it will be served instead of the directory.

Also, only files named `gophermap` and those with the `.gophermap` extension will be evaluated.

### Extension

An extension is a pair consisting of a regex and a function; it is similar to the routes in the router component, except that here, an extension is specific to the gophermap format. Creating an extension allows you, for example, to add, modify, or delete gophermap item types. For instance, all standard [RFC 1436](https://www.rfc-editor.org/rfc/rfc1436.html) item types are implemented using extensions in the Fleur CLI.

### Extension Manager

This is an interface for managing extensions; it is used by the evaluator to extend the gophermap.

### Evaluator

An evaluator evaluates gophermap files when the server is ready to serve them. This evaluation works line by line and allows the gophermap format to be extended by adding extensions.

### Example of a simple Gopher Application

Below is a very simple example of a Gopher application designed to serve files.

```go
package main

import (
	"flag"
	"log"

	"github.com/theobori/fleur/gopher"
	"github.com/theobori/fleur/gophermap/evaluator"
	"github.com/theobori/fleur/server"
)

func main() {
	var (
		err           error
		directoryPath string
		domain        string
		port          int
	)

	flag.StringVar(
		&directoryPath,
		"directory",
		"./fleur",
		"Root directory of the Gopher server",
	)
	flag.StringVar(
		&domain,
		"domain",
		"localhost",
		"Gopher domain",
	)
	flag.IntVar(
		&port,
		"port",
		gopher.DefaultPort,
		"Gopher port",
	)

	flag.Parse()

	serverOptions, err := server.NewOptions(
		port,
		directoryPath,
		domain,
		true,
	)
	if err != nil {
		log.Fatalln(err)
	}

	evaluatorOptions := evaluator.Options{
		Port:                 serverOptions.Port,
		DirectoryPath:        serverOptions.DirectoryPath,
		Domain:               serverOptions.Domain,
		EnableAutoInlineText: true,
	}

	em := evaluator.RFC1436ItemsExtensionManager()
	evaluator := evaluator.NewEvaluator(&evaluatorOptions, em)
	server := server.NewServer(serverOptions, evaluator)

	err = server.Serve()
	if err != nil {
		log.Fatalln(err)
	}
}
```

Once compiled, the application can be launched using the command line below.

```bash
./simple -port 7070 -directory "./"
```

## CLI

The fleur CLI is a Gopher application that serves files implemented with the framework. It optionally supports personal Gopherspaces on UNIX systems, with the virtual path `/~username/` being converted to `/home/username/public_gopher`.

It also implements an extension that lists files in the current directory. To use it, type `*` on a line. This feature is inspired by [gophernicus](https://github.com/gophernicus/gophernicus).

## Conclusion

It was a fun project to write and test, and I plan to use it soon to serve my own gophermap files. Also, thanks to [Wireshark](https://www.wireshark.org/), it was a huge help.
