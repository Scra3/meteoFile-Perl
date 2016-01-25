use strict;
use warnings;
use Switch;
use 5.010;

# Déclaration des fonctions 
sub affichage;
sub recherche_Temperature;
sub recherche_Ville;
sub recherche_TemperatureMax;
sub recherche_TemperatureMin;
sub enregistrer_quitter;
#Questions utilisateur

my $quitter = 0; 
my @affichage=@_;

while($quitter !=1)
	{
	print "Que voulez vous faire ALBAN BERTOLINI: \n 
	1. Recherche des températures entre la date A et la date B
	2. Recherche d’une ville
	3. Recherche de la journée la plus froide
	4. Recherche de la journée la plus chaude
	5. Enregistrer et quitter \n";

	my $nb = <>;
	chomp $nb;

	if( -e "meteoTexte" ) {
		# Ouvrir le fichier
		open(FIC, "<", "meteoTexte") 
		or die "Impossible d'ouvrir le fichier < meteoTexte.txt: $!";
			switch($nb)
			{
				case 1 { recherche_Temperature(); }
				case 2 { recherche_Ville();}
				case 3 { recherche_TemperatureMin();}
				case 4 { recherche_TemperatureMax();}
				case 5 { $quitter = enregistrer_quitter();}
			}
	}
	else 
	{
		print "Pas de meteo\n";
	}
}

#Définition des fonctions 
sub recherche_Ville{

	print "Recherche d'une ville \nVeuillez saisir le nom de la ville \n";
	my $ville; 
	$ville = <>;
	chomp $ville;
	my @resultat ;
	while (my $ligne =  <FIC> ){
				if ($ligne =~ /^$ville.*/){
					push @resultat,$ligne;
				}
	}
	if(!@resultat){
		print " \nPas d'information sur la ville : ".$ville."\n";
	}
	# affichage 
	affichage(@resultat);
};

#fonction traduction mois
sub traduction_Mois{
	my ($mois) = @_;

	use constant {
	    JANVIER => 1,
	    FEVRIER => 2,
	    MARS => 3,
	    AVRIL => 4,
	    MAI => 5,
	    JUIN => 6,
	    JUILLET => 7,
	    AOUT => 8,
	    SEPTEBMRE => 9,
	    OCTOBRE => 10,
	    NOVEMBRE => 11,
	    DECEMBRE => 12
	};
	switch($mois)
	{
		case "Janvier" { $mois = JANVIER;}
		case "Fevrier" { $mois = FEVRIER;}
		case "Mars" {$mois = MARS;}
		case "Avril" {$mois = AVRIL;}
		case "Mai" {$mois = MAI;}
		case "Juin" {$mois = JUIN;}
		case "Juillet" {$mois=JUILLET;}
		case "Aout" {$mois = AOUT;}
		case "Septembre" {$mois = SEPTEBMRE;}
		case "Octobre" {$mois = OCTOBRE;}
		case "Novembre" {$mois = NOVEMBRE;}
		case "Decembre" {$mois = DECEMBRE;}
	}

	return $mois;
}
#fonction recherche de recherche_Temperature
sub recherche_Temperature{
	my $dateA;
	my $dateB;
	my $annee1;
	my $mois1;
	my $jour1;
	my $annee2;
	my $mois2;
	my $jour2;
	my $date = 0; # vérification de la date
	my @resultat;

	
	# date 1
	print "Format de la Date : (4 caractères, entre 1900 et 2100), le mois (entre 1 et 12) et le jour (entre 1 et 31) \n\nSaisir l'année de la date A : \n";
	print "Saisir date A\n";
	$dateA = <>;
	print "Saisir date B\n";
	$dateB =<>;
	chomp $dateA;
	chomp $dateB;

	# verification de la grammaire des dates 
	if($dateA=~/.*([1-9][0-9]{3})\s([A-Z][a-z]*)\s([0-9]{1,2})/	)
	{
		$annee1 = $1;
		$mois1 = $2;
		$jour1 = $3;
		$dateA = 1;
	}
	else{
		$dateA = 0;
	}
	if($dateB=~/.*([1-9][0-9]{3})\s([A-Z][a-z]*)\s([0-9]{1,2})/)
	{
		$annee2 = $1;
		$mois2 = $2;
		$jour2 = $3;
		$dateB = 1;
	}
	else{
		$dateB = 0;
	}
	
	#Traduction des mois en entier
	$mois1=traduction_Mois($mois1);
	$mois2=traduction_Mois($mois2);

	if($dateB == 1 && $dateA == 1 && $annee1 >= 1900 && $annee2 <= 2100 && $annee2 >= $annee1 && $mois1 >= 1 && $mois1 <= 12 && $jour1 >=1 && $jour1 <= 31 && $mois2 >= 1 && $mois2 <= 12 && $jour2 >=1 && $jour2 <= 31){
		if($annee1 < $annee2){
			$date = 1; # date a < date b 
		}
		elsif ($annee1 == $annee2){
				if($mois1 < $mois2){
					$date = 1; # date a < date b 
				}
				elsif($mois1 == $mois2 ){
					if($jour1 < $jour2){
						$date = 1; # date a < date b 
					}
					elsif($jour1==$jour2){
							$date = 1;
					}
				}
			}
		if($date ==1){
			print "Lancement de la recherche des températures entre la date A et la date B \n";
			my @resultat ;
			while (my $ligne =  <FIC> ){
					if ($ligne =~ /.*([1-2][0-9]{3})\s*([0-9]{1,2})\s*([0-9]{1,2})/){
						# on récupère la date courante
							#année
							my $annee = $1;
							#mois
							my $mois = $2;
							#jours
							my $jour = $3;
						# on vérifie si elle est dans l'intervalle des dates A et B
							if($annee1<$annee && $annee<$annee2)
							{
								push @resultat,$ligne;
							}
							elsif($annee1 == $annee){
								if ($mois1 < $mois && $mois < $mois2) {
									push @resultat,$ligne;
								}
								elsif($mois1==$mois){
									if ($jour1<=$jour && $jour<=$jour2) {
										push @resultat,$ligne;
									}
								}
							}
					}
			}
			if(!@resultat){
				print "\nPas d'information sur les dates données\n";
			}
			else{
				affichage(@resultat);
			}

		}
		else{
			print "La date A est plus grande que la date B \n";
		}
	}
	else{
			print "Saisie incorrecte \n";
		}		
};

#fonction enregistrer et quitter
sub enregistrer_quitter{
	print "\n Enregistrer et quitter \n";
	if (@affichage){
		open(FILE,">recherche.txt");
		print "\nEnregistrement de la dernière recherche\n";
		foreach my $tab (@affichage){
			print FILE $tab; 
		}
		close (FILE);
	}
	print "Fin des recherches\n";
	return $quitter = 1;
};
#fonction recherche de la journée la plus froide
sub recherche_TemperatureMin{
	print "\nRecherche de la journée la plus froide \n ";
	my @resultat;
	my $min ;
	my $premierTour = 0;
	while (my $ligne =  <FIC> ){
			if ($ligne =~ /([0-9]{1,2})$/){
				if($premierTour == 0){
					$min = $1;
					$premierTour = 1;
				}
				if ($min > $1){
					$min = $1;
					@resultat=();
				}
				if ($min == $1){
					push @resultat,$ligne ;
				}
			}
	}

	affichage(@resultat);
}

#recherche_TemperatureMax
sub recherche_TemperatureMax{
	print "\nRecherche de la journée la plus chaude \n ";
	my @resultat;
	my $max ;
	my $premierTour = 0;
	while (my $ligne =  <FIC> ){
			if ($ligne =~ /([0-9]{1,2})$/){
				if($premierTour == 0){
					$max = $1;
					$premierTour = 1;
				}
				if ($max < $1){
					$max = $1;
					@resultat=();
				}
				if ($max == $1){
					push @resultat,$ligne ;
				}
			}
	}

	affichage(@resultat);
}
#fonction d'affichage
sub affichage{
	@affichage=@_;
	my @affichage2;
	my $entete = "\nville   A       M       J     TEMPS\n";

	push @affichage2,$entete;

	#Concaténation des deux tableaux
	@affichage = (@affichage2,@affichage);
	#Affichage
	foreach my $tab (@affichage){
		say $tab;
	}
};