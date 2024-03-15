package handlers

import (
	"aws_application/modules"
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"time"
)

// HandleS3BucketContent handles requests to list S3 bucket content
func HandleS3BucketContent() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// Set a timeout for the request context
		ctx, cancel := context.WithTimeout(r.Context(), time.Duration(100)*time.Second)
		defer cancel()
		path := r.URL.Path[len("/list-bucket-content/"):]

		// specify bucket-name
		const bucketName = "bucket-name"

		// Call the GetS3Content function to fetch content from the bucket
		content, err := modules.GetS3Content(ctx, path, bucketName)
		if err != nil {
			fmt.Println("Error retrieving content:", err)
			w.WriteHeader(http.StatusInternalServerError)
			return
		}

		jsonData, err := json.Marshal(map[string]interface{}{"content": content})
		if err != nil {
			fmt.Println("Error marshalling data:", err)
			w.WriteHeader(http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.Write(jsonData)

	}
}
