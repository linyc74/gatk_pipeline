FROM continuumio/miniconda3:4.10.3

# mamba in the base environment
RUN conda install -c conda-forge mamba=0.27.0

RUN conda create -n somatic python=3.7 \
 && mamba install -c conda-forge -n somatic \
    tbb=2020.2 \
 && mamba install -c bioconda -n somatic \
    trim-galore=0.6.6 \
    bwa=0.7.17 \
    samtools=1.11 \
    gatk4=4.2.4.1 \
    bowtie2=2.3.5 \
    muse=1.0 \
    varscan=2.3.7 \
    bcftools=1.8 \
    vcf2maf=1.6.21 \
    vardict=2019.06.04 \
    bedtools=2.30.0 \
    lofreq=2.1.5 \
    somatic-sniper=1.0.5.0 \
 && mamba install -c anaconda -n somatic \
    pandas=1.3.5 \
 && mamba clean --all --yes

# for identical commands (e.g. pip), somatic overrides default environment
ENV PATH /opt/conda/envs/somatic/bin:$PATH

# extra env path for vardict
ENV PATH /opt/conda/envs/somatic/share/vardict-2019.06.04-0:$PATH

# bcftools dependency issue
ARG d=/opt/conda/envs/somatic/lib/
RUN ln -s ${d}libcrypto.so.1.1 ${d}libcrypto.so.1.0.0

# download and unzip snpeff
RUN mamba install -c conda-forge unzip=6.0 \
 && wget https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip \
 && unzip snpEff_latest_core.zip \
 && rm snpEff_latest_core.zip

# make snpeff executable
ENV PATH /snpEff/exec:$PATH

# download pre-build snpeff database
RUN snpeff download -verbose GRCh38.99

# dependency for cnvkit
ARG d=/opt/conda/envs/somatic/lib/
RUN mamba install -c conda-forge -n somatic r-base=3.2.2 \
 && mamba install -c bioconda -n somatic bioconductor-dnacopy=1.44.0 \
 && ln -s ${d}libreadline.so.8.1 ${d}libreadline.so.6 \
 && ln -s ${d}libncursesw.so.6.2 ${d}libncurses.so.5 \
 && mamba install -c anaconda -n somatic pomegranate=0.14.4 \
 && mamba clean --all --yes

# install cnvkit, the pip used is in 'somatic' env
RUN pip install --upgrade pip \
 && pip install --no-cache-dir cnvkit==0.9.9

# perl dependency for vep
# perl build must be "h470a237_0" to avoid bad version (hard-coded gcc path)
RUN mamba install -c conda-forge -n somatic \
    perl=5.26.2=h470a237_0 \
    gcc=12.1.0 \
 && mamba install -c anaconda -n somatic \
    make=4.2.1 \
 && mamba install -c bioconda -n somatic \
    perl-app-cpanminus=1.7044 \
 && cpan DBI \
 && cpan Try::Tiny

# install vep
RUN wget https://github.com/Ensembl/ensembl-vep/archive/release/106.zip \
 && unzip 106.zip \
 && cd ensembl-vep-release-106 \
 && perl INSTALL.pl --AUTO ap --PLUGINS all --NO_HTSLIB \
 && cd .. \
 && rm 106.zip

# make vep executable
ENV PATH /ensembl-vep-release-106:$PATH

# copy source code
COPY somatic_pipeline/* /somatic_pipeline/somatic_pipeline/
COPY ./__main__.py /somatic_pipeline/
WORKDIR /
