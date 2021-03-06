#!/bin/bash

############### Setting the environment variables and directories ###############

rootdir="/home/qtestard"
project="test_vcf2F1graphs"
projectdir="/archivage/QTESTARD/$project"

# ln -s $rootdir/DATA/REF $projectdir

refdir="$projectdir/REF"
vcfdir="$rootdir/CompareCapture_FromFASTQ_2017/03_fastq2gvcf"

genomeref="$refdir/human_g1k_v37_decoy.fasta"

export HGREF=$genomeref
export HG19=$genomeref



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
declare -A parentID

runID[rocheMedexomeCov]='35'
runID[sofiaIdtXgenErCov]='37'
runID[agilentCreV2Cov]='38'
runID[illuminaIdtXgenErCov]='44'

kitID[rocheMedexomeCov]='medexomeCov'
kitID[sofiaIdtXgenErCov]='sofiaIdtCov'
kitID[agilentCreV2Cov]='agilentCr2Cov'
kitID[illuminaIdtXgenErCov]='illuminaIdtCov'

parentID[NIST002]='HG002'
parentID[NIST003]='HG003'
parentID[NIST004]='HG004'




############### Creating the results directory ###############

for size in $sampling_size;
        do for parent in $trio;
                do mkdir -p $projectdir/$size/$parent/SAMPLE; mkdir -p $projectdir/$size/$parent/RES
        done
done

############### Pulling symboling links of the vcf files in some organised directories ###############

# for size in $sampling_size;
#         do for kit in $capture_kit;
#                 do for length in $read_length;
#                         do for parent in $trio;
#                                 do ln -s $vcfdir/$size/${runID[$kit]}-$kit-$length/${runID[$kit]}-$parent-${kitID[$kit]}-$length/vcf/*.vcf.gz $projectdir/$size/$parent/SAMPLE;
#                         done
#                 done
#         done
# done


############### Getting and setting singularity and the hap.py image ###############


# Remain

## singularityDir="$projectdir/singularity/"
##
## mkdir $singularityDir && cd $singularityDir
##
## singularity pull docker pkrusche/hap.py
## singularity pull docker biocontainers/hap.py   THE DOCKER / SINGULARITY PULL IS NOT WORKING
##
## cd $projectdir
##
## I don't have the sudo rights for the classic hap.py installation, anyway it's already on the cluster

# ln -s $rootdir/bin/hap.py $projectdir


############### do nextflow ###############

# wget -qO- get.nextflow.io | bash

for size in $sampling_size;
        do for parent in $trio;
                do bedparent=`ls $refdir/*${parentID[$parent]}*.bed`;
                vcfparent=`ls $refdir/*${parentID[$parent]}*.vcf.gz`;
                vcfsample="$projectdir/$size/$parent/SAMPLE"

                results="$projectdir/$size/$parent/RES"

                # echo $bedparent $vcfpavcfsamplerent $ $results $genomeref
                nextflow -c "vcf2F1graphs.nf_config" run "vcf2F1graphs.nf" --sampledir $vcfsample --resultdir $results --bedref $bedparent --vcfref $vcfparent --refgenome $genomeref
                done
        done




# for size in $sampling_size;
#         do for kit in $capture_kit;
#                 do for length in $read_length;
#                         do for parent in $trio;
#                                 do nextflow;
#                         done
#                 done
#         done
# done
