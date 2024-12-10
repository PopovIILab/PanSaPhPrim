import sys
import os
from Bio import SeqIO

def filter_sequences(input_file, output_file):
    with open(input_file, "r") as infile, open(output_file, "w") as outfile:
        # Filter sequences based on the conditions
        filtered_seqs = (
            seq for seq in SeqIO.parse(infile, "fasta") 
            if ("Salmonella phage" in seq.description or "Salmonella Phage" in seq.description) and "complete genome" in seq.description
        )
        # Write the filtered sequences to the output file
        SeqIO.write(filtered_seqs, outfile, "fasta")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: %run filter_seqs.py <input_file> <output_file>")
    else:
        input_file = sys.argv[1]
        output_dir = sys.argv[2]
        filter_sequences(input_file, output_dir)