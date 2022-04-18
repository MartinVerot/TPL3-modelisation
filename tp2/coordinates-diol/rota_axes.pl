#!/usr/bin/perl
use strict;
use warnings;
use Cwd;
  use Math::Trig ':radial';
use Math::Trig ':pi';
#ouverture des fichiers d'entrée pour le singulet et le triplet
	open(my $input_s,  "<",  "$ARGV[0]")  or die "Can't open input: $!";
#ouverture du fichier de sortie
	open(my $out, ">",  "$ARGV[0].xyz") or die "Can't open output.txt: $!";
my $num_ligne=0;
my @tableau_reor = ();
my $nb_atomes=1;
my $current_working_directory = getcwd();
my $i;my $x;my $y;my $z;
my $l_x;my $l_y;my $l_z;

##################################################################################
my $j;my $k;
#Multiplication de matrice
sub matrix_multiply {
    my ($r_mat1,$r_mat2)=@_;
    my ($r_product);
    my ($r1,$c1)=matrix_count_rows_cols($r_mat1);
    my ($r2,$c2)=matrix_count_rows_cols($r_mat2);
    
    die "matrix 1 has $c1 columns and matrix 2 has $r2 rows>" 
        . " Cannot multiply\n" unless ($c1==$r2);
    for (my $i=0;$i<$r1;$i++) {
        for (my $j=0;$j<$c2;$j++) {
            my $sum=0;
            for (my $k=0;$k<$c1;$k++) {
                $sum+=$r_mat1->[$i][$k]*$r_mat2->[$k][$j];
            }
            $r_product->[$i][$j]=$sum;
        }
    }
    $r_product;
}


sub matrix_add {
    my ($r_mat1,$r_mat2)=@_;
    my ($r_add);
    my ($r1,$c1)=matrix_count_rows_cols($r_mat1);
    my ($r2,$c2)=matrix_count_rows_cols($r_mat2);
    
    die "matrix 1 has $c1 columns and matrix 2 has $r2 rows>" 
        . " Cannot multiply\n" unless ($c1==$c2 && $r1==$r2);
   for (my $i=0;$i<$r1;$i++) 
	{
	   for (my $j=0;$j<$c1;$j++) 
		{
			$r_add->[$i][$j]=$r_mat1->[$i][$j]+$r_mat2->[$i][$j];
   	}
   }
   $r_add;
}


sub matrix_multiply_scalar {
    my ($r_mat1,$scalar)=@_;
    my ($r_prod);
    my ($r1,$c1)=matrix_count_rows_cols($r_mat1);
   for (my $i=0;$i<$r1;$i++) 
	{
	   for (my $j=0;$j<$c1;$j++) 
		{
			$r_prod->[$i][$j]=$r_mat1->[$i][$j]*$scalar;
   	}
   }
   $r_prod;
}



sub matrix_transpose {
	my ($r_mat1)=@_;
	my ($r_transpo);
	my ($r1,$c1)=matrix_count_rows_cols($r_mat1);
	for (my $i=0;$i<$r1;$i++) 
	{
		for (my $k=0;$k<$c1;$k++) 
			{
				$r_transpo->[$i][$k]=$r_mat1->[$k][$i];
			}
	}
	$r_transpo;
}

#Calcul des dimensions de la matrice
sub matrix_count_rows_cols { 
    my ($r_mat)=@_;
    my $num_rows=@$r_mat;
    my $num_cols=@{$r_mat->[0]};
    ($num_rows,$num_cols);
}


##################################################################################


while (<$input_s>) 
{ 
#Si la ligne est une ligne de coordonnées, on la lit, puis on regarde si il y a déjà un atome de ce type dans le tableau, si oui, on le rajoute à la suite des atomes de même type, sinon, on crée une nouvelle ligne pour le nouveau type d'atomes
if($num_ligne>1 && /([A-Za-z]{1,2})\s*([\d\-\.\+]*)\s*([\+\d\-\.]*)\s*([\+\d\-\.]*)/)
	{
# $2 ancien $x $3 ancien y $4 ancien z
		$x=$2;
		$y=$3;
		$z=$4;
		$tableau_reor[$nb_atomes][0]=$x;
		$tableau_reor[$nb_atomes][1]=$y;
		$tableau_reor[$nb_atomes][2]=$z;
		$tableau_reor[$nb_atomes][3]=$1;
		$nb_atomes++;
	}
if($num_ligne<2){print $out "$_";}
$num_ligne++;
}
$nb_atomes--;
for($i=1;$i<=$nb_atomes;$i++)
{
	#print $tableau_reor[$i][3]."\t".$tableau_reor[$i][0]."\t".$tableau_reor[$i][1]."\t".$tableau_reor[$i][2]."\n";
}


#on translate tout pour que l'atome numéro 1 soit en (0,0,0) on va en descendant pour éviter que le premier atome soit à l'origine puis que les suivants ne soient plus translatés.
for($i=$nb_atomes;$i>=1;$i--)
{
	$tableau_reor[$i][0]-=$tableau_reor[1][0];
	$tableau_reor[$i][1]-=$tableau_reor[1][1];
	$tableau_reor[$i][2]-=$tableau_reor[1][2];	
}
#print "Coordonnées translatées\n";
for($i=1;$i<=$nb_atomes;$i++)
{
	#print $tableau_reor[$i][3]."\t".$tableau_reor[$i][0]."\t".$tableau_reor[$i][1]."\t".$tableau_reor[$i][2]."\n";
}

my $rho; my $theta;my $phi;
($rho, $theta, $phi)   = cartesian_to_spherical($tableau_reor[2][0], $tableau_reor[2][1], $tableau_reor[2][2]);
 #print cos(-$phi)."\t".sin(-$phi)."\n";
#print $tableau_reor[2][0]."\t".$tableau_reor[2][1]."\t".$tableau_reor[2][2]."\n";
#print $rho."\t".$theta."\t pi/2".pip2."phi".$phi."\n";



#On créee la matrice de rotation d'angle -phi autour de z
my @matrice_rota;
$matrice_rota[0][0]=cos(-$theta)	;$matrice_rota[0][1]=-sin(-$theta)	;$matrice_rota[0][2]=0;
$matrice_rota[1][0]=sin(-$theta)	;$matrice_rota[1][1]=cos(-$theta)	;$matrice_rota[1][2]=0;
$matrice_rota[2][0]=0			;$matrice_rota[2][1]=0				;$matrice_rota[2][2]=1;


my @vecteur;
for($i=1;$i<=$nb_atomes;$i++)
{
	#création du vecteur correspondant au coordonnées de l'atome
	$vecteur[0][0]=$tableau_reor[$i][0];
	$vecteur[1][0]=$tableau_reor[$i][1];
	$vecteur[2][0]=$tableau_reor[$i][2];
	my $vecteur_rota=matrix_multiply(\@matrice_rota,\@vecteur);
	
	$tableau_reor[$i][0]=sprintf("%.7f", $vecteur_rota->[0][0]);
	$tableau_reor[$i][1]=sprintf("%.7f", $vecteur_rota->[1][0]);
	$tableau_reor[$i][2]=sprintf("%.7f", $vecteur_rota->[2][0]);
}
#print "Coordonnées après rotation de -phi autour de z\n";
for($i=1;$i<=$nb_atomes;$i++)
{
	#print $tableau_reor[$i][3]."\t".$tableau_reor[$i][0]."\t".$tableau_reor[$i][1]."\t".$tableau_reor[$i][2]."\n";
}
($rho, $theta, $phi)   = cartesian_to_spherical($tableau_reor[2][0], $tableau_reor[2][1], $tableau_reor[2][2]);

#On créee la matrice de rotation d'angle pi/2-theta autour de y
my $alpha;
$alpha=pip2-$phi;
#$alpha=-pip2+$phi;
#print $rho."\t".$theta."\t pi/2".pip2."phi".$phi."\n";
#print "alpha : $alpha";
$theta=$alpha;
my @matrice_rota_t;
$matrice_rota_t[0][0]=cos($theta)	;$matrice_rota_t[0][1]=0		;$matrice_rota_t[0][2]=sin($theta);
$matrice_rota_t[1][0]=0			;$matrice_rota_t[1][1]=1		;$matrice_rota_t[1][2]=0;
$matrice_rota_t[2][0]=-sin($theta)	;$matrice_rota_t[2][1]=0		;$matrice_rota_t[2][2]=cos($theta);

for($i=1;$i<=$nb_atomes;$i++)
{
	#création du vecteur correspondant au coordonnées de l'atome
	$vecteur[0][0]=$tableau_reor[$i][0];
	$vecteur[1][0]=$tableau_reor[$i][1];
	$vecteur[2][0]=$tableau_reor[$i][2];
	my $vecteur_rota=matrix_multiply(\@matrice_rota_t,\@vecteur);
	
	$tableau_reor[$i][0]=sprintf("%.7f", $vecteur_rota->[0][0]);
	$tableau_reor[$i][1]=sprintf("%.7f", $vecteur_rota->[1][0]);
	$tableau_reor[$i][2]=sprintf("%.7f", $vecteur_rota->[2][0]);
}
#print "\n\n";
#print "Coordonnées après rotation de pi/2-theta autour de x\n";
for($i=1;$i<=$nb_atomes;$i++)
{
#	print $tableau_reor[$i][3]."\t".$tableau_reor[$i][0]."\t".$tableau_reor[$i][1]."\t".$tableau_reor[$i][2]."\n";

}

#On se met en coordonnées cylindriques d'axe x.
 ($rho, $theta, $x)     = cartesian_to_cylindrical($tableau_reor[3][1], $tableau_reor[3][2], $tableau_reor[3][0]); 
#print $rho."\t".$theta."\t".$x."\n";

#on va faire une rotation d'angle -theta autour de x pour ramener le deuxième atome dans le plan.

my @matrice_rota_cyl;
$matrice_rota_cyl[0][0]=1		;$matrice_rota_cyl[0][1]=0		;$matrice_rota_cyl[0][2]=0;
$matrice_rota_cyl[1][0]=0		;$matrice_rota_cyl[1][1]=cos($theta)	;$matrice_rota_cyl[1][2]=sin($theta);
$matrice_rota_cyl[2][0]=0		;$matrice_rota_cyl[2][1]=-sin($theta)	;$matrice_rota_cyl[2][2]=cos($theta);

for($i=1;$i<=$nb_atomes;$i++)
{
	#création du vecteur correspondant au coordonnées de l'atome
	$vecteur[0][0]=$tableau_reor[$i][0];
	$vecteur[1][0]=$tableau_reor[$i][1];
	$vecteur[2][0]=$tableau_reor[$i][2];
	my $vecteur_rota=matrix_multiply(\@matrice_rota_cyl,\@vecteur);
	
	$tableau_reor[$i][0]=sprintf("%.7f", $vecteur_rota->[0][0]);
	$tableau_reor[$i][1]=sprintf("%.7f", $vecteur_rota->[1][0]);
	$tableau_reor[$i][2]=sprintf("%.7f", $vecteur_rota->[2][0]);
}
#print "Coordonnées après rotation de -theta autour de x en cylindrique\n";
for($i=1;$i<=$nb_atomes;$i++)
{
	#print $tableau_reor[$i][3]."\t".$tableau_reor[$i][0]."\t".$tableau_reor[$i][1]."\t".$tableau_reor[$i][2]."\n";
}

for($i=1;$i<=$nb_atomes;$i++)
{
print $out $tableau_reor[$i][3]."\t".$tableau_reor[$i][0]."\t".$tableau_reor[$i][1]."\t".$tableau_reor[$i][2]."\n";

}
