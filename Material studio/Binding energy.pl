#!perl
use strict;
use Getopt::Long;
use MaterialsScript qw(:all);

my $doc = $Documents{"quartzbulk.xtd"};

my $newStudyTable = Documents->New("InteractionEnergy.std");
my $calcSheet = $newStudyTable->ActiveSheet;
$calcSheet->ColumnHeading(0) = "Cell";
$calcSheet->ColumnHeading(1) = "Total Energy of Cell";
$calcSheet->ColumnHeading(2) = "ElectrostaticEnergy of Cell";
$calcSheet->ColumnHeading(3) = "VanDerWaalsEnergy of Cell";
$calcSheet->ColumnHeading(4) = "Layer1";
$calcSheet->ColumnHeading(5) = "Energy of Layer1";
$calcSheet->ColumnHeading(6) = "ElectrostaticEnergy of Layer1";
$calcSheet->ColumnHeading(7) = "VanDerWaalsEnergy of Layer1";
$calcSheet->ColumnHeading(8) = "Layer2";
$calcSheet->ColumnHeading(9) = "Energy of Layer2";
$calcSheet->ColumnHeading(10) = "ElectrostaticEnergy of Layer2";
$calcSheet->ColumnHeading(11) = "VanDerWaalsEnergy of Layer2";
$calcSheet->ColumnHeading(12) = "Interaction Energy";
$calcSheet->ColumnHeading(13) = "Interaction Energy per angstrom^2";
$calcSheet->ColumnHeading(14) = "Interaction Energy_ele";
$calcSheet->ColumnHeading(15) = "Interaction Energy_vdw";

my $forcite = Modules->Forcite;
$forcite->ChangeSettings(Settings(
	Quality => "Ultra-fine", 
	"3DPeriodicvdWSummationMethod" => "Ewald", 
	"3DPeriodicElectrostaticSummationMethod" => "Atom based", 
	CurrentForcefield => "COMPASSII"));

my $lengthA = $doc->Lattice3D->LengthA;
my $lengthB = $doc->Lattice3D->LengthB;
my $surfaceArea = $lengthA * $lengthB;
print "The surface area is $surfaceArea angstrom^2\n";

my $numFrames = $doc->Trajectory->NumFrames;
print "Number of frames being analyzed is $numFrames\n";

for (my $counter = 1; $counter <= $numFrames; ++$counter) {
	$doc->Trajectory->CurrentFrame = $counter;
	
	my $allDoc = Documents->New("all.xsd");
	my $layer1Doc = Documents->New("layer1.xsd");
	my $layer2Doc = Documents->New("layer2.xsd");
	$allDoc->CopyFrom($doc);
	$allDoc->AsymmetricUnit->Atoms->Unfix("XYZ");

	$layer1Doc->CopyFrom($doc);
	$layer1Doc->UnitCell->Sets("Layer2")->Atoms->Delete; 
	$layer1Doc->AsymmetricUnit->Atoms->Unfix("XYZ");
	
	$layer2Doc->CopyFrom($doc);
	$layer2Doc->UnitCell->Sets("Layer1")->Atoms->Delete; 
	$layer2Doc->AsymmetricUnit->Atoms->Unfix("XYZ");

	#$calcSheet->Cell($counter-1,0) = $allDoc;
	#$calcSheet->Cell($counter-1,4) = $layer1Doc;
	#$calcSheet->Cell($counter-1,8) = $layer2Doc;
	
	$forcite->Energy->Run($allDoc);
	$calcSheet->Cell($counter-1, 1) = $allDoc->PotentialEnergy; 
	$calcSheet->Cell($counter-1, 2) = $allDoc->ElectrostaticEnergy; 
	$calcSheet->Cell($counter-1, 3) = $allDoc->VanDerWaalsEnergy; 

	$forcite->Energy->Run($layer1Doc);
	$calcSheet->Cell($counter-1, 5) = $layer1Doc->PotentialEnergy; 
	$calcSheet->Cell($counter-1, 6) = $layer1Doc->ElectrostaticEnergy; 
	$calcSheet->Cell($counter-1, 7) = $layer1Doc->VanDerWaalsEnergy; 
	
	$forcite->Energy->Run($layer2Doc);
	$calcSheet->Cell($counter-1, 9) = $layer2Doc->PotentialEnergy; 
	$calcSheet->Cell($counter-1, 10) = $layer2Doc->ElectrostaticEnergy; 
	$calcSheet->Cell($counter-1, 11) = $layer2Doc->VanDerWaalsEnergy; 
	
	my $totalEnergy = $calcSheet->Cell($counter-1, 1);
	my $layer1Energy = $calcSheet->Cell($counter-1, 5);
	my $layer2Energy = $calcSheet->Cell($counter-1, 9);
	my $totalEnergy_ele = $calcSheet->Cell($counter-1, 2);
	my $layer1Energy_ele = $calcSheet->Cell($counter-1, 6);
	my $layer2Energy_ele = $calcSheet->Cell($counter-1, 10);
	my $totalEnergy_vdw = $calcSheet->Cell($counter-1, 3);
	my $layer1Energy_vdw = $calcSheet->Cell($counter-1, 7);
	my $layer2Energy_vdw = $calcSheet->Cell($counter-1, 11);

	my $interactionEnergy = $totalEnergy - ($layer1Energy + $layer2Energy);
	$calcSheet->Cell($counter-1, 12) = $interactionEnergy;
	my $interactionEnergy_ele = $totalEnergy_ele - ($layer1Energy_ele + $layer2Energy_ele);
	$calcSheet->Cell($counter-1, 14) = $interactionEnergy_ele;
	my $interactionEnergy_vdw = $totalEnergy_vdw - ($layer1Energy_vdw + $layer2Energy_vdw);
	$calcSheet->Cell($counter-1, 15) = $interactionEnergy_vdw;

	my $interactionEnergyArea = $interactionEnergy / $surfaceArea;
	$calcSheet->Cell($counter-1, 13) = $interactionEnergyArea;
	
	$allDoc->Discard; 
	$layer1Doc->Discard;
	$layer2Doc->Discard;
	
} 
