# CoREBench Dockerfile [![alt text](https://travis-ci.org/mboehme/corebench.svg?branch=master "Test Results corebench")](https://travis-ci.org/mboehme/corebench)
Actual Regression Errors for Software Debugging and Repair Research.  
More information at http://www.comp.nus.edu.sg/~release/corebench/.


The dockerfile is 
* based on the official Ubuntu 14.04 docker image,
* adds LXDE Desktop environment,
* adds TightVNC server,
* resolves all dependencies of coreutils, findutils, grep, and make,
* installs the revisions of 70 regression errors,
  * after the bug was introduced, and
  * after the bug was fixed
* executes the test cases for each regression error
  * before the bug was introduced (should pass),
  * after the bug was introduced (should fail),
  * before the bug was fixed (should fail), and
  * after the bug was fixed (should pass)

## Installation
Download and install [Docker] [Docker]. Then execute
```
git clone https://github.com/mboehme/corebench.git #Gives you run.sh
docker pull mboehme/corebench                      #Installs container w/ 48 errors in find, grep, and make
docker pull mboehme/corebenchx                     #Installs container w/ 22 errors in coreutils
```
Alternatively, you can build manually (takes several hours!)
```
# Build container for errors in find, grep, and make
git clone https://github.com/mboehme/corebench.git
cd corebench
docker build -t mboehme/corebench .

# Build container for errors in coreutils
git clone https://github.com/mboehme/corebenchx.git
cd corebenchx
docker build -t mboehme/corebenchx .
```

## Usage
1. Execute `./run.sh` to start a new docker container with a shared directory.
2. Connect to docker container 
  * **Desktop**. Install [VNC] [VNC] and connect to `<docker-ip>:5900` or `<docker-ip>:5901` (password: corebench).
  * **Terminal**. Execute `./run.sh corebench` or `./run.sh corebenchx`.
3. Find scripts in directory `/root/corebench` and repository in directory `/root/corerepo`.
4. Execute `./executeTests.sh test-all [core|find|grep|make] /root/corerepo` to execute the test for each error
  * before the bug was introduced (should pass),
  * after the bug was introduced (should fail),
  * before the bug was fixed (should fail), and
  * after the bug was fixed (should pass)
5. Implement `analysis.sh` as your analysis script.
6. Execute `./executeTests.sh analyze-all [core|find|grep|make] /root/corerepo` to execute your analysis in the manner given in Point 4.

**Note:** Use the folder `/shared` for scripts and other data you would like to maintain. All other data is lost in the event that the container is shut down. For instance, you can copy `/root/corebench` to `/shared`, modify `analysis.sh` and execute `./executeTests.sh` from `/shared`.


[Make]: <http://www.gnu.org/software/make/>
[Grep]: <http://www.gnu.org/software/grep/>
[Find]: <http://www.gnu.org/software/findutils/>
[Core]: <http://www.gnu.org/software/coreutils/>
[Docker]: <http://docs.docker.com/engine/installation/>
[VNC]: <https://www.realvnc.com/download/viewer/>
