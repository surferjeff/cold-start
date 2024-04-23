import os

from flask import Flask, request, jsonify
from firebase_admin import credentials, firestore, initialize_app
import firebase_admin

app = Flask(__name__)

counter = 0

cred = credentials.ApplicationDefault()
firebase_admin.initialize_app(cred)
db = firestore.client()

@app.route('/hello')
def hello():
    global counter
    counter += 1

    return jsonify({
        "message": "Hello",
        "requestCount": counter
    })

@app.route('/query_firestore', methods=['GET', 'POST'])
def query_firestore():
    
    # collect the testing_data from Firestore
    global counter
    testing = db.collection('testing_data')
    docs = testing.stream()
    
    # increments the counter everytime the url is being called
    # to see if it is a cold start or a warm start
    counter += 1
    
    response = []
    for doc in docs:
        response.append(doc.to_dict())
        
    # return both the response and the counter
    return jsonify({
        'docs': response,
        'requestCount': counter
    })

if __name__ == '__main__':
    from waitress import serve
    serve(app, host='0.0.0.0', port=8080)
    
    # Google Cloud Run link: https://python-cold-start-763iagzqaq-wl.a.run.app