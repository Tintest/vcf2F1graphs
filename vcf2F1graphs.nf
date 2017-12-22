#!/usr/bin/env nextflow

log.info "\n#####################################################"
log.info "Nextflow runtime version number: $nextflow.version"
log.info "Nextflow runtime build number: $nextflow.build"
log.info "$nextflow.timestamp"
log.info "#####################################################\n"


vcfiles=Channel.fromPath("${params.sampledir}/*.vcf.gz")


process test {

  input:
  file vcf from vcfiles

  """
  echo $vcf
  """

}

result.subscribe { println it }
// process_hap.py {
//
//
//
//
//
// }
