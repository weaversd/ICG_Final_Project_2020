#take a newick file and read it as a tree

#modules
using PhyloNetworks
using PhyloPlots

#Read a newick file and plot it with phyloplots
#if proportional is true, edge lengths correspond to values
#if proportaionl is false, all edge lengths are the same
function plot_newick(file::String; proportional::Bool = true)
    tree_obj = readTopology(file)
    plot(tree_obj, :R, useEdgeLength = proportional)
end

#example plot
plot_newick("data_files/sample_file.newick")