#!/bin/bash

function usage() {
  echo "Usage:   $0 <tag>"
}

if [ "$#" -ne 1 ];then
  usage
  exit 1
fi

if [ "$1" = '--help' ] || [ "$1" = '-h' ];then
  usage
  exit 0
fi

function main() {
    local current_branch
    readonly local tag=$1
    readonly local tag_branch="${tag}-branch"
    current_branch="$(git branch --show-current)"
    if [ "${current_branch}" != "${tag_branch}" ];then
      git checkout -b "${tag_branch}" || git checkout "${tag_branch}"
      current_branch="${tag_branch}"
    fi
    git add .
    git commit -m "Update tag ${tag}"
    # Delete remote tag
    git push origin ":${tag}"
    # Delete local tag
    git tag -d "${tag}"
    # Push new tag
    git push origin "${tag}"
}

main "$@"
