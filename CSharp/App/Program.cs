using System.Collections.Generic;
using Google.Cloud.Firestore;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using System.Threading;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

FirestoreDb db = FirestoreDb.Create("cold-start-417102");
int counter = 0;

// Everytime the user hits the /hello endpoint, the counter will increment by 1
app.MapGet("/hello", () => {
    int newCounterValue = Interlocked.Increment(ref counter);
    return Results.Json(new {
        message = "Hello World",
        requestCount = newCounterValue
    });
});

// /query_firestore will return the data from Firestore 
app.MapGet("/query_firestore", async () => {
    int newCounterValue = Interlocked.Increment(ref counter);
    var firestoreData = await GetFirestoreDataAsync(db);
    return Results.Json(new {
        docs = firestoreData,
        requestCount = newCounterValue
    });
});

app.Run();

async Task<List<object>> GetFirestoreDataAsync(FirestoreDb db) {
    Query query = db.Collection("testing-data");
    QuerySnapshot snapshot = await query.GetSnapshotAsync();
    List<object> docs = new List<object>();
    foreach (DocumentSnapshot document in snapshot.Documents) {
        docs.Add(document.ToDictionary());
    }
    return docs;
}
