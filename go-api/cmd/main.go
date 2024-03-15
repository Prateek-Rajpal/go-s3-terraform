package main

import (
	"aws_application/server"
	"log"
)

func main() {
	err := server.RunServer()
	if err != nil {
		log.Fatal(err)
	}
}
