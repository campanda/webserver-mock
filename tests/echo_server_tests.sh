#!/usr/bin/env bash

function test_replies_with_request_method_and_path {
  actual=$(curl -si http://target-default-config/foo/bar)
  echo "$actual" | grep -q 'GET /foo/bar'
}

function test_replies_with_request_headers {
  actual=$(curl -si http://target-default-config/ -H 'Foo: bar' -H 'Chunky: bacon')
  echo "$actual" | grep -q 'Foo: bar' &&\
  echo "$actual" | grep -q 'Chunky: bacon'
}

function test_replies_with_request_body {
  actual=$(curl -si http://target-default-config/ -d 'some-data-on-request-body')
  echo "$actual" | grep -q 'some-data-on-request-body'
}
