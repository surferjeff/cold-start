Proctor fetches URLs from webservers running in Cloud Run and reports latency.

It must be able to distinguish a response from a webserver that has already
running from a response from a web server that just cold started.
You can tailor the responses from the webservers to make it easy for Proctor
to identify a cold start.

## Example runs with explanations.

A successful run.

```
$ proctor https://xyzpdqbsl.app/query_firestore
result 200 from https://www.yahoo.com/ in 500ms.
COLD_RESULT 200 https://xyzpdqbsl.app/query_firestore in 700ms.
```

Proctor always fetches www.yahoo.com once first to warm up its own HTTP stack.

----

A run where the fetch hit an already-running web server.

```
$ proctor https://xyzpdqbsl.app/query_firestore
result 200 from https://www.yahoo.com/ in 500ms.
warm_result 200 https://xyzpdqbsl.app/query_firestore in 600ms.
```

---

A run with bad response code from www.yahoo.com.

```
$ proctor https://xyzpdqbsl.app/query_firestore
bad_result 502 from https://www.yahoo.com/ in 500ms.
```

Notice it doesn't even try the call to Cloud Run if the first fetch fails.


---

A run with bad response code from Cloud Run

```
$ proctor https://xyzpdqbsl.app/query_firestore
result 200 from https://www.yahoo.com/ in 500ms.
bad_result 404 https://xyzpdqbsl.app/query_firestore in 600ms.
```
