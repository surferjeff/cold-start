package com.example;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.FirestoreOptions;
import io.javalin.Javalin;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;

public class App {
    private static int counter = 0;
    private static Firestore db;

    public static void main(String[] args) {
        // Initialize Firebase Admin SDK
        try {
            GoogleCredentials credentials = GoogleCredentials.getApplicationDefault();
            FirestoreOptions options = FirestoreOptions.newBuilder().setCredentials(credentials).build();
            db = options.getService();
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Create Javalin app
        Javalin app = Javalin.create().start(7000);

        // Define routes
        app.get("/hello", ctx -> {
            counter++;
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("counter", counter);
            jsonResponse.put("message", "Hello, World!");
            ctx.result(jsonResponse.toString());
        });

        // app.get("/query_firestore", ctx -> {
        //     // Increment the counter
        //     counter++;

        //     // Collect data from Firestore
        //     JSONArray response = new JSONArray();
        //     db.collection("testing_data").listDocuments().forEach(documentReference -> {
        //         DocumentSnapshot documentSnapshot = documentReference.get().get();
        //         response.put(documentSnapshot.getData());
        //     });

        //     // Return response
        //     JSONObject jsonResponse = new JSONObject();
        //     jsonResponse.put("docs", response);
        //     jsonResponse.put("requestCount", counter);
        //     ctx.json(jsonResponse);
        // });
    }
}