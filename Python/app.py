import os

from flask import Flask, request, jsonify
from firebase_admin import credentials, firestore, initialize_app
import firebase_admin

app = Flask(__name__)

cred = credentials.ApplicationDefault()
firebase_admin.initialize_app(cred)
db = firestore.client()

@app.route('/hello')
def hello():
    return 'Hello'

@app.route('/query_firestore', methods=['GET', 'POST'])
def query_firestore():    
    testing = db.collection('testing_data')
    docs = testing.stream()

    response = []
    for doc in docs:
        response.append(doc.to_dict())
        
    return jsonify(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)