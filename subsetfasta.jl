#!/usr bin/env julia

using FASTX
using BioSequences
using CSV
using DataFrames

#import sequence from text file
Muc16_txt_string = read("data_files/MUC16_seq_str.txt", String)

#convert to BioSequence
Muc16_aa_sequence = LongSequence{AminoAcidAlphabet}(Muc16_txt_string)

#import the indexes of each repeat domain
index_df = CSV.read("data_files/MUC16_repeat_index_64.txt", header = 0)

n_repeat = nrow(index_df)
println("Number of Repeats:")
println(n_repeat)

#create matrix of empty aa BioSequences, length of the number of repeats
repeat_matrix = fill(aa"", n_repeat)

#put each repeat into a new position in the array
for i in 1:n_repeat
    global repeat_matrix[i,1] = Muc16_aa_sequence[Int(index_df[i,1]):Int(index_df[i,2])]
end

#count the length of each repeat
length_array = fill(1, n_repeat)

for i in 1:n_repeat
    global length_array[i] = length(repeat_matrix[i,1])
end

#create empty string matrix
title_matrix = fill("", n_repeat)

#fill title matrix with repeat numbers 
for i in 1:n_repeat
    global title_matrix[i] = string("MUC16 Repeat Domain number ", i)
end

#Write each aa repeat sequence to a record in a fasta file
open(FASTA.Writer, "data_files/MUC16_repeats_64.fasta") do writer
    for i in 1:n_repeat
        write(writer, FASTA.Record(string(i, " - ", length_array[i], " Residues"), title_matrix[i], repeat_matrix[i,1]))
    end
end

println("Individual repeat sequences saved to fasta file:")
println("MUC16_repeats_64.fasta")