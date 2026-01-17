#!/usr/bin/env bash

token=$(docker logs jupyter 2>&1 | grep -o 'token=[a-f0-9]*' | tail -1)
firefox --private-window http://localhost:4005/lab?$token
