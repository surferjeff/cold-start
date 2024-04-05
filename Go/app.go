package main

import (
	"context"
	"encoding/json"
	"log"
	"net/http"
	"sync"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
	"google.golang.org/api/iterator"
)

var (
	counter int
	firestoreClient *firestore.Client
	mu sync.Mutex
)

func init() {
	ctx := context.Background()
	conf := &firebase.Config{ProjectID: "cold-start-417102"}
	app, err := firebase.NewApp(ctx, conf)
	if err != nil {
		log.Fatalf("Failed to create firebase app: %v", err)
	}

	firestoreClient, err = app.Firestore(ctx)
	if err != nil {
		log.Fatalf("Failed to create firestore client: %v", err)
	}
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	mu.Lock()
	counter++
	mu.Unlock()

	response := map[string]interface{}{
		"message": "Hello, World!",
		"requestCount": counter,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func queryFirestoreHandler(w http.ResponseWriter, r *http.Request) {
	mu.Lock()
	counter++
	mu.Unlock()

	var response []map[string]interface{}

	ctx := context.Background()
	iter := firestoreClient.Collection("testing_data").Documents(ctx)
	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}

		if err != nil {
			log.Fatalf("Failed to iterate firestore documents: %v", err)
			break
		}

		data := doc.Data()
		response = append(response, data)
	}

	finalResponse := map[string]interface{}{
		"docs": response,
		"requestCount": counter,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(finalResponse)
}

func main() {
	http.HandleFunc("/hello", helloHandler)
	http.HandleFunc("/query_firestore", queryFirestoreHandler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
