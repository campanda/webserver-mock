#!/usr/bin/env bash

function test_server_replies_with_200_for_allowed_http_verbs {
  foo=$(curl -sI http://target-with-custom-http-verbs/ -X FOO)
  bar=$(curl -sI http://target-with-custom-http-verbs/ -X BAR)
  echo "$foo" | grep -q '200 OK' &&\
  echo "$bar" | grep -q '200 OK'
}

function test_server_replies_with_405_for_not_allowed_http_verbs {
  actual=$(curl -sI http://target-with-custom-http-verbs/ -X BACON)
  echo "$actual" | grep -q '405 Method Not Allowed'
}
