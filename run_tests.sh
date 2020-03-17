#download proprietary release of cellranger https://support.10xgenomics.com/single-cell-gene-expression/software/downloads/latest
curl -o cellranger-3.1.0.tar.gz "http://cf.10xgenomics.com/releases/cell-exp/cellranger-3.1.0.tar.gz?Expires=1584107763&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cDovL2NmLjEweGdlbm9taWNzLmNvbS9yZWxlYXNlcy9jZWxsLWV4cC9jZWxscmFuZ2VyLTMuMS4wLnRhci5neiIsIkNvbmRpdGlvbiI6eyJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTU4NDEwNzc2M319fV19&Signature=GiNqCjRO30O2ML-l6eXtbTr5K~V92r6~Ov1Hfj9havE3s8gE91BEm0rfqPqFCulDIsozZdeKCyrY918E9S8fjixqqZbwQgajoWiXVXZ4dfiQdPrRqDLb1GkGDtrC7M-yyELKsZXlIwnX~qEOs89oEf0z6SnMos1TbA2FnQqYvjWIL-gYCvP1S6-zPjuIUF3gJTt85s8Miaiy93Cql67h-soeu4uTDYbPKbd8lx6wtKOtHn6e1HPtqCpnJUVX0zfaCsBLHzrSI6Py3pS8ewgW~dtGckD~-JImED8HX13b1FbbZV~ypt9Q96~sVAKj~iA5tkoRYb8D5T1CyCq80rZ-kg__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"

#extract files
tar xvf cellranger-3.1.0.tar.gz 

#add test files to cellranger directory
cd /cellranger-3.0.2.9001/
ln -s /cellranger-3.1.0/cellranger-tiny-ref/ .
ln -s /cellranger-3.1.0/cellranger-tiny-fastq .

#run test job
cd
which cellranger
cellranger testrun --id "tiny"
