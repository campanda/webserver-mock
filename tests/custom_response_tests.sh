#!/usr/bin/env bash

function test_replies_with_injected_http_status_code {
  actual=$(curl -sI http://target-with-custom-response/whatever-request)
  echo "$actual" | grep -q '201 Created'
}

function test_replies_with_injected_http_headers {
  actual=$(curl -sI http://target-with-custom-response/whatever-request)
  echo "$actual" | grep -q 'X-Page-Type: mypage' &&\
  echo "$actual" | grep -q 'Content-Type: text/html'
}

function test_replies_with_injected_body {
  actual=$(curl -si http://target-with-custom-response/whatever-request)
  echo "$actual" | grep -q '<h1>my page</h1>' && \
    echo "$actual" | grep -q 'GET /whatever-request'
}
