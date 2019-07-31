@echo off
chcp 65001

set GO111MODULE=on
set GOARCH=amd64
set GOOS=linux

rd /s /q .\bin

go mod tidy
go build -o .\bin\demo-web

xcopy .\static .\bin\static\ /s /e /y
xcopy .\tmpl .\bin\tmpl\ /s /e /y
copy .\run.sh .\bin\run.sh
copy .\demo-web.service .\bin\demo-web.service