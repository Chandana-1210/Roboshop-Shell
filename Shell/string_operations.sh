#!/bin/bash
str=DevOpsEngineer

echo "${#str}"
echo "${str:0:6}"
echo "${str/Engineer/Admin}"