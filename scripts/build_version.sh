#!/bin/bash
#Date=$(date +%Y-%m-%d-%H-%M-%S)

cd ..
if [ ! -d build ]; then
  mkdir build
else
  rm -r build
fi

if [ -f build.zip ]; then
    rm build.zip
fi

for f in $(find . -type f -a -not -path './.git/*'); do
    if ! $(git check-ignore -q $f); then
      #echo "Copying file: $f"
      file="${f#*.}"
      dir="${file%/*}"
      echo $file
      #echo $dir
      if [ ! -d "./build/$dir" ]; then
        echo "Creating directory: $dir"
        mkdir -p "./build/$dir"
      fi

      cp "$f" "./build/${f#*.}"
    fi
done

find build/ -type d -exec rmdir {} + 2>/dev/null

cd build
zip -r ../build.zip *

rm -r build
