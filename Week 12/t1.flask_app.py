from flask import Flask
app = Flask(__name__)

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def hello_world(path):
    return 'Hello World! at %s' %path

if __name__=='__main__':
    app.run('0.0.0.0',port=5000)
