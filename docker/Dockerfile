FROM ubuntu:22.04

WORKDIR /app
## to stop interactve  input tzdata (timezone)
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Africa/Lagos
RUN  apt-get update && apt-get upgrade -y \
     && apt install -y wget zip unzip g++ r-base r-base-dev dos2unix r-cran-rcppeigen \
     &&  apt-get -y install libcurl4-openssl-dev poppler-utils \
     && wget https://github.com/gusevlab/fusion_twas/archive/master.zip \
     && unzip master.zip && rm master.zip \
     &&  cd fusion_twas-master \
     && wget https://github.com/gabraham/plink2R/archive/master.zip \
     && unzip master.zip && rm master.zip \
     && R -e "install.packages(c('optparse','RColorBrewer', 'corrplot','coloc', 'Rcpp'),dependencies=TRUE, repos='http://cran.rstudio.com/')" \
     && R -e "install.packages('plink2R-master/plink2R/',repos=NULL)"
COPY scripts/ ./scripts/
RUN dos2unix /app/scripts/script.sh
RUN dos2unix /app/scripts/script.sh
RUN chmod 775 /app/scripts/script.sh
ENV PATH="$PATH:/app/fusion_twas-master/"
RUN mkdir -p /home/outdir

##CMD sh -c 'ln -s ~/bin/gatk-4.4.0.0/gtak /bin/gatk'

CMD ["bash", "/app/scripts/script.sh"]