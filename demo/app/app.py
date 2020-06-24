from flask import Flask, render_template, send_file, url_for
app = Flask(__name__)


@app.route('/')
def index():
    return render_template('index.html')

@app.route('/pictureRecognition.out.wasm')
def fetch_wasm_pictureRecognition():
    return send_file('static/pictureRecognition.out.wasm', mimetype='application/wasm')

@app.route('/pictureRecognition.out.data')
def fetch_data_pictureRecognition():
    return send_file('static/pictureRecognition.out.data', mimetype='application/octet-stream')




@app.route('/segment.out.wasm')
def fetch_wasm_segment():
    return send_file('static/segment.out.wasm', mimetype='application/wasm')

@app.route('/segment.out.data')
def fetch_data_segment():
    return send_file('static/segment.out.data', mimetype='application/octet-stream')




# @app.route('/multiPose.out.wasm')
# def fetch_wasm_multiPose():
#     return send_file('static/multiPose.out.wasm', mimetype='application/wasm')

# @app.route('/multiPose.out.data')
# def fetch_data_multiPose():
#     return send_file('static/multiPose.out.data', mimetype='application/octet-stream')