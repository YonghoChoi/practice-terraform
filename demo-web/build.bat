@echo off

set GO111MODULE=on
set GOARCH=amd64
set GOOS=linux

go mod tidy
go build -o .\bin\demo-web