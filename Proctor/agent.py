import os

from flask import Flask, request, jsonify
import proctor

app = Flask(__name__)

@app.route('/hello')
def hello():
    # call proctor function
    proctor.fetchAndLog("https://coldstart-python-ktbkw3cp2a-wl.a.run.app/hello")
    proctor.fetchAndLog("https://coldstart-csharp-ktbkw3cp2a-wl.a.run.app/hello")
    proctor.fetchAndLog("https://coldstart-go-ktbkw3cp2a-wl.a.run.app/hello")
    proctor.fetchAndLog("https://coldstart-java-ktbkw3cp2a-wl.a.run.app/hello")
    proctor.fetchAndLog("https://coldstart-nodejs-ktbkw3cp2a-wl.a.run.app/hello")
    return "Done"

@app.route('/query_firestore')
def query_firestore():
    proctor.fetchAndLog("https://coldstart-python-ktbkw3cp2a-wl.a.run.app/query_firestore")
    proctor.fetchAndLog("https://coldstart-csharp-ktbkw3cp2a-wl.a.run.app/query_firestore")
    proctor.fetchAndLog("https://coldstart-go-ktbkw3cp2a-wl.a.run.app/query_firestore")
    proctor.fetchAndLog("https://coldstart-java-ktbkw3cp2a-wl.a.run.app/query_firestore")
    proctor.fetchAndLog("https://coldstart-nodejs-ktbkw3cp2a-wl.a.run.app/query_firestore")
    return "Done"
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)