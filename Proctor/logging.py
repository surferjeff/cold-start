import json
import csv

def convert_to_csv(input_file, output_file):
    # Open the input file for reading
    with open(input_file, 'r') as f:
        data = json.load(f)

    # Open the output CSV file for writing
    with open(output_file, 'w', newline='') as csvfile:
        # Define CSV writer
        csv_writer = csv.writer(csvfile)

        # Write CSV header
        csv_writer.writerow(['COLD_RESULT', 'URL', 'Response Time'])

        # Iterate over each log entry
        for entry in data:
            # Extract the textPayload
            text_payload = entry['textPayload']
            
            # Split the textPayload into components
            parts = text_payload.split()
            
            # Extract relevant information
            cold_result = parts[0]
            url = parts[2]
            response_time = parts[-1].strip('ms.')

            # Write to CSV
            csv_writer.writerow([cold_result, url, response_time])

if __name__ == "__main__":
    input_file = 'logging.txt'
    output_file = 'logging.csv'
    convert_to_csv(input_file, output_file)
    print("CSV file created successfully.")
