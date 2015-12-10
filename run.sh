#!/bin/bash
if [ -z "$(which docker)" ]; then
  echo "Install docker from http://docs.docker.com/engine/installation/"
  exit 1
fi
if [ $(docker images | grep -c "CREATED") -eq 0 ]; then
  echo "Run boot2docker to set up docker environment."
  exit 1
fi
if [ $(docker images | grep -c "mboehme/corebench*") -eq 0 ]; then
  echo "Execute 'docker pull mboehme/corebench' and/or 'docker pull mboehme/corebenchx'"
  echo "Or execute 'docker build -t mboehme/corebench .' and/or 'docker build -t mboehme/corebenchx .'"
  echo "Or tag an image as mboehme/corebench or mboehme/corebenchx"
  exit 1
fi
if [ $(docker images | grep -c "mboehme/corebench*") -gt 1 ] && [ -z "$1" ]; then
  echo "Execute $0 [corebench|corebenchx] to specify which instance to run."
  exit 1
fi

exit_code=0
corebench=$(if [ -z "$1" ]; then echo $(docker images | grep "mboehme/corebench*" | cut -d" " -f1 | cut -c9-); else echo "$1"; fi)

if [ $(docker ps | grep -c "mboehme/$corebench ") -ne 0 ]; then
  echo "An instance of 'mboehme/$corebench' is already running ($(docker ps | grep "mboehme/$corebench " | cut -c-12))"
  echo "Connecting .."
  if [ -z "$2" ]; then 
    docker exec -it $(docker ps | grep "mboehme/$corebench " | cut -c-12) bash
  else 
    echo "$2" | docker exec -i $(docker ps | grep "mboehme/$corebench " | cut -c-12) bash 
    exit_code=$?
  fi
  exit $exit_code
fi

if [[ "$corebench" == "corebench" ]]; then
  printf "Container (find, grep, make): "
  docker run -dt --name corebench0 -v $(pwd):/shared -p 5900:5900 --dns 8.8.8.8 --dns 8.8.4.4 mboehme/corebench | cut -c-12
  echo "Now use VNCViewer to access $(boot2docker ip):5900 (password: $(cat password.txt))"
elif [[ "$corebench" == "corebenchx" ]]; then
  printf "Container (coreutils): "
  docker run -dt --name corebenchx0 -v $(pwd):/shared -p 5901:5900 --dns 8.8.8.8 --dns 8.8.4.4 mboehme/corebenchx | cut -c-12
  echo "Now use VNCViewer to access $(boot2docker ip):5901 (password: $(cat password.txt))"
else
  echo "Unknown: $corebench. Please use 'corebench' or 'corebenchx'."
  exit 1
fi
echo
echo Note: Once the container is removed or broken, any temporary data will be lost!
echo Use the '/shared'-folder for scripts and data which you would like to keep.  
echo
echo Connecting..
if [ -z "$2" ]; then 
  docker exec -it $(docker ps | grep "mboehme/$corebench " | cut -c-12) bash
else 
  echo "$2" | docker exec -i $(docker ps | grep "mboehme/$corebench " | cut -c-12) bash 
  exit_code=$?
fi
exit $exit_code