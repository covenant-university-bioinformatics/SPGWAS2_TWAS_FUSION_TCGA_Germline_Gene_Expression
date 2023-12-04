# The Cancer Genome Atlas (TCGA) tumor/normal expression

This pipeline aims to perform transcriptome-wide and regulome-wide association tests (TWAS and RWAS) using the FUSION  tool (http://gusevlab.org/projects/fusion/). The user can use this tool to perform TWAS and RWAS analysis based on expression from the Cancer Genome Atlas (TCGA) tumor/normal. These expression data were sourced from Germline gene expression models constructed from tumor RNA-seq. There are a total of 24 cancer types that can be used to perfom this analysis.

# Input data format
This pipeline accepts  GWAS summary statistics as an input file. The input file should be headed with the following minimum fields:  
- SNP – SNP identifier (rsID)
- A1 – first allele (effect allele)
- A2 – second allele (other allele)
- Z – Z-scores, sign with respect to A1.

# User options
Users can set the following options:
- GTEx weights: there are 10 tissues. 
- Reference panel for calculating the linkage disequilibrium: Here, we used the fine supper populations of 1000 genome data, i.e.,  eur, afr, amr, sas, and  eas. 
- The target chromosome: The pipeline analyzes only on autosomes, i.e., chromosome {1-22}.
- Locus window size: This option is used for visualization purposes,  the default plotting window size is  100000
- P-value: this option is optional for computing  COLOC statistics using coloc R library. The value of 0 turns this calculation off. 
- Max imputation: Fraction of GWAS SNPs allowed to be missing per gene, the default value is  0.5
- Minimum average IMPG imputation accuracy allowed (min_r2pred) the default value is	 0.7
- Total number of variants per chromosome (numberOfSNPs)
- GWASN=${11}  ## 0 means off
Total GWAS/sumstats sample size for inference of standard GWAS effect size (GWASN): This option is optional. 
- Maximum number of permutations to perform for each feature (perm_max_runs). The value of  0 means it turns the permutation process off.	
- Threshold to initiate permutation test: This option works only when the permutation process is on. The default value is 0.05.


# GTEx tissue
 Users can choose one of the following 10 tissues:
- Bladder Urothelial Carcinoma	(TCGA_BLCA.TUMOR)
- Breast Invasive Carcinoma	(TCGA_BRCA.TUMOR)
- Cervical Squamous Cell Carcinoma	(TCGA_CESC.TUMOR)
- Colon Adenocarcinoma	(TCGA_COAD.TUMOR)
- Esophageal Carcinoma	(TCGA_ESCA.TUMOR)
- Glioblastoma Multiforme	(TCGA_GBM.TUMOR)
- Head and Neck Squamous Cell Carcinoma	(TCGA_HNSC.TUMOR)
- Kidney Renal Clear Cell Carcinoma	(TCGA_KIRC.TUMOR)
- Kidney Renal Papillary Cell Carcinoma	(TCGA_KIRP.TUMOR)
- Brain Lower Grade Glioma	(TCGA_LGG.TUMOR)
- Liver Hepatocellular Carcinoma	(TCGA_LIHC.TUMOR)
- Lung Adenocarcinoma	(TCGA_LUAD.TUMOR)
- Lung Squamous Cell Carcinoma	(TCGA_LUSC.TUMOR)
- Ovarian Serous Cystadenocarcinoma	(TCGA_OV.TUMOR)
- Pancreatic Adenocarcinoma	(TCGA_PAAD.TUMOR)
- Pheochromocytoma and Paraganglioma	(TCGA_PCPG.TUMOR)
- Prostate Adenocarcinoma	(TCGA_PRAD.TUMOR)
- Rectum Adenocarcinoma	(TCGA_READ.TUMOR)
- Soft Tissue Sarcoma	(TCGA_SARC.TUMOR)
- Skin Cutaneous Melanoma	(TCGA_SKCM.TUMOR)
- Stomach Adenocarcinoma	(TCGA_STAD.TUMOR)
- Testicular Germ Cell Tumors	(TCGA_TGCT.TUMOR)
- Thyroid Carcinoma	(TCGA_THCA.TUMOR)
- Uterine Corpus Endometrial Carcinoma	(TCGA_UCEC.TUMOR)



# Output file:
The output files are tab-delimited files (*chr*__TCGA_germline__imputation.txt, *chr*_omnibus_TCGA_germline_imputation.txt) containing  signals of transcriptome-wide significant associations  with the following fields:
- FILE: Full path to the reference weight file used
- ID: Feature/gene identifier, taken from --weights file
- CHR: Chromosome
- P0: Gene start (from --weights)
- P1: Gene end (from --weights)
- HSQ: Heritability of the gene
- BEST.GWAS.ID: rsID of the most significant GWAS SNP in locus
- BEST.GWAS.Z: Z-score of the most significant GWAS SNP in locus
- EQTL.ID: rsID of the best eQTL in the locus
- EQTL.R2: cross-validation R2 of the best eQTL in the locus
- EQTL.Z: Z-score of the best eQTL in the locus
- EQTL.GWAS.Z: GWAS Z-score for this eQTL
- NSNP: Number of SNPs in the locus
- MODEL: Best performing model 
- MODELCV.R2: cross-validation R2 of the best-performing model
- MODELCV.PV: cross-validation P-value of the best-performing model
- TWAS.Z: TWAS Z-score (primary statistic of interest)
- TWAS.P: TWAS P-value


Besides the text files, the pipeline provides several plots in PDF format to visualize the correlation plot of the top expression imputation (chr_top_analysis__TCGA_germline__imputation.dat.corrplot.png), and various plots for top locations of the expression imputation (chr_top_analysis__TCGA_germline__.dat.loc_*{N}*.pdf






