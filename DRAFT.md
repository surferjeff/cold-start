# Cold Start Chronicles: A Millisecond View of Programming Languages on Google Cloud Run

## Introduction
In the dynamic landscape of serverless computing, Google Cloud Run takes center stage as a versatile platform for deploying and running containerized applications. A critical performance metric in serverless environments is the cold start time, measuring the duration it takes for a container to become responsive after activation. This blog post examines the cold start times of popular programming languages—C#, Node.js, Python, Java, and Go—when running on Google Cloud Run.

## Understanding Cold Start Times
Cold start times are pivotal for serverless applications, particularly those with sporadic or unpredictable workloads. When a service remains inactive for a certain period, the cloud provider may scale down allocated resources to save costs. Upon receiving a new request, the platform must initiate a new container, leading to a delay known as the cold start time.

## Comparative Analysis

**TODO(taiga)**: Replace the numbers in these tables with real measured data.

### Docker Image Size

| Programming Language | Docker Image Size in MBs |
|----------------------|-------------------------------|
| C#                   | 150                           |
| Node.js              | 80                            |
| Python               | 120                           |
| Java                 | 200                           |
| Go                   | 60                            |

### Cold Fetch /hello

All times are in milliseconds.

| Programming Language | Average | Median | 95%ile |  Sample Size |
|----------------------|-------------------------------|-|-|-|
| C#                   | 150                           |99|200|100
| Node.js              | 80                            |99|200|100
| Python               | 120                           |99|200|100
| Java                 | 200                           |99|200|100
| Go                   | 60                            |99|200|100

### Cold Fetch /query_firestore

All times are in milliseconds.

| Programming Language | Average | Median | 95%ile |  Sample Size |
|----------------------|-------------------------------|-|-|-|
| C#                   | 150                           |99|200|100
| Node.js              | 80                            |99|200|100
| Python               | 120                           |99|200|100
| Java                 | 200                           |99|200|100
| Go                   | 60                            |99|200|100
