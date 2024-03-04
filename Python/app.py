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
    # just see if you are connected to the firestore
    testing = db.collection('testing-data')
    docs = testing.stream()
    for doc in docs:
        print(f'{doc.id} => {doc.to_dict()}')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)