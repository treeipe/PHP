#!/usr/bin/env bash
finder()
{
  for dir in $(ls -d */ | sed 's#/##'); do
    cd $dir
    echo $(pwd)
    if [ -f "$FILE" ]; then
        docker build -t "$IMAGE_NAME:$dir" .
        docker tag "$IMAGE_NAME:$dir" "$REPOSITORY:$dir$SUFFIX"
        docker push "$REPOSITORY:$dir$SUFFIX"
    fi
    cd ..
  done
}
finder $(pwd)
