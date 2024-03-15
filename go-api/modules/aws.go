package modules

import (
	"context"
	"fmt"
	"strings"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)

// GetS3Content fetches content from S3 bucket
func GetS3Content(ctx context.Context, path, bucketName string) ([]string, error) {

	sess, err := session.NewSession(&aws.Config{
		Region: aws.String("ap-south-1"),
	})
	if err != nil {
		return nil, fmt.Errorf("error creating session: %w", err)
	}
	// Create a new S3 client
	svc := s3.New(sess)

	// Prepare parameters for listing objects in the bucket
	params := &s3.ListObjectsV2Input{
		Bucket: aws.String(bucketName), //bucket name
	}

	// If a path is specified, set the prefix to the path
	if path != "" {
		params.Prefix = aws.String(path + "/")
	}

	// Call the ListObjectsV2 API to list objects in the bucket
	resp, err := svc.ListObjectsV2(params)
	if err != nil {
		return nil, fmt.Errorf("error listing objects: %w", err)
	}

	var content []string
	for _, obj := range resp.Contents {
		if !strings.HasSuffix(*obj.Key, "/") {
			// Extract only the filename (excluding path)
			filename := strings.TrimPrefix(*obj.Key, path+"/")
			content = append(content, filename)
		}
	}

	// Always return an empty list instead of nil for empty content
	if len(content) == 0 {
		content = []string{}
	}

	return content, nil

}
