import express, { Express, Request, Response } from "express";
const { initializeApp, applicationDefault, cert } = require('firebase-admin/app');
const { getFirestore, Timestamp, FieldValue, Filter } = require('firebase-admin/firestore');

const app: Express = express();
const port = process.env.PORT || 8080;

initializeApp({
  credential: applicationDefault()
});

const db = getFirestore();

let counter = 0;

// print out all the documents in the collection
app.get("/query_firestore", async (req: Request, res: Response) => {
  try {
    const snapshot = await db.collection('testing-data').get();
    const users = snapshot.docs.map((doc: { data: () => any; }) => doc.data());
    counter++;
    res.json({
      docs: users,
      requestCount: counter
    });
  } catch (error) {
    console.error("Error fetching data from Firestore:", error);
    res.status(500).json({ error: "Failed to fetch data from Firestore" });
  }
});

app.get("/hello", (req: Request, res: Response) => {
  counter++;
  res.json({
    message: "Hello World!",
    requestCount: counter
  });
});

app.listen(port, () => {
  console.log(`[server]: Server is running at http://localhost:${port}`);
});