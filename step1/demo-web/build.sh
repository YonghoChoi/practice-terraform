#!/bin/sh

export GO111MODULE=on
export GOARCH=amd64
export GOOS=linux

rm -rf ./bin

go mod tidy
go build -o ./bin/demo-web

cp -R ./static ./bin/static
cp -R ./tmpl ./bin/tmpl
cp ./run.sh ./bin/run.sh
cp ./demo-web.service ./bin/demo-web.service
echo "demo web build complete!"