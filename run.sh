if [ $(docker images | grep -c "CREATED") -eq 0 ]; then
  echo "Run boot2docker to set up docker environment."
  exit 1
fi
if [ $(docker images | grep -c "mboehme/corebench") -eq 0 ]; then
  echo "Execute 'docker build -t mboehme/corebench .' or tag the image as 'mboehme/corebench'".
  exit 1
fi
if [ $(docker ps | grep -c "mboehme/corebench") -ne 0 ]; then
  echo "An instance of 'mboehme/corebench' is already running ($(docker ps | grep mboehme/corebench | cut -c-12))"
  echo "Connecting .."
  docker exec -it $(docker ps | grep mboehme/corebench | cut -c-12) bash
  exit 1
fi
printf "Container: "
docker run -dt --name corebench0 -v $(pwd):/shared -p 5900:5900 --dns 8.8.8.8 --dns 8.8.4.4 mboehme/corebench | cut -c-12
echo Now use a VNCViewer to access $(boot2docker ip):5900 (password: $(cat password.txt))
echo 
echo
echo Note: Once the container removed or broken, any temporary data will be lost!
echo Use the '/shared'-folder for scripts and data which you would like to keep.  
echo
echo Connecting..
docker exec -it $(docker ps | grep mboehme/corebench | cut -c-12) bash
