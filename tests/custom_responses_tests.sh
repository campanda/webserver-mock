#!/usr/bin/env bash

data_provider_for_test_custom_responses=custom_responses_test_cases.txt
function _test_custom_responses {
  path="$1"
  expected_status_code="$2"
  expected_header1="$3"
  expected_header2="$4"
  expected_body="$5"

  actual=$(curl -si http://target-with-custom-responses$path)
  echo "$actual" | grep -q "$expected_status_code" &&\
  echo "$actual" | grep -q "$expected_header1" &&\
  echo "$actual" | grep -q "$expected_header2" &&\
  echo "$actual" | grep -q "$expected_body"
}
