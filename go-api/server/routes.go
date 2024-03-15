package server

import (
	"aws_application/server/handlers"
	"net/http"
)

// router configures routes for the server
func router(mux *http.ServeMux) {
	// Register a handler for the list-bucket-content endpoint
	mux.HandleFunc("/list-bucket-content/", handlers.HandleS3BucketContent())

}
