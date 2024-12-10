import csv
import sys
import os

def process_files(input_txt, input_tsv, output_tsv):
    """
    Processes two input files and creates a filtered TSV file.

    Args:
        input_txt (str): Path to the input TXT file.
        input_tsv (str): Path to the input TSV file.
        output_tsv (str): Path to the output TSV file.
    """
    def trim_identifier(identifier):
        """
        Trims the identifier to retain only the part before the 3rd dot.
        
        Args:
            identifier (str): The full identifier string.

        Returns:
            str: The trimmed identifier.
        """
        return ".".join(identifier.split(".")[:3])

    # Extract trimmed "gembase_name" values from the 2nd row of the TXT file
    with open(input_txt, "r") as txt_file:
        lines = txt_file.readlines()
        if len(lines) < 2:
            raise ValueError("The TXT file must have at least two rows.")
        first_row = lines[0].strip().split()
        gembase_names = {trim_identifier(item) for item in first_row}
    
    # Read the TSV file and filter rows
    with open(input_tsv, "r") as tsv_file:
        reader = csv.DictReader(tsv_file, delimiter="\t")
        filtered_rows = [
            row for row in reader if row["gembase_name"] in gembase_names
        ]
        fieldnames = reader.fieldnames  # Save header
    
    # Write the filtered rows to a new TSV file
    with open(output_tsv, "w", newline="") as out_file:
        writer = csv.DictWriter(out_file, fieldnames=fieldnames, delimiter="\t")
        writer.writeheader()
        writer.writerows(filtered_rows)

    print(f"Filtered file created: {output_tsv}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: %run process_LSTINFO.py <input_txt_file> <input_tsv_file> <output_tsv_file>")
    else:
        input_txt = sys.argv[1]
        input_tsv = sys.argv[2]
        output_tsv = sys.argv[3]
        process_files(input_txt, input_tsv, output_tsv)
