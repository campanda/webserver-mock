#!/usr/bin/env bash

function test_server_can_talk_https {
  actual=$(curl -sik https://target-on-https/)
  echo "$actual" | grep -q '200 OK'
}
