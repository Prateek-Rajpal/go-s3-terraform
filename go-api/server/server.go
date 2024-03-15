package server

import (
	"fmt"
	"net/http"
)

// RunServer starts the HTTP server
func RunServer() error {
	// Create a new ServeMux instance
	mux := http.NewServeMux()
	router(mux)

	// Start the server and listen on port 8080
	fmt.Println("Server listening on port 8080")
	return http.ListenAndServe(":8080", mux)
}
