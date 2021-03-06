#Implementation of UPGMA in julia to output a Newick string

#modules required
using DataFrames
using CSV

#convert dataframe to "lower left"
#replace uppper values with missing
function add_missing(df::DataFrame)

    #length of dataframe
    n = nrow(df)

    #allows adding of NA (missing) values
    allowmissing!(df)

    #sets upper left and diaganol to missing
    for i in 1:n
        for j in 1:n
            if j >= i
                df[i,j] = missing
            end
        end
    end
    return df
end

#function to locate minimum cell in the table
function minimum_cell(df::DataFrame)
    #set starting value to infinity
    low_value = float(Inf)

    #set starting x,y values, non valid ints
    x = -1
    y = -1

    #get length of dataframe
    n = nrow(df)

    #evaluate each cell to see if it is lower
    for i in 1:n
        for j in 1:n
            if isless(df[i,j], low_value)
                low_value = df[i,j]
                x,y = i,j
            end
        end
    end

    #return the coordinates of the lowest value
    return x, y
end

#function to assemble the string to make output
function combine_strings(strings::Array{String,1}, a::Int64, b::Int64)

    #ensure that the order is consistant, always join on the lower one
    if b < a
        a, b = b, a
    end

    #join the values at the position of the first value
    strings[a] = string("(", strings[a], ",", strings[b], ")")
    
    #remove the second (redundant) value from strings
    setdiff!(strings, [strings[b]])

    return strings
end

#function to combine df on the column
#comma count is a way to track the weight of each entry
#If it is already an average, it is weighted as two values (or more)
function combine_df(df::DataFrame, a::Int64, b::Int64, comma_count::Array{Int64,1})

    #The number of values that are factored into an entry are one more than the number of commas
    b_den = comma_count[b]+1
    a_den = comma_count[a]+1

    #ensure that order is consistant, always join on the lower one.
    if b < a
        a, b = b, a
        a_den, b_den = b_den, a_den
    end

    #rows in dataframe
    n = nrow(df)

    #for the lower index, reconstruct the entire row
    for i in 1:a
        df[a,i] = ((df[a,i]*a_den + df[b,i]*b_den)/(a_den+b_den))
    end

    #for the lower index, reconstruct the section of the column between the indeces
    #don't include first value, because it was taken care of in the row.
    for i in a+1:b
        df[i,a] = (df[i,a]*a_den + df[b,i]*b_den)/(a_den+b_den)
    end

    #Construct the rest of the row for the lower index, getting values from the ith row.
    for i in b+1:n
        df[i,a] = (df[i,a]*a_den + df[i,b]*b_den)/(a_den+b_den)
    end

    #eliminate redundant rows and columns
    deleterows!(df, b)
    deletecols!(df, b)
    return df
end

#The function for outputting newick file (UPGMA)
#takes a data frame (distance matrix) and an array of strings which are the names of the samples in order
#verbose (if true) prints all dataframes along the way
function upgma(df::DataFrame, strings::Array{String,1} = fill("",1); header::Bool=true, verbose::Bool=false)
    #loop through, eliminated one row/column/string each time
    #print lines are optional, for more information

    #print if verbose is true
    if verbose == true
        println("Initial dataframe:")
        println(df)
        println(strings)

        println(string("number of strings: ", length(strings)))
        println(string("number of rows in DataFrame: ", nrow(df)))
    end

    #get the column names as the strings to use in the combine function if header is true
    if header == true
        strings = names(df)
    end

    #print strings if verbose is true
    if verbose == true
        println(strings)
    end

    #error if the data frame length is not the same as the string length
    if length(strings) != nrow(df)
        error = "Error: matrix size does not match sample size, exiting"
        return error
    end


    #loop through until all the columns/strings have been combined
    while length(strings) > 1

        #find the coordinates of the minimum entry
        x, y = minimum_cell(df)

        #count the number of commas in each string. This (+1) corresponds to how many values it represents
        #make the comma counter array
        comma_count = fill(0, length(strings))
        #println(comma_count)

        #actually count the commas
        for j in 1:length(strings)
            global comma_count[j] = count(i->(i==','), strings[j])
        end
        #println(comma_count)
        
        #combine the strings on the lowest coordinate
        combine_strings(strings, x, y)
        
        #print strings if verbose is true
        if verbose == true
            println(strings)
        end

        #combine the matrix on the lowest coordinate
        combine_df(df, x, y, comma_count)

        #rename df column names based on join
        rename!(df, strings)

        #print the df if true 
        if verbose == true
            println(df)
        end

    end
    return(string(strings[1], ";"))
end


#example dataframe and strings, and test function
dataframe1 = add_missing(CSV.read("sampledf.csv"))
values = ["A", "H", "a;sdlkfja;dlfjk", "D", "E", "F", "G"]
upgma(dataframe1, values, header = true, verbose = true)
