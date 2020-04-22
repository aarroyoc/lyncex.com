#!/bin/bash
sleep 10
curl -X POST -H "Content-Type: text/turtle" --data-binary "@app.ttl" http://lyncex:11011/_api