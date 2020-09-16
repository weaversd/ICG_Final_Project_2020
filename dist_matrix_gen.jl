#using packages
using CSV
using BioSequences
using BioAlignments
using DataFrames
using FASTX

#read Ali substitution matrix into a DataFrames


ali_df = CSV.read("data_files/ali_submat.csv")
n = nrow(ali_df)

#copy dataframe scale up and round so the values can be converted to integers
ali_df_100 = copy(ali_df)
for i in 1:n
    for j in 1:n
        ali_df_100[i,j] =  round(ali_df[i,j]*100, digits = 0)
    end
end
 


#copy PAM70 substitution matrix to new variable to use as a template for Ali matrix
ALI_SUBMAT = copy(PAM70)

#fill new submat based on df of Ali matrix, needs to use integers
for i in 1:n
    for j in 1:n
        ALI_SUBMAT[i-1, j-1] = ali_df_100[i,j]
    end
end

#create array to hold each repeat and one to hold each identifier
repeat_matrix = LongSequence{AminoAcidAlphabet}[]
identifier_matrix = String[]
description_matrix = String[]

#write sequence and identifier to respective arrays
open(FASTA.Reader, "data_files/MUC16_repeats_64.fasta") do reader
    for record in reader
        push!(repeat_matrix, sequence(record))
        push!(description_matrix, description(record))
        push!(identifier_matrix, identifier(record))
    end
end


#create cost model
costmodel = CostModel(ALI_SUBMAT, insertion = 150, deletion = 150)

#count number of repeats
n = length(repeat_matrix)


#create DataFrame to hold distances
distance_array = fill(0.0, (n, n))
distance_matrix = convert(DataFrame, distance_array)
rename!(distance_matrix, identifier_matrix)

for i in 1:n
    for j in 1:n
        alignment = distance(pairalign(EditDistance(), repeat_matrix[i], repeat_matrix[j], costmodel))
        distance_matrix[i,j] = alignment
    end
end



#make an array of each letter
letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "AA", "BB", "CC", "DD", "EE", "FF", "GG", "HH", "II", "JJ", "KK", "LL", "MM", "NN", "OO", "PP", "QQ", "RR", "SS", "TT", "UU", "VV", "WW", "XX", "YY", 
"ZZ", "AAA", "BBB", "CCC", "DDD", "EEE", "FFF", "GGG", "HHH", "III", "JJJ", "KKK", "LLL"]
rename!(distance_matrix, letters)