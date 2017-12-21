#!/bin/bash

############### Setting the environment variables ###############

rootdir="/home/qtestard"
project="test_vcf2F1graphs"
resultdir="/archivage/QTESTARD/$project"

vcfdir="$rootdir/CompareCapture_FromFASTQ_2017/03_fastq2gvcf"


############### List of the different discriminating parameters of the vcf files ###############

sampling_size="1000000 5000000 10000000 15000000 20000000 25000000"
capture_kit="rocheMedexomeCov sofiaIdtXgenErCov agilentCreV2Cov illuminaIdtXgenErCov"
read_length="75 100"
trio="NIST002 NIST003 NIST004"
# capture_kit="edexomeCov sofiaIdt agilentCr2 illuminaIdt"


############### Some associative array for vcf files path construction ###############
# (A bit dirty tho)

declare -A runID
declare -A kitID

runID[rocheMedexomeCov]='35'
runID[sofiaIdtXgenErCov]='37'
runID[agilentCreV2Cov]='38'
runID[illuminaIdtXgenErCov]='44'

kitID[rocheMedexomeCov]='medexomeCov'
kitID[sofiaIdtXgenErCov]='sofiaIdtCov'
kitID[agilentCreV2Cov]='agilentCr2Cov'
kitID[illuminaIdtXgenErCov]='illuminaIdtCov'


############### Creating the results directory ###############

for size in $sampling_size;
        do for parent in $trio;
                do mkdir -p $resultdir/$size/$parent;
        done
done

############### Pulling symboling links of the vcf files in some organised directories ###############

for size in $sampling_size;
        do for kit in $capture_kit;
                do for length in $read_length;
                        do for parent in $trio;
                                do ln -s $vcfdir/$size/${runID[$kit]}-$kit-$length/${runID[$kit]}-$parent-${kitID[$kit]}-$length/vcf/*.vcf.gz $resultdir/$size/$parent;
                        done
                done
        done
done
