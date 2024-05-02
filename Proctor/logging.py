import json
import csv

def convert_to_csv(input_file, output_file):
    # Open the input file for reading
    with open(input_file, 'r') as f:
        data = json.load(f)

    # Dictionary to store entries for each language
    language_entries = {}

    # Iterate over each log entry
    for entry in data:
        # Extract the textPayload
        text_payload = entry['textPayload']
                        
        # Split the textPayload into components
        parts = text_payload.split()
        
        # Extract relevant information
        url = parts[2]
        response_time = parts[-1].strip('ms.')

        # Find the language for the current URL
        language = None
        if "python" in url:
            language = "python"
        elif "java" in url:
            language = "java"
        elif "go" in url:
            language = "go"
        elif "nodejs" in url:
            language = "nodejs"
        elif "csharp" in url:
            language = "csharp"
        
        # Add entry to language_entries dictionary
        if language not in language_entries:
            language_entries[language] = []
        language_entries[language].append(response_time)

    # Open the output CSV file for writing
    with open(output_file, 'w', newline='') as csvfile:
        # Define CSV writer
        csv_writer = csv.writer(csvfile)

        # Write CSV header
        csv_writer.writerow(['Language', 'Response Time'])

        # Iterate over sorted keys of language_entries dictionary
        for language in sorted(language_entries.keys()):
            # Write entries for each language
            for response_time in language_entries[language]:
                csv_writer.writerow([language, response_time])

if __name__ == "__main__":
    input_file = 'loggingHello.txt'
    output_file = 'loggingHello.csv'
    convert_to_csv(input_file, output_file)
    print("CSV file created successfully.")
