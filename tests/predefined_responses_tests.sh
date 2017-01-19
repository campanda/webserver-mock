#!/usr/bin/env bash

function test_bad_request {
  actual=$(curl -sI http://target-default-config/bad-request)
  echo "$actual" | grep -q '400 Bad Request'
}

function test_unauthorized {
  actual=$(curl -sI http://target-default-config/unauthorized)
  echo "$actual" | grep -q '401 Unauthorized'
}

function test_forbidden {
  actual=$(curl -sI http://target-default-config/forbidden)
  echo "$actual" | grep -q '403 Forbidden'
}

function test_not_found {
  actual=$(curl -sI http://target-default-config/not-found)
  echo "$actual" | grep -q '404 Not Found'
}

function test_internal_server_error {
  actual=$(curl -sI http://target-default-config/internal-server-error)
  echo "$actual" | grep -q '500 Internal Server Error'
}

function test_bad_gateway {
  actual=$(curl -sI http://target-default-config/bad-gateway)
  echo "$actual" | grep -q '502 Bad Gateway'
}

function test_service_unavailable {
  actual=$(curl -sI http://target-default-config/service-unavailable)
  echo "$actual" | grep -q '503 Service Unavailable'
}

function test_gateway_timeout {
  actual=$(curl -sI http://target-default-config/gateway-timeout)
  echo "$actual" | grep -q '504 Gateway Timeout'
}
