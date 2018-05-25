#!perl

use strict;
use Getopt::Long;
use MaterialsScript qw(:all);

my $doc = $Documents{"Quartz_2D1V175_175.xtd"};

my $newStudyTable = Documents->New("MSD.std");
my $calcSheet = $newStudyTable->ActiveSheet;
$calcSheet->ColumnHeading(0) = "Time";
$calcSheet->ColumnHeading(1) = "10-61";
$calcSheet->ColumnHeading(2) = "20-71";
$calcSheet->ColumnHeading(3) = "30-81";
$calcSheet->ColumnHeading(4) = "40-91";
$calcSheet->ColumnHeading(5) = "50-101";
$calcSheet->ColumnHeading(6) = "MSDaverage";

foreach my $a ("10-61","20-71","30-81","40-91","50-101") {
	my $results = Modules->Forcite->Analysis->MeanSquareDisplacement($doc, Settings(
		ActiveDocumentFrameRange => $a, 
		MSDMaxFrameLength => 99.0099, 
		MSDComputeAnisotropicComponents => "No", 
		MSDSetA => "Layer2"));
	my $outMSDChartAsStudyTable = $results->MSDChartAsStudyTable;
	my $outMSDChart = $results->MSDChart;
	for (my $i=0; $i<$outMSDChartAsStudyTable->RowCount; ++$i) {
    	$calcSheet->Cell($i, "Time") = $results->MSDChartAsStudyTable->Cell($i, "Time");
		$calcSheet->Cell($i, $a) = $results->MSDChartAsStudyTable->Cell($i, "MSD");
	}
		
	$outMSDChartAsStudyTable->Discard;
	$outMSDChart->Discard;

}

for (my $i=0; $i<$newStudyTable->RowCount; ++$i) {
	my $a = $calcSheet->Cell($i, "10-61");
	my $b = $calcSheet->Cell($i, "20-71");
	my $c = $calcSheet->Cell($i, "30-81");
	my $d = $calcSheet->Cell($i, "40-91");
	my $e = $calcSheet->Cell($i, "50-101");
	$calcSheet->Cell($i, "MSDaverage") = ($a + $b + $c + $d + $e) / 5;

}
