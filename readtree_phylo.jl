#take a newick file and read it as a tree

#modules
using Phylo
using Plots
plotly()

function read_tree(file::String)
    tree = open(parsenewick, file)
    return tree
end

#test
tree_var = read_tree("data_files/sample_file.newick")
plot(tree_var)
