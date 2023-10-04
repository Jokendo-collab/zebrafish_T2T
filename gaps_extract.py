from Bio import SeqIO

# Input and output file paths
input_file = "REF.fasta"
output_file = "n_gaps.bed"

# Function to find N gap coordinates in a sequence
def find_n_gap_coordinates(sequence, seq_name):
    gap_coordinates = []
    gap_start = None

    for i, base in enumerate(sequence):
        if base.upper() == "N":
            if gap_start is None:
                gap_start = i
        elif gap_start is not None:
            gap_coordinates.append((gap_start, i - 1))
            gap_start = None

    # Add the last gap if it exists
    if gap_start is not None:
        gap_coordinates.append((gap_start, len(sequence) - 1))

    # Convert coordinates to BED format
    bed_records = []
    for start, end in gap_coordinates:
        bed_records.append(f"{seq_name}\t{start}\t{end + 1}")

    return bed_records

# Open input and output files
with open(output_file, "w") as output_handle:
    for record in SeqIO.parse(input_file, "fasta"):
        seq_name = record.id
        sequence = str(record.seq)
        
        # Find N gap coordinates in the sequence
        n_gap_coordinates = find_n_gap_coordinates(sequence, seq_name)

        # Write the coordinates to the BED file
        for coord in n_gap_coordinates:
            output_handle.write(f"{coord}\n")

print(f"N gap coordinates extracted and saved to {output_file}")

