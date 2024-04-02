package com.example;

import com.google.auth.oauth2.GoogleCredentials;
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

    public static void main(String[] args) {
        // Initialize Firebase Admin SDK
        try {
            FirebaseOptions options = new FirebaseOptions.Builder()
                .setCredentials(GoogleCredentials.getApplicationDefault())
                .build();
            FirebaseApp.initializeApp(options);
            db = FirestoreOptions.getDefaultInstance().getService();
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Create Javalin app
        Javalin app = Javalin.create().start(8080);

        // Define routes
        app.get("/hello", ctx -> {
            counter++;
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("counter", counter);
            jsonResponse.put("message", "Hello, World!");
            ctx.result(jsonResponse.toString());
        });

        app.get("/query_firestore", ctx -> {
            // Increment the counter
            counter++;
        
            // Query Firestore
            JSONArray response = new JSONArray();
            try {
                db.collection("testing-data").listDocuments().forEach(documentReference -> {
                    try {
                        DocumentSnapshot documentSnapshot = documentReference.get().get();
                        response.put(documentSnapshot.getData());
                    } catch (InterruptedException | ExecutionException e) {
                        e.printStackTrace();
                        ctx.status(500).result("Error retrieving Firestore data");
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
                ctx.status(500).result("Error querying Firestore");
            }
        
            // Send response
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("counter", counter);
            jsonResponse.put("data", response);
            ctx.result(jsonResponse.toString());
        });
        
    }
}