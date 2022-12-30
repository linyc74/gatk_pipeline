version 1.0

import "SomaticPipelineTumorNormalMode.wdl" as main

# WORKFLOW DEFINITION

# 'Workflow description'
workflow ScatterSomaticpipelineTumorNormalMode {
    input {
        Array[Array[File]] inFileTumorFastqs
        Array[Array[File]] inFileNormalFastqs
        File inFileDbsnpVcf
        File inFileDbsnpVcfIndex
        File inFileIntervalBed
        File inFileGermlineResource
        File inFileGermlineResourceIndex
        File inFilePON
        File inFilePONindex
        File inDirPCGRref
        File refAmb
        File refAnn
        File refBwt
        File refPac
        File refSa
        File refFa
        File refFai
        File refDict
        String libraryKit
        Array[String] tumorSampleName
        Array[String] normalSampleName
        Array[String] finalOutputName
    }

    scatter (i in range(length(finalOutputName))) {
        Array[File] iFTFs = inFileTumorFastqs[i]
        Array[File] iFNFs = inFileNormalFastqs[i]
        String tSN = tumorSampleName[i]
        String nSN = normalSampleName[i]
        String fON = finalOutputName[i]

        call main.SomaticPipelineTumorNormalMode {
            input:
                inFileTumorFastqs = iFTFs,
                inFileNormalFastqs = iFNFs,
                inFileDbsnpVcf = inFileDbsnpVcf,
                inFileDbsnpVcfIndex = inFileDbsnpVcfIndex,
                inFileIntervalBed = inFileIntervalBed,
                inFileGermlineResource = inFileGermlineResource,
                inFileGermlineResourceIndex = inFileGermlineResourceIndex,
                inFilePON = inFilePON,
                inFilePONindex = inFilePONindex,
                inDirPCGRref = inDirPCGRref,
                refAmb = refAmb,
                refAnn = refAnn,
                refBwt = refBwt,
                refPac = refPac,
                refSa = refSa,
                refFa = refFa,
                refFai = refFai,
                refDict = refDict,
                vardictMinimumAF = 0.01,
                libraryKit = libraryKit,
                tumorSampleName = tSN,
                normalSampleName = nSN,
                finalOutputName = fON
        }
    }
 
    output {
        Array[Array[File]] outFileTumorFastqs = SomaticPipelineTumorNormalMode.outFileTumorFastqs
        Array[Array[File]] outFileNormalFastqs = SomaticPipelineTumorNormalMode.outFileNormalFastqs
        Array[Array[File]] outFileTumorFastqcHtmls = SomaticPipelineTumorNormalMode.outFileTumorFastqcHtmls
        Array[Array[File]] outFileNormalFastqcHtmls = SomaticPipelineTumorNormalMode.outFileNormalFastqcHtmls
        Array[Array[File]] outFileTumorFastqcZips = SomaticPipelineTumorNormalMode.outFileTumorFastqcZips
        Array[Array[File]] outFileNormalFastqcZips = SomaticPipelineTumorNormalMode.outFileNormalFastqcZips
        Array[File] outFileTumorBam = SomaticPipelineTumorNormalMode.outFileTumorBam
        Array[File] outFileNormalBam = SomaticPipelineTumorNormalMode.outFileNormalBam
        Array[File] outFileTumorBamIndex = SomaticPipelineTumorNormalMode.outFileTumorBamIndex
        Array[File] outFileNormalBamIndex = SomaticPipelineTumorNormalMode.outFileNormalBamIndex
        Array[File] outFileTumorRawBam = SomaticPipelineTumorNormalMode.outFileTumorRawBam
        Array[File] outFileNormalRawBam = SomaticPipelineTumorNormalMode.outFileNormalRawBam
        Array[File] outFileStatsTumorBam = SomaticPipelineTumorNormalMode.outFileStatsTumorBam
        Array[File] outFileStatsNormalBam = SomaticPipelineTumorNormalMode.outFileStatsNormalBam
        Array[File] outFileBamsomaticsniperPyVcfGz = SomaticPipelineTumorNormalMode.outFileBamsomaticsniperPyVcfGz
        Array[File] outFileBamsomaticsniperPyVcfIndex = SomaticPipelineTumorNormalMode.outFileBamsomaticsniperPyVcfIndex
        Array[File] outFileLofreqPyVcfGz = SomaticPipelineTumorNormalMode.outFileLofreqPyVcfGz
        Array[File] outFileLofreqPyVcfIndex = SomaticPipelineTumorNormalMode.outFileLofreqPyVcfIndex
        Array[File] outFileMusePyVcfGz = SomaticPipelineTumorNormalMode.outFileMusePyVcfGz
        Array[File] outFileMusePyVcfIndex = SomaticPipelineTumorNormalMode.outFileMusePyVcfIndex
        Array[File] outFileMutect2PyVcfGz = SomaticPipelineTumorNormalMode.outFileMutect2PyVcfGz
        Array[File] outFileMutect2PyVcfIndex = SomaticPipelineTumorNormalMode.outFileMutect2PyVcfIndex
        Array[File] outFileVardictPyVcfGz = SomaticPipelineTumorNormalMode.outFileVardictPyVcfGz
        Array[File] outFileVardictPyVcfIndex = SomaticPipelineTumorNormalMode.outFileVardictPyVcfIndex
        Array[File] outFileVarscanPyVcfGz = SomaticPipelineTumorNormalMode.outFileVarscanPyVcfGz
        Array[File] outFileVarscanPyVcfIndex = SomaticPipelineTumorNormalMode.outFileVarscanPyVcfIndex
        Array[File] outFileBamsomaticsniperVcfGz = SomaticPipelineTumorNormalMode.outFileBamsomaticsniperVcfGz
        Array[File] outFileBamsomaticsniperVcfIndex = SomaticPipelineTumorNormalMode.outFileBamsomaticsniperVcfIndex
        Array[File] outFileLofreqVcfGz = SomaticPipelineTumorNormalMode.outFileLofreqVcfGz
        Array[File] outFileLofreqVcfIndex = SomaticPipelineTumorNormalMode.outFileLofreqVcfIndex
        Array[File] outFileMuseVcfGz = SomaticPipelineTumorNormalMode.outFileMuseVcfGz
        Array[File] outFileMuseVcfIndex = SomaticPipelineTumorNormalMode.outFileMuseVcfIndex
        Array[File] outFileMutect2VcfGz = SomaticPipelineTumorNormalMode.outFileMutect2VcfGz
        Array[File] outFileMutect2VcfIndex = SomaticPipelineTumorNormalMode.outFileMutect2VcfIndex
        Array[File] outFileVardictVcfGz = SomaticPipelineTumorNormalMode.outFileVardictVcfGz
        Array[File] outFileVardictVcfIndex = SomaticPipelineTumorNormalMode.outFileVardictVcfIndex
        Array[File] outFileVarscanVcfGz = SomaticPipelineTumorNormalMode.outFileVarscanVcfGz
        Array[File] outFileVarscanVcfIndex = SomaticPipelineTumorNormalMode.outFileVarscanVcfIndex
        Array[File] outFileAnnotatedVcf = SomaticPipelineTumorNormalMode.outFileAnnotatedVcf
        Array[File] outFileAnnotatedVcfIndex = SomaticPipelineTumorNormalMode.outFileAnnotatedVcfIndex
        Array[File] outFileMaf = SomaticPipelineTumorNormalMode.outFileMaf
        Array[File] outFilePCGRflexdbHtml = SomaticPipelineTumorNormalMode.outFilePCGRflexdbHtml
        Array[File] outFilePCGRhtml = SomaticPipelineTumorNormalMode.outFilePCGRhtml
    }
}