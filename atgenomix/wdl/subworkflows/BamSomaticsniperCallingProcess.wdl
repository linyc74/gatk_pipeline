version 1.0

import "GeneralTask.wdl" as general

# WORKFLOW DEFINITION

# Generate a SomaticSniper processed ready vcf
workflow BamSomaticsniperCallingProcess {
    input {
        File inFileTumorBam
        File inFileNormalBam
        File refFa
        File refFai
        File refFaGzi
        String tumorSampleName
        String normalSampleName
        String sampleName
    }
 
    call BamSomaticsniper {
        input:
            inFileTumorBam = inFileTumorBam,
            inFileNormalBam = inFileNormalBam,
            refFa = refFa,
            refFai = refFai,
            refFaGzi = refFaGzi,
            tumorSampleName = tumorSampleName,
            normalSampleName = normalSampleName,
            sampleName = sampleName
    }
 
    call general.PythonVariantFilter as filter {
        input:
            inFileVcf = BamSomaticsniper.outFileVcf,
            sampleName = sampleName
    }

    output {
        File outFileVcf = filter.outFileVcf
    }
}

# TASK DEFINITIONS

# Call variants using SomaticSniper
task BamSomaticsniper {
    input {
        File inFileTumorBam
        File inFileNormalBam
        File refFa
        File refFai
        File refFaGzi
        String tumorSampleName
        String normalSampleName
        String sampleName
    }
 
    command <<<
        set -e -o pipefail
        bam-somaticsniper \
        -t ~{tumorSampleName} \
        -n ~{normalSampleName} \
        -F vcf \
        -f ~{refFa} \
        ~{inFileTumorBam} \
        ~{inFileNormalBam} \
        ~{sampleName}_somatic-sniper.vcf
    >>>
 
    output {
        File outFileVcf = "~{sampleName}_somatic-sniper.vcf"
    }
 
    runtime {
        docker: 'nycu:latest'
    }
}