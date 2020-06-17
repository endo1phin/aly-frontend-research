from flask import Flask, render_template
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'

@app.route('/picture_recognition')
def picture_recognition():
    return render_template('picture_recognition.html')