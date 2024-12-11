import sys
import os
from Bio import SeqIO

def split_fasta(input_file, output_dir):
    # Create output directory if it doesn't exist
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    # Parse the input FASTA file and write each sequence to a separate file
    for record in SeqIO.parse(input_file, "fasta"):
        output_file = os.path.join(output_dir, f"{record.id}.fasta")
        with open(output_file, "w") as f:
            SeqIO.write(record, f, "fasta")
    print(f"Separated fasta files are written to {output_dir} directory")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: %run sepfasta.py <input_file> <output_dir>")
    else:
        input_file = sys.argv[1]
        output_dir = sys.argv[2]
        split_fasta(input_file, output_dir)
