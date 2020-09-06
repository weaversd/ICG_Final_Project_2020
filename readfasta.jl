#!/usr bin/env julia

using FASTX
using BioSequences


#create variable for the sequence
muc16_seq = ""

#read the fasta file
r = open(FASTA.Reader, "Q8WXI7_full.fasta")

#store sequence as Biosequence variable
for record in r
	global muc16_seq = sequence(record)
end

#print sequence to check if it worked
#println(typeof(muc16_seq))

#convert to string
muc16_seq_str = convert(String, muc16_seq)


open("MUC16_seq_str.txt", "w") do f
	write(f, muc16_seq_str)
end
