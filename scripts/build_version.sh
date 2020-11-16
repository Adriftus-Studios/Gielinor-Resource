#!/bin/bash
#Date=$(date +%Y-%m-%d-%H-%M-%S)

cd ..
git pull

# ██ [ clean build directory ] ██
if [ ! -d build ]; then
  mkdir build
else
  rm -r build
fi

# ██ [ remove previous build ] ██
if [ -f build.zip ]; then
    rm build.zip
fi

# ██ [ compile build ] ██
for f in $(find . -type f -a -not -path './.git/*'); do
    if ! $(git check-ignore -q $f); then
      #echo "Copying file: $f"
      file="${f#*.}"
      dir="${file%/*}"
      echo "Adding $file"
      #echo $dir
      if [ ! -d "./build/$dir" ]; then
        echo "Creating directory: $dir"
        mkdir -p "./build/$dir"
      fi

      cp "$f" "./build/${f#*.}"
    fi
done

# ██ [ clean untracked files ] ██
for f in $(git ls-files -o --exclude-standard); do
  rm ./build/$f
  echo ./build/$f
done

# ██ [ reorganize root ] ██
rm -r build/scripts
for f in README.md mv CONTRIBUTING.md LICENSE; do
  mv build/$f build/meta/
done

# ██ [ clean empty directories ] ██
find build/ -type d -exec rmdir {} + 2>/dev/null

# ██ [ finish new build ] ██
cd build
zip -r ../build.zip *

# ██ [ clean working directory ] ██
cd ..
rm -r build
