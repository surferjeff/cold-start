package main

import (
	"context"
	"encoding/json"
	"log"
	"net/http"
	"os/exec"
	"strings"
	"sync"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
	"google.golang.org/api/iterator"
)

var (
	counter         int
	firestoreClient *firestore.Client
	mu              sync.Mutex
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
		"message":      "Hello, World!",
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
		"docs":          response,
		"requestCount": counter,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(finalResponse)
}

func main() {
	port := ":8080"
	if isPortInUse(port) {
		log.Println("Port", port, "is in use. Attempting to terminate the process using the port...")
		if err := killProcessUsingPort(port); err != nil {
			log.Fatalf("Failed to kill process using port %s: %v", port, err)
		}
		log.Println("Process using port", port, "terminated successfully")
	}

	http.HandleFunc("/hello", helloHandler)
	http.HandleFunc("/query_firestore", queryFirestoreHandler)

	log.Printf("Starting server on port %s\n", port)
	log.Fatal(http.ListenAndServe(port, nil))
}

// isPortInUse checks if the specified port is already in use.
func isPortInUse(port string) bool {
	out, err := exec.Command("netstat", "-tuln").Output()
	if err != nil {
		log.Fatalf("Failed to execute netstat command: %v", err)
	}
	return strings.Contains(string(out), port)
}

// killProcessUsingPort terminates the process using the specified port.
func killProcessUsingPort(port string) error {
	out, err := exec.Command("lsof", "-t", "-i", port).Output()
	if err != nil {
		return err
	}
	pid := strings.TrimSpace(string(out))
	if pid == "" {
		return nil // No process using the port
	}
	return exec.Command("kill", pid).Run()
}
