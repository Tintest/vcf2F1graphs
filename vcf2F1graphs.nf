#!/usr/bin/env nextflow

log.info "\n#####################################################"
log.info "Nextflow runtime version number: $nextflow.version"
log.info "Nextflow runtime build number: $nextflow.build"
log.info "$nextflow.timestamp"
log.info "#####################################################\n"


vcfiles=Channel.fromPath("${params.sampledir}/*BQSR.vcf.gz")
// Channel
//     .fromFilePairs("${params.sampledir}/*.vcf.gz", size: 1) { file -> file.extension }
//     .println { ext, files -> "Files with the extension $ext are $files" }

// datasets = Channel
//     .fromPath("${params.sampledir}/*.vcf.gz")
//     .map { file -> tuple(file.baseName, file) }
//     .println {file -> "File name $file[0]" }


// datasets = Channel
//     .fromPath("${params.sampledir}/*.vcf.gz")
//     .map { file -> tuple(get_prefix(file.name), file) }
//     .println {file -> "File name $file[0]" }


vcfparent=Channel.fromPath("${params.vcfref}")
bedparent=Channel.fromPath("${params.bedref}")
// genomeref=Channel.fromPath("${params.refgenome}")




process hap.py {

  publishDir "${params.resultdir}"

  input:
  each vcfs from vcfiles
  file bedp from bedparent
  file vcfp from vcfparent
  // file genome from genomeref

  output:

  set file ('*.summary.csv'), file ('*.extended.csv'), file ('*.metrics.json.gz'), file ('*.roc.all.csv.gz'), file ('*.roc.Locations.INDEL.csv.gz'), file('*.roc.Locations.INDEL.PASS.csv.gz'), file ('*.roc.Locations.SNP.csv.gz'), file ('*.roc.Locations.SNP.PASS.csv.gz'), file ('*.runinfo.json')  into results


  script:

  samplename = vcfs.baseName[0..-5]
  """
  ${params.projectdir}/./hap.py $vcfp $vcfs -T $bedp -o $samplename -r ${params.refgenome}
  """


}

result.subscribe { println it }
