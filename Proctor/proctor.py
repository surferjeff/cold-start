import requests
import time
import sys

def fetch_url(url):
    try:
        response = requests.get(url)
        return response.status_code, response.json()  # Return status code and response content
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")
        sys.exit(1)

def proctor(url):
    # Fetch from www.yahoo.com to warm up HTTP stack
    yahoo_status, yahoo_latency = fetch_url("https://www.yahoo.com/")
    print(f"result {yahoo_status} from https://www.yahoo.com/ in {yahoo_latency}ms.")

    # Fetch from the provided URL
    start_time = time.time()
    status_code, response_content = fetch_url(url)
    total_latency = int((time.time() - start_time) * 1000)

    if status_code == 200:
        return status_code, response_content, total_latency
    else:
        print(f"bad_result {status_code} {url} in {total_latency}ms.")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python proctor.py <url>")
        sys.exit(1)

    url = sys.argv[1]
    
    try:
        response = requests.get(url)
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")
        sys.exit(1)
    
    if response.status_code == 200:
        request_count = response.json()['requestCount']
        if (request_count == 1):
            print(f"COLD_RESULT {response.status_code} {url} in {response.elapsed.microseconds}ms.")
        else:
            print(f"WARM_RESULT {response.status_code} {url} in {response.elapsed.microseconds}ms.")
    else:
        sys.exit(1)
