import os
from typing import List, Optional
from .tools import edit_fpath
from .template import Processor


class ComputeCNV(Processor):

    ref_fa: str
    tumor_bam: str
    normal_bam: Optional[str]
    exome_target_bed: Optional[str]
    annotate_txt: Optional[str]

    def main(
            self,
            ref_fa: str,
            tumor_bam: str,
            normal_bam: Optional[str],
            exome_target_bed: Optional[str],
            annotate_txt: Optional[str]):

        self.ref_fa = ref_fa
        self.tumor_bam = tumor_bam
        self.normal_bam = normal_bam
        self.exome_target_bed = exome_target_bed
        self.annotate_txt = annotate_txt

        if self.normal_bam is None:
            self.logger.info(f'Normal sample not provided, skip CNV calculation')
            return

        self.clean_up_bed()
        self.run_cnvkit()

    def clean_up_bed(self):
        if self.exome_target_bed is not None:
            self.exome_target_bed = CleanUpBed(self.settings).main(
                bed=self.exome_target_bed)

    def run_cnvkit(self):
        CNVkitBatch(self.settings).main(
            ref_fa=self.ref_fa,
            tumor_bam=self.tumor_bam,
            normal_bam=self.normal_bam,
            exome_target_bed=self.exome_target_bed,
            annotate_txt=self.annotate_txt)


class CleanUpBed(Processor):

    bed: str

    output_bed: str

    def main(self, bed: str) -> str:
        self.bed = bed
        self.set_output_bed()
        self.clean_up()
        return self.output_bed

    def set_output_bed(self):
        self.output_bed = edit_fpath(
            fpath=self.bed,
            old_suffix='.bed',
            new_suffix='-clean.bed',
            dstdir=self.workdir)

    def clean_up(self):
        with open(self.bed) as reader:
            with open(self.output_bed, 'w') as writer:
                for line in reader:
                    fields = len(line.strip().split('\t'))
                    if fields >= 3:
                        writer.write(line)


class CNVkitBatch(Processor):

    DSTDIR_NAME = 'cnvkit'

    # the default segment method 'cbs' requires R package DNAcopy, which was hard to install
    # thus the 'hmm-tumor' (which depends on 'pomegranate') was chosen
    SEGMENT_METHOD = 'hmm-tumor'

    ref_fa: str
    tumor_bam: str
    normal_bam: str
    exome_target_bed: Optional[str]
    annotate_txt: Optional[str]

    dstdir: str
    mode_args: List[str]
    annotate_args: List[str]

    def main(
            self,
            ref_fa: str,
            tumor_bam: str,
            normal_bam: str,
            exome_target_bed: Optional[str],
            annotate_txt: Optional[str]):

        self.ref_fa = ref_fa
        self.tumor_bam = tumor_bam
        self.normal_bam = normal_bam
        self.exome_target_bed = exome_target_bed
        self.annotate_txt = annotate_txt

        self.make_dstdir()
        self.set_mode_args()
        self.set_annotate_args()
        self.execute()

    def make_dstdir(self):
        self.dstdir = f'{self.outdir}/{self.DSTDIR_NAME}'
        os.makedirs(self.dstdir, exist_ok=True)

    def set_mode_args(self):
        if self.exome_target_bed is None:
            mode = 'wgs'
            self.mode_args = [f'-m {mode}']
        else:
            mode = 'hybrid'
            self.mode_args = [
                f'-m {mode}',
                f'--targets {self.exome_target_bed}'
            ]

    def set_annotate_args(self):
        self.annotate_args = [] \
            if self.annotate_txt is None \
            else [f'--annotate {self.annotate_txt}']

    def execute(self):
        log = f'{self.outdir}/cnvkit-batch.log'
        args = [
            'cnvkit.py batch',
            f'--normal {self.normal_bam}',
            f'--fasta {self.ref_fa}',
        ] + self.annotate_args + self.mode_args + [
            f'--segment-method {self.SEGMENT_METHOD}',
            f'--output-dir {self.dstdir}',
            f'--processes {self.threads}',
            '--scatter',
            self.tumor_bam,
            f'1> {log}',
            f'2> {log}',
        ]
        cmd = self.CMD_LINEBREAK.join(args)
        self.call(cmd)
