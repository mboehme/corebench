docker run -dt --name corebench0 -v $(pwd):/shared -p 5900:5900 --dns 8.8.8.8 --dns 8.8.4.4 mboehme/corebench
echo Now use a VNCViewer to access $(boot2docker ip):5900
echo 
echo
echo Note: Once the container removed or broken, any temporary data will be lost!
echo Use the '/shared'-folder for scripts and data which you would like to keep.  
