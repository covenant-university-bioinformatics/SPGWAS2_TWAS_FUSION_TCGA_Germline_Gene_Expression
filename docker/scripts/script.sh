#!/bin/env bash
bindir="/app/fusion_twas-master/"
dbdir="/db"
output1="TCGA_germline_imputation.dat" #Gene-disease association

## list of tissues:
#"TCGA_BLCA.TUMOR"   "TCGA_BRCA.TUMOR"   "TCGA_CESC.TUMOR"   "TCGA_COAD.TUMOR"   "TCGA_ESCA.TUMOR"   "TCGA_GBM.TUMOR"   "TCGA_HNSC.TUMOR"   "TCGA_KIRC.TUMOR"   "TCGA_KIRP.TUMOR"   "TCGA_LGG.TUMOR"   "TCGA_LIHC.TUMOR"   "TCGA_LUAD.TUMOR"   "TCGA_LUSC.TUMOR"   "TCGA_OV.TUMOR"   "TCGA_PAAD.TUMOR"   "TCGA_PCPG.TUMOR"   "TCGA_PRAD.TUMOR"   "TCGA_READ.TUMOR"   "TCGA_SARC.TUMOR"   "TCGA_SKCM.TUMOR"   "TCGA_STAD.TUMOR"   "TCGA_TGCT.TUMOR"   "TCGA_THCA.TUMOR"   "TCGA_UCEC.TUMOR"

set -x 
#The primary input is genome-wide summary statistics in LD-score format. At minimum, this is a flat file with a header row containing the following fields:
#1. SNP – SNP identifier (rsID)
#2. A1 – first allele (effect allele)
#3. A2 – second allele (other allele)
#4. Z – Z-scores, sign with respect to A1.

inputfile=$1
outdir="/home/outdir"
#single tissues
weights=$3 # {5 tissues}
ref_ld_chr=$4  #{eur, afr, amr, sas, eas}
chr=$5   #{1-22}
locus_win=$6  # locus windows to plot, default 100000
coloc_P=$7   #P-value below which to compute COLOC statistic. Requires coloc R library.	0 means off
use_coloc_P=''

if [ $coloc_P -gt 0 ] && [ $coloc_P -le 1 ]; then
   use_coloc_P="--coloc_P ${coloc_P}   "
fi  
max_impute=$8  # Fraction of GWAS SNPs allowed to be missing per gene (for IMPG imputation)	 0.5
min_r2pred=$9 #Minimum average IMPG imputation accuracy allowed	 0.7
numberOfSNPs=${10} # Total number of variant per chromosome 
GWASN=${11}  ## 0 means off
use_GWASN=''

if [ $GWASN -gt 0 ]; then
   use_GWASN="--GWASN	  ${GWASN}   "
fi


perm_max_runs=${12}  # Maximum number of permutations to perform for each feature, 0=off	
run_perm=''
 

if [ $perm_max_runs -gt 0 ]; then
   perm_minp=${13}  #If --perm, threshold to initiate permutation test	 0.05
   run_perm="--perm  ${perm_max_runs}  \
    --perm_minp  ${perm_minp}"
fi    


tissue="TCGA_germline/"${weights}".pos"

## Run analysis
#chmod +x script_single_tissue.sh
#mkdir test1
##mkdir test2
# 1. without permuatation -----  #Joint/conditional tests and plots
#./scripts/script_TCGA_Germline.sh ../PGC2.SCZ.sumstats test1 TCGA_BLCA.TUMOR eur 22 100000 0 0.5  0.7 2500 0 0 

# 2. with permuatation --- # Significance conditional on high GWAS effects (permutation test)
#./scripts/script_TCGA_Germline.sh ../PGC2.SCZ.sumstats test2 TCGA_BRCA.TUMOR afr 22 100000 0 0.5  0.7 2500 0 100  0.05 

optional_options="$use_GWASN $run_perm"
#Performing the expression imputation
{
Rscript ${bindir}/FUSION.assoc_test.R \
--sumstats ${inputfile} \
--weights ${dbdir}/WEIGHTS/${tissue} \
--weights_dir ${dbdir}/WEIGHTS/TCGA_germline \
--ref_ld_chr ${dbdir}/ldref/g1000_${ref_ld_chr}. \
--chr ${chr} \
--out ${outdir}/${chr}_${output1} \
${optional_options}

if [ ! -f "${outdir}/${chr}_${output1}" ]; then
  touch ${outdir}/${chr}_${output1}
  echo " Please update your input options and try again..."
fi

cat ${outdir}/${chr}_${output1} | awk -v N="$numberOfSNPs" 'NR == 1 || $NF < 0.05/N' > ${outdir}/${chr}_top_${output1}
} || {

touch ${outdir}/${chr}_top_${output1}
}

if [ ! -f "${outdir}/${chr}_top_${output1}" ]; then
   touch ${outdir}/${chr}_top_${output1}
fi

linses=($(wc -l ${outdir}/${chr}_top_${output1})) ## to check that ${outdir}/${chr}_top_${output1} is not empty file
if [ ${linses[0]} -gt 2 ]; then
Rscript ${bindir}/FUSION.post_process.R \
--sumstats ${inputfile} \
--input ${outdir}/${chr}_top_${output1} \
--out ${outdir}/${chr}_top_analysis_${output1}  \
--ref_ld_chr ${dbdir}/ldref/g1000_${ref_ld_chr}. \
--chr ${chr} \
--plot --locus_win ${locus_win} \
--plot_corr	--plot_eqtl 	--report	


#Testing for effect in multiple reference panels (omnibus test)
Rscript ${bindir}/FUSION.post_process.R --omnibus \
--sumstats ${inputfile} \
--input ${outdir}/${chr}_top_${output1} \
--ref_ld_chr ${dbdir}/ldref/g1000_${ref_ld_chr}. \
--chr ${chr} \
--out ${outdir}/${chr}_omnibus_${output1}
else
touch ${outdir}/${chr}_top_analysis_${output1}
touch ${outdir}/${chr}_omnibus_${output1}
fi


pdf=($(ls ${outdir}/*.pdf  2> /dev/null ))
if [ ${#pdf[@]} -gt 0 ]; then
  for file in "${pdf[@]}"; do
  file_png=$(echo ${file}| sed -e  's/.pdf$/.png/')
  pdftoppm -png ${file} > ${file_png}
done 
fi

dat=($(ls ${outdir}/*.dat  2> /dev/null ))
if [ ${#dat[@]} -gt 0 ]; then
  for file in "${dat[@]}"; do
  file_txt=$(echo ${file}| sed -e  's/.dat$/.txt/')
  mv ${file}  ${file_txt}
done 
fi

