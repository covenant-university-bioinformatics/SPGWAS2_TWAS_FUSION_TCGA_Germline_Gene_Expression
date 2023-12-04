#!usr/bin/env bash
#Adam 021023
url="http://gusevlab.org/projects/fusion/weights/";


suffix=".tar.bz2"
TCGA_gemline=("TCGA-BLCA.TUMOR"   "TCGA-BRCA.TUMOR"   "TCGA-CESC.TUMOR"   "TCGA-COAD.TUMOR"   "TCGA-ESCA.TUMOR"   "TCGA-GBM.TUMOR"   "TCGA-HNSC.TUMOR"   "TCGA-KIRC.TUMOR"   "TCGA-KIRP.TUMOR"   "TCGA-LGG.TUMOR"   "TCGA-LIHC.TUMOR"   "TCGA-LUAD.TUMOR"   "TCGA-LUSC.TUMOR"   "TCGA-OV.TUMOR"   "TCGA-PAAD.TUMOR"   "TCGA-PCPG.TUMOR"   "TCGA-PRAD.TUMOR"   "TCGA-READ.TUMOR"   "TCGA-SARC.TUMOR"   "TCGA-SKCM.TUMOR"   "TCGA-STAD.TUMOR"   "TCGA-TGCT.TUMOR"   "TCGA-THCA.TUMOR"   "TCGA-UCEC.TUMOR");

#TCGA_gemline=("TCGA-BLCA.TUMOR"   "TCGA-BRCA.TUMOR"   "TCGA-CESC.TUMOR" )
for tissue in "${TCGA_gemline[@]}"; do
    wget -c ${url}${tissue}${suffix}
    tar -xvf ${tissue}${suffix}
    echo ${tissue}${suffix};
    rm ${tissue}${suffix};
   if [[ "${tissue}" == *-* ]]; then
      new_name=$(echo "${tissue}" | sed -r 's/[-]+/_/g')
      mv ${tissue} ${new_name}
      sub_files=($(ls ${new_name} ))
      for annotation in "${sub_files[@]}"; do
      new_name_annotaion=$(echo "${annotation}" | sed -r 's/[-]+/_/g' | sed -r 's/\?//g' )
      mv ${new_name}/${annotation}   ${new_name}/${new_name_annotaion}
      done
      files=($(ls *-* ))
      for file in "${files[@]}"; do
        new_name2=$(echo "${file}" | sed -r 's/[-]+/_/g')
        mv ${file} ${new_name2}
        sed -i 's/-/_/g' ${new_name2}*
        sed -i 's/\?//g'  ${new_name2}*
        sed -i 's/:/_/g'  ${new_name2}*
      done
  fi
    sed -i 's/-/_/g' *.pos
    sed -i 's/\?//g'  *.pos
    sed -i 's/:/_/g'  *.pos
 done



  
#Any issue in tar is likely the disk you are extracting to is formatted FAT*. The FAT* filesystems do not allow : ? symbols to appear in directory entries (filenames).
# wget -c http://gusevlab.org/projects/fusion/weights/TCGA_LUSC.TUMOR.tar.bz2
