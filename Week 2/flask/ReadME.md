# Flask App

## :round_pushpin: Build a Docker Image

```
docker build -t flaskapp .
```

## :round_pushpin: Verify that your image shows in your image list:

```
docker image ls
```

## :round_pushpin: Run the docker container

```
docker run -d -p 5000:5000 flask-app
```
_"-p - The -p flag maps a port running inside the container to your host."_

The application will be accessible at ```http:127.0.0.1:5000```.

## :round_pushpin: Output

<img src="https://github.com/mehul-anshumali/Internship_PhonePe/blob/main/week2/flask/flask_main.png">

<img src="https://github.com/mehul-anshumali/Internship_PhonePe/blob/main/week2/flask/flask_record.png">

<img src="https://github.com/mehul-anshumali/Internship_PhonePe/blob/main/week2/flask/flask_host_record.png" >

# :round_pushpin: Modification Required:

**:point_right: The output of the bash script is not formatting in a better way while passing it from the main view ```app.py``` to templates.**

**:point_right: How to add the address or path of newly uplaoded file to script so from the new file the logs are parsed.**

