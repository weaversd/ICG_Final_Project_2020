# ICG_Final_Project_2020 - Simon Weaver

Abstract/Proposal:
MUC16/CA125 (Referred to as MUC16 from here) is a the clinically accepted biomarker for ovarian cancer detection in humans. Despite this important role in healthcare, the protein itself is relatively poorly understood. For example, the binding epitopes for the two antibodies used in the clinical test are unknown. There has not been a phylogenetic analysis of MUC16 published since 2006
(https://www.sciencedirect.com/science/article/pii/S0378111906000266?casa_token=2P5u2gdYe0UAAAAA:afoNoz_OVdFpGtSS_eQHmtDG5tckW6q8r5RewnsZrvLSNaL7pLX6ymA_j-XpndrOAHNxklL_Sw), therefore an updated analysis of MUC16 and orthologs, both in cancerous and non-cancerous samples, will be of benefit to the scientific community. This project will evalute the phylogony of different sequences of MUC16 orthologs and then attempt to evaluate the conformational changes that differences in amino acid sequences have on the final protein.

1) Group members: 
Simon Weaver

2) New code required:
A julia package that can take protein sequence files, create a phylogenetic tree, and predict protein structure differences based on the sequences. This will make use of existing packages, including bio.jl, phylogenies.jl, and BioStructures.jl

3) Activities Required:
Identifying protein sequence files from different samples of MUC16 and orthologs.
Writing Julia package
Visualizing phylogeny and differences between samples
Protein structure analysis (PyMol?)

4) Data Used:
NCBI sequences and orthologs: https://www.ncbi.nlm.nih.gov/gene/94025/ortholog/?scope=32523#genes-tab
BlastP results: https://www.uniprot.org/blast/uniprot/B202008285C475328CEF75220C360D524E9D456CE0C4F32O

5) Questions Asked: 
What are the sequence differences between MUC16 in cancerous and non-cancerous patients?
Can structural changes due to these differences be identified?
How closely related are different orthologs of MUC16?
