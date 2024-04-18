import requests
import time
import sys

def fetch_url(url):
    """Fetches the provided URL and prints the status code and response content."""
    try:
        response = requests.get(url)
        return response.status_code, response.json()  # Return status code and response content
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")
        sys.exit(1)

def proctor(url):
    """Proctor function to measure the latency of the provided URL."""

    # Fetch from www.yahoo.com to warm up HTTP stack
    start_time_yahoo = time.time()
    yahoo_status = requests.get("https://www.yahoo.com")
    total_latency_yahoo = int((time.time() - start_time_yahoo) * 1000)
    print(f"result {yahoo_status.status_code} from https://www.yahoo.com/ in {total_latency_yahoo}ms.")

    # Fetch from the provided URL
    start_time = time.time()
    status_code, response_content = fetch_url(url)
    total_latency = int((time.time() - start_time) * 1000)

    if status_code == 200:
        return status_code, response_content, total_latency
    else:
        print(f"bad_result {status_code} {url} in {total_latency}ms.")
        
def fetchAndLog(url):
    # call proctor function
    status_code, response_content, total_latency = proctor(url)
    
    if(status_code == 200):
        request_count = response_content['requestCount']
        if (request_count == 1):
            print(f"COLD_RESULT {status_code} {url} in {total_latency}ms.")
        else:
            print(f"WARM_RESULT {status_code} {url} in {total_latency}ms.")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python proctor.py <url>")
        sys.exit(1)

    url = sys.argv[1]
    
    fetchAndLog(url)