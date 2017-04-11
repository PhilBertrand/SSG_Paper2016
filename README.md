# Sex-Specific Graph
This repository contains the scripts used in the manuscript "Sex-Specific Graphs: Relating Group-Specific Topology to Demographic and Landscape Data".

More precisely, scripts are divided into two main categories; 1) Generic functions and; 2) Sensitivity analyses:

1) Generic Functions
1.1) sorc() : R code for calculating the second order rate of change from a list. 

1.2) koen_centrality() : Node-based connectivity metric calculated by the inverse of the edge weight, averaged across the edges; proposed by Koen et al. (2016). 

2) Sensitivity Analyses
2.1) sens_GD() : R code for performing the sensitivity analysis reported in the manuscript "Sex-Specific Graphs: Relating Group-Specific Topology to Demographic and Landscape Data". The code calculates variability in genetic diversity estimates (Ae; Kimura & Crow, 1964) through different scenarios of sampling intensities.

2.2) sens_topology() : R code for performing the sensitivity analysis on topology reported in the manuscript "Sex-Specific Graphs: Relating Group-Specific Topology to Demographic and Landscape Data". The code calculates variability in eigenvector centrality centralization score through different scenarios of node removal. Note that this code could also be applied on different network metrics such as conditional genetic distance (cGD; Dyer et al., 2010).

References

Dyer RJ, Nason JD, Garrick RC (2010) Landscape modelling of gene flow: improved power using conditional genetic distance derived from the   topology of population networks. Molecular Ecology, 19, 3746–3759.

Kimura M, Crow JF (1964) The number of alleles that can be maintained in a finite population. Genetics, 49, 725–738. 

Koen EL, Bowman J, Wilson PJ (2016) Node-based measures of connectivity in genetic networks. Molecular Ecology Resources, 16, 69–79.
