#download proprietary release of cellranger https://support.10xgenomics.com/single-cell-gene-expression/software/downloads/latest
apt-get install -y curl tar
curl -o cellranger-3.1.0.tar.gz "http://cf.10xgenomics.com/releases/cell-exp/cellranger-3.1.0.tar.gz?Expires=1586096560&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cDovL2NmLjEweGdlbm9taWNzLmNvbS9yZWxlYXNlcy9jZWxsLWV4cC9jZWxscmFuZ2VyLTMuMS4wLnRhci5neiIsIkNvbmRpdGlvbiI6eyJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTU4NjA5NjU2MH19fV19&Signature=DWPSV5-vWlrmZeeAIvC9ElBQND2C3SFfq~AOBAGoBVFmS3U4y9tXTRe~vWovdghgS44HiNSvwhIT0UCI4juaVmrQ3ZpTukU4l9L-dWPY6sy9IbDmKHnNRfzPGy4h~EcRuDg6bslMMd1QwoDYYMcyk08KKk9iVYbNeko1zmjwXO~Wag3qNV3j7iEuEnn6E4W~aY2m1wuSQuI4s0Fj9VIOGHCIY85dCHGmzpoJezYc7Opnp3PxRsPUvaQkFxgE6I1LHuJfujxYvqAR4AfpAllafoGxSJe1DHT9XrREHWgmS1gB02QvnYqLbV6dUgMvXidqSOX2BNUjtD9zqwxmK1iyNg__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"

#extract files
tar xvf cellranger-3.1.0.tar.gz 

#add test files to cellranger directory
cd /cellranger-3.0.2.9001/
ln -s /cellranger-3.1.0/cellranger-tiny-ref/ .
ln -s /cellranger-3.1.0/cellranger-tiny-fastq .

#run test job
cd
which cellranger
cellranger count help
cellranger testrun --id "tiny"
