# Script considerations:
# Nucleotide (nuc) query sequences are more subject to sequence variation and evolutionary divergence
# Amino acid (aa) sequences are more conserved across species and can be robust against sequence variation
# Because we are interested in the metabolite production we will focus on the functional elements of these proteins
# Based on the goal of this project, you will need aa protein query sequences to compare against a nucl db (from your subject genome) using tBLASTn
# Debugging echos have been scattered throughout to ensure code is working properly

# What you need to do before running the following script:
# Step 1: download protein (aa) sequences for all genes involved in the production of your metabolite of interest from UniProt and place in a folder labelled with the name-of-metabolite_BGC
# Step 2: install blast (for my unity users: module load blast-plus/2.13.0+py3.8.12)

#!/usr/bin/env bash

# Check if correct number of arguments provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <genome_fasta_file> <protein_sequences_folder> <e_value_cutoff>"
    exit 1
fi

# Assign input arguments to variables
genome_fasta=$1
protein_folder=$2
e_value_cutoff=$3 # This is to make filtering results go quicker, because a lower e-value cutoff will limit the initial results
# I recommend using an e-value cut-off of 0.0001

# Extract the name of the folder from the protein sequences path to name the output file
folder_name=$(basename "$protein_folder")
output_csv="${folder_name}_tblastn_results.csv"

# Name of the database
db_name="${genome_fasta%.*}_db"

echo "Creating BLAST database..."
# Create a BLAST database from the nucleotide genome sequence
makeblastdb -in "$genome_fasta" -title "$db_name" -dbtype nucl -out "$db_name" -parse_seqids
echo "Database ${db_name} created successfully."

# Check if the protein folder exists and is a directory
if [ ! -d "$protein_folder" ]; then
    echo "Error: Protein folder '$protein_folder' does not exist."
    exit 2
fi

echo "Initializing output file: $output_csv"
# Add a header to the CSV file
echo "query_seq_ID,subject_seq_ID,percent_identical_matches,align_len,mismatch,gap_open,query_start,query_stop,subject_start,subject_end,e_value,bit_score" > "$output_csv"

echo "Starting BLAST searches..."
# Loop through each protein sequence file in the folder
for protein_seq in "$protein_folder"/*.fasta; do
    echo "Processing file: $(basename "$protein_seq")"
    
    # Debug: Check number of sequences in the fasta file
    seq_count=$(grep -c "^>" "$protein_seq")
    if [ "$seq_count" -ne 1 ]; then
        echo "Warning: More than one sequence found in $protein_seq. Only the first will be processed."
    fi

    # Run tBLASTn with the protein sequence against the nucleotide database
    tblastn -query "$protein_seq" -db "$db_name" \
            -evalue "$e_value_cutoff" \
            -max_target_seqs 1 \
            -max_hsps 1 \
            -outfmt "10 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore" \
            >> "$output_csv"
    echo "Results for $(basename "$protein_seq") appended to $output_csv"
done

echo "All BLAST processes complete. All results are stored in $output_csv."

# Usage (what you need to enter on command line after saving your script):
# chmod +x tblastn_bgc.sh # this is just an example name, but feel free to use what makes most sense to you
# ./tblastn_bgc.sh <path/to/your_genome.fasta> <path/to/your_protein_sequences_folder> <e_value_cutoff>

