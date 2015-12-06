# CoREBench Dockerfile
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
docker pull mboehme/corebench
```
Alternatively, you can build manually (takes several hours!)
```
git clone "https://github.com/mboehme/corebench.git"
cd corebench
docker build -t mboehme/corebench .
```

## Usage
1. Execute `./run.sh` to start a new docker container as instance of mboehme/corebench with a shared directory.
2. Connect to docker container 
  * **Desktop**. Install [VNC] [VNC] and connect to `<docker-ip>:5900` (password: corebench).
  * **Terminal**. Execute `docker exec -it corebench0 bash`.
3. Find scripts in directory `/root/corebench` and repository in director `/root/corerepo`.
4. Execute `./executeTests.sh test-all [core|find|grep|make|all] /root/corerepo` to execute the test cases for each regression error
  * before the bug was introduced (should pass),
  * after the bug was introduced (should fail),
  * before the bug was fixed (should fail), and
  * after the bug was fixed (should pass)
5. Implement `analysis.sh` as your analysis script.
6. Execute `./executeTests.sh analyze-all [core|find|grep|make|all] /root/corerepo` to execute you analysis in the manner given in Point 4.

**Note:** Use the folder `/shared` for scripts and other data you would like to maintain. Note that all other data is lost in the event that the container is shut down.




[Make]: <http://www.gnu.org/software/make/>
[Grep]: <http://www.gnu.org/software/grep/>
[Find]: <http://www.gnu.org/software/findutils/>
[Core]: <http://www.gnu.org/software/coreutils/>
[Docker]: <http://docs.docker.com/engine/installation/>
[VNC]: <https://www.realvnc.com/download/viewer/>
