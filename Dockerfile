FROM ubuntu:bionic

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install dependencies for cellranger
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
    cython \
#    golang-1.10 \
    libbz2-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libgfortran-5-dev \
    libffi-dev \
    libhdf5-dev \
    libncurses-dev \
    libopenblas-dev \
    libpixman-1-dev \
    libpng-dev \
    libsodium-dev \
    libssl-dev \
    libtiff5-dev \
    libxml2-dev \
    libxslt1-dev \
    libzmq3-dev \
    python-cairo \
    python-h5py \
#    python-libtiff \
    python-matplotlib \
    python-nacl \
    python-numpy \
    python-pip \
    python-libxml2 \
    python-redis \
    python-ruamel.yaml \
    python-sip \
    python-sqlite \
    python-tables \
    python-tk \
    samtools \
    tar \
    wget \
    zlib1g-dev

RUN pip install Cython==0.28.0

RUN pip install libtiff

RUN wget https://dl.google.com/go/go1.11.linux-amd64.tar.gz \
 && tar -xvf go1.11.linux-amd64.tar.gz \
 && mv go /usr/local

ENV GOROOT=/usr/local/go
ENV GOPATH=$HOME/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

RUN ln -s /usr/lib/go-1.10/bin/go /usr/bin/go

COPY requirements.txt /opt/requirements.txt
RUN pip install -r /opt/requirements.txt

# Install rust and cargo. Note that installing with apt gets a rust that won't complie
# cellranger.
RUN apt-get install -y \
    curl \
    git \
 && curl https://sh.rustup.rs -sSf | sh -s -- -y

ENV PATH /root/.cargo/bin/:$PATH

# Build cellranger itself 
RUN git clone https://github.com/TomKellyGenetics/cellranger.git cellranger-2.1.0.9001/cellranger-cs/2.1.0.9001 \
 && cd cellranger-2.1.0.9001/cellranger-cs/2.1.0.9001 \
 && git checkout v2.1.0 \
 && echo "2.1.0.9001" > .version \
 && make

RUN ln -s /cellranger-2.1.0.9001/cellranger-cs/2.1.0.9001/bin/cellranger /cellranger-2.1.0.9001/cellranger \
 && cd /

COPY crconverter_open.sh /cellranger-2.1.0.9001/cellranger-cs/2.1.0.9001/lib/bin/crconverter

COPY crconverter_open.sh /cellranger-2.1.0.9001/cellranger-cs/2.1.0.9001/lib/bin/vlconverter

# Install Martian. Note that we're just building the executables, not the web stuff
RUN git clone --recursive https://github.com/martian-lang/martian.git \
 && cd martian \
&& make mrc mrf mrg mrp mrs mrstat mrjob

# Set up paths to cellranger. This is most of what sourceme.bash would do.
ENV PATH /cellranger-2.1.0.9001/cellranger-cs/2.1.0.9001/bin/:/cellranger-2.1.0.9001/cellranger-cs/2.1.0.9001/lib/bin:/cellranger-2.1.0.9001/cellranger-cs/2.1.0.9001/tenkit/bin/:/cellranger-2.1.0.9001/cellranger-cs/2.1.0.9001/tenkit/lib/bin:/martian/bin/:$PATH
ENV PYTHONPATH /cellranger-2.1.0.9001/cellranger-cs/2.1.0.9001/lib/python:/cellranger-2.1.0.9001/cellranger-cs/2.1.0.9001/tenkit/lib/python:/martian/adapters/python:$PYTHONPATH
ENV MROPATH /cellranger-2.1.0.9001/cellranger-cs/2.1.0.9001/mro/:/cellranger-2.1.0.9001/cellranger-cs/2.1.0.9001/tenkit/mro/
ENV _TENX_LD_LIBRARY_PATH whatever

# Install bcl2fastq. mkfastq requires it.
RUN apt-get update \
 && apt-get install -y alien unzip wget \
 && wget https://support.illumina.com/content/dam/illumina-support/documents/downloads/software/bcl2fastq/bcl2fastq2-v2-19-1-linux.zip \
 && unzip bcl2fastq2*.zip \
 && alien bcl2fastq2*.rpm \
 && dpkg -i bcl2fastq2*.deb \
 && rm bcl2fastq2*.deb bcl2fastq2*.rpm bcl2fastq2*.zip

# Install STAR aligner
RUN wget https://github.com/alexdobin/STAR/archive/2.5.1b.tar.gz \
 && tar xf 2.5.1b.tar.gz \
 && rm 2.5.1b.tar.gz \
 && cd STAR-2.5.1b \
 && make \
 && mv bin/Linux_x86_64_static/STAR* /usr/bin \
 && cd .. \
 && rm -rf STAR-2.5.1b

# Install tsne python pacakge. pip installing it doesn't work
RUN git clone https://github.com/TomKellyGenetics/tsne.git \
 && cd tsne \
 && make install \
 && cd .. \
 && rm -rf tsne

ENV PATH /cellranger-2.1.0.9001:$PATH
