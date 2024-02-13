from somatic_pipeline.twist_mapping import TwistMapping
from .setup import TestCase


class TestTwistMapping(TestCase):

    def setUp(self):
        self.set_up(py_path=__file__)

    def tearDown(self):
        self.tear_down()

    def test_main(self):
        TwistMapping(self.settings).main(
            ref_fa=f'{self.indir}/chr9.fa',
            fq1=f'{self.indir}/twist_tiny_tumor_R1.fastq.gz',
            fq2=f'{self.indir}/twist_tiny_tumor_R2.fastq.gz',
            sample_name='twist_tiny_tumor'
        )
