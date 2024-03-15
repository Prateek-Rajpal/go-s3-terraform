#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y
# Install Golang 
wget https://golang.org/dl/go1.19.5.linux-amd64.tar.gz
tar -xvf go1.19.5.linux-amd64.tar.gz
export GOPATH=/home/ubuntu/go
export PATH=$GOPATH/bin:$PATH
rm -rf go1.19.5.linux-amd64.tar.gz
# Build application
cd cmd/
go build -o s3-api .

# Run the binary 
nohup ./s3-api &