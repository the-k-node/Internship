>Task 1

* Download and install flask using `pip` package manager,
    ```sh
    $ pip install flask
    ```

* Install `docker`,
    ```sh
    $ apt install docker.io
    ```

* Create a normal 'hello world' application where it displays a text `Hello World!` for any request.

* We need a directory structure for creating a required docker image for running flask app.

* Make a new file `python_cont` (or any name of choice), and create the main application file `app.py` and enter the following python code,
    ```py
    @app.route('/', defaults={'path': ''})
    @app.route('/<path:path>')
    def hello_world(path):
        return 'Hello World! at %s' %path
    ```
    this makes sure to redirect any request to the main root `/` and prints out the extra request information along with 'Hello World'.

* Create a `requirements.txt` file and enter the following to make use of it while creating the docker image,
    ```
    Flask==2.0.0
    ```

* Create the main [`Dockerfile`](https://github.com/alwaysiamkk/Internship/blob/main/Week%2012/T1/Dockerfile) to build the python image we wanted with certain lines of code to
    * install python base image,
    * create a main working directory `/app`
    * copy requirements.txt file,
    * install the requirements using `pip`,
    * copy all files from current working directory into image,
    * run the application and add `--host=0.0.0.0` to be able to access from outside the image.

* Now, come out of the directory leaving `python_cont` directory with files,
    1. app.py
    2. requirements.txt
    3. Dockerfile

* Build the image using,
    ```sh
    $ docker build -tpython_cont python_cont
    ```
    `-t` is for mentioning the repo name, and `python_cont` is the directory name where all our files are located in.

* Verify the created image using,
    ```sh
    $ docker images
    ```

* Run the application from docker container image using,
    ```sh
    $ docker run -d -p 80:5000 python_cont
    ```
    `-d` makes the application to be run without showing the log, `-p` is for specifying which port of the host does image uses to provide access for application, `python_cont` is the tag, repo used.

* Verify the whole setup by accessing `<bridgeIP>:80` on browser, which should show `Hello World at` text.
