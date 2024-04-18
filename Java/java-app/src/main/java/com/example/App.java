package com.example;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.FirestoreOptions;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

import io.javalin.Javalin;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.concurrent.ExecutionException;

public class App {
    private static int counter = 0;
    private static Firestore db;

    public static void main(String[] args) throws IOException, ExecutionException, InterruptedException{
        // Initialize Firebase Admin SDK
        
        FirebaseOptions options = new FirebaseOptions.Builder()
            .setCredentials(GoogleCredentials.getApplicationDefault())
            .build();
        FirebaseApp.initializeApp(options);
        db = FirestoreOptions.getDefaultInstance().getService();
        
        // Create Javalin app
        Javalin app = Javalin.create();

        // Define routes
        app.get("/hello", ctx -> {
            counter++;
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("requestCount", counter);
            jsonResponse.put("message", "Hello, World!");
            ctx.result(jsonResponse.toString());
        });

        app.get("/query_firestore", ctx -> {
            // Increment the counter
            counter++;
        
            // Query Firestore
            JSONArray response = new JSONArray();
            for (DocumentReference docRef : db.collection("testing-data").listDocuments()) {
                DocumentSnapshot documentSnapshot = docRef.get().get();
                response.put(documentSnapshot.getData());
            }
        
            // Send response
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("requestCount", counter);
            jsonResponse.put("data", response);
            ctx.result(jsonResponse.toString());
        });
        
        app.start(8080);
    }
}