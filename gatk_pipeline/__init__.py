import os
from .template import Settings
from .gatk_pipeline import GATKPipeline


class Main:

    ref_fa: str
    tumor_fq1: str
    tumor_fq2: str
    normal_fq1: str
    normal_fq2: str

    settings: Settings

    def main(
            self,
            ref_fa: str,
            tumor_fq1: str,
            tumor_fq2: str,
            normal_fq1: str,
            normal_fq2: str,
            outdir: str,
            threads: str,
            debug: bool):

        self.ref_fa = ref_fa
        self.tumor_fq1 = tumor_fq1
        self.tumor_fq2 = tumor_fq2
        self.normal_fq1 = normal_fq1
        self.normal_fq2 = normal_fq2

        self.settings = Settings(
            workdir='./gatk_pipeline_workdir',
            outdir=outdir,
            threads=int(threads),
            debug=debug,
            mock=False)

        for d in [self.settings.workdir, self.settings.outdir]:
            os.makedirs(d, exist_ok=True)

        GATKPipeline(self.settings).main(
            ref_fa=self.ref_fa,
            tumor_fq1=self.tumor_fq1,
            tumor_fq2=self.tumor_fq2,
            normal_fq1=self.normal_fq1,
            normal_fq2=self.normal_fq2)
