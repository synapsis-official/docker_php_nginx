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
    readonly local tag=$1
    readonly local tag_branch="${tag}-branch"
    readonly local working_branch="$(git branch --show-current)"
    if [ "${working_branch}" != "${tag_branch}" ];then
      git checkout -b "${tag_branch}" || git checkout "${tag_branch}"
    fi
    git add .
    git commit -m "Update tag ${tag}"
    # Delete remote tag
    git push origin ":${tag}" || true
    # Delete local tag
    git tag -d "${tag}" || true
    # Make local tag
    git tag "${tag}" || true
    # Push new tag
    git push origin "${tag}"
    git push origin ":${tag_branch}"
    # Checkout to working branch
    git checkout "${working_branch}"
}

main "$@"
