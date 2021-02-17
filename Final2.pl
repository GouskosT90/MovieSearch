#****************************************************
# Program:	Final2.pl
# Author:	Theodore Gouskos	
# Abstract:	Yehehehe FINALLY DONE
#****************************************************
#!/usr/bin/perl -w

use strict;
use DBI;

sub menu { #GUI
	system 'clear';
	my $option = 0;
	print "\t\tSelect an option - Oscar Nominees from 1927 to 2015\n\n";
	print "\t\t1 - Find an specific Actor/Actress and their Movies\n";
	print "\t\t2 - Find a specific Movie and Year\n";
	print "\t\t3 - Search a range of years for Winners\n";
	print "\t\t4 - Search Nominees via Category\n";
	print "\t\t5 - Search Movies via Category\n";
	print "\t\t0 - End Program";
	print "\nEnter selection: ";
	$option = <STDIN>;
}

sub FindActor{
	system('clear');
	print "\tFind an Actor\n\n";
	print "Enter Actor Name: ";
	my $Aname = <STDIN>;
	chomp($Aname);
	my $isThere = 0;
	#print "Here**$Aname**$isThere**\n";
	while ($Aname ne "Quit" and $isThere == 0) #Keeps in loop as long as not Quit
	{
		system('clear');
		my $dbh = DBI->connect ("DBI:mysql:host=localhost;database=goutheo", "goutheo", "goutheo_DB");
		my $sth = $dbh->prepare("Select name, fname from Film where name = \'$Aname\'"); #Grabs all matching names and movies
		$sth-> execute();
		my @q = $sth->fetchrow_array();
		my $count = @q; #Gets the count of matching names
		#print "$count\n";
		#print "$Aname\n";
		 if (!$count) #Checks to see if count is 0
		{
			print "$Aname does not exist in the Database\n";
		} else {
				print"Name	  						Film\n";
				print "==============================================================\n";
				while (@q = $sth->fetchrow_array()) 
					{
					 printf "%-9s%50s\n", $q[0], $q[1];
					}
				$isThere = 1;
				$sth->finish();
				$dbh->disconnect();
				}
		print "\nPlease type another name or type Quit to return to menu: "; #Aks user again for input
		$Aname = <STDIN>;
		chomp($Aname);
		
		if($Aname eq "Quit")
		{
		 $isThere = 1;
		} else {
				$isThere = 0;
			   }
	}
	return 0; #Goes back to the menu
}

sub FindMovie{ #Finds specific Movie
	system('clear');
	print "\tFind a Movie\n\n";
	print "Enter Movie Name: ";
	my $Mname = <STDIN>;
	chomp($Mname);
	my $isThere = 0;
	while ($Mname ne "Quit" and $isThere == 0) #Loops as long as it is not Quit
	{
		system('clear');
		my $dbh = DBI->connect ("DBI:mysql:host=localhost;database=goutheo", "goutheo", "goutheo_DB");
		my $sth = $dbh->prepare("Select fname, year from Featured where fname = \'$Mname\'"); #Grabs all matching names and movies
		$sth-> execute();
		my @q = $sth->fetchrow_array();
		my $count = @q; #Gets the count of matching Movie names
		if (!$count) #Checks to see if count is 0
		{
			print "$Mname does not exist in the Database\n";
		} elsif (!&isItNonBlank($Mname)) { #Checks to see if Input is Blank
					print "ERROR: Input was Blank\n";
					} else {
						 print"Film	  						Year\n";
						 print "==============================================================\n";
						 while (@q = $sth->fetchrow_array()) 
							{
							  printf "%-9s%50s\n", $q[0], $q[1];
							}
						$isThere = 1;
						$sth->finish();
						$dbh->disconnect();
						}
		print "\nPlease type another Movie or type Quit to return to menu: "; #Asks user for input again
		$Mname = <STDIN>;
		chomp($Mname);

		if($Mname eq "Quit")
		{
		 $isThere = 1;
		} else {
				$isThere = 0;
			   }
	}
	return 0; #Comes back to menu
}

sub RangeYears { #Checks data between a set of years
	system('clear');
	print "\tSelect a Range of Years\n\n";
	
	print "Enter Lower Year Range or Quit to go to Menu: "; #Gets low end number
	my $First = <STDIN>;
	chomp($First);
	
	print "Enter Higher Year Range or Quit to go to Menu: "; #Gets upper limit
	my $Second = <STDIN>;
	chomp($Second);
	my $isThere = 0;
	
	while ($First ne "Quit" and $isThere == 0 or $Second ne "Quit" and $isThere == 0)
	{
		system('clear');
		my $dbh = DBI->connect ("DBI:mysql:host=localhost;database=goutheo", "goutheo", "goutheo_DB");
		my $sth = $dbh->prepare("Select fname, name, year from Featured where year >=\'$First\' and year <= \'$Second\'"); #Grabs all years between range
		$sth-> execute();
		my @q = $sth->fetchrow_array();
		my $count = @q; #Gets the count of matching years
		if (!&isItARealNumber($First)) #Checks for a real number, Error if not
		{
		  print "ERROR: The first input was not a real Number\n";
		} elsif (!&isItARealNumber($Second)) #Checks for a real number, Error if not
			{
				print "ERROR: The Second input was not a real Number\n";
			} elsif ($First > $Second) # Sees if Second is less than First, error if true
				{
				   print "ERROR: The First value is larger than the Second\n";
				} elsif (!$count) #Checks if there are matches
				{
				  print "There is nothing between the years $First and $Second\n";
				} else {
						print "Name  									Film/Year\n";
						print "===============================================================================================\n";
						while (@q = $sth->fetchrow_array())  #Prints out
							{
							  printf "%-110s%-10s%5s\n", $q[0], $q[1], $q[2];
							}
						$isThere = 1;
						$sth->finish();
						$dbh->disconnect();
						}
		print "Enter Lower Year Range or Quit to go to Menu: ";
		$First = <STDIN>;
		chomp($First);
		
		print "Enter Higher Year Range or Quit to go to Menu: ";
		$Second = <STDIN>;
		chomp($Second);
			
		if($First eq "Quit" or $Second eq "Quit") #Checks for Quit
			{
			 $isThere = 1;
			} else {
					$isThere = 0;
				   }
	}
	return 0;
}

sub SearchCategoryActor{ #Search for Actor categories 
	system('clear');
	print "\tSearch for a Category\n\n";
	print "\n\t\t Some Awards to Search\n"; #Suggests Categories to search
	print "Actor, Actress, Director, Art Direction, Engineering Effects, Honorary Award\n";
	print "Writing(Adaption), Writing(Screenplay), Writing(Original Story), Actress in a Supporting Role\n";
	print "Assistant Director, Dance Direction, Actor in a Supporting Role, Irving G. Thalberg Memorial Award \n";
	print "Actor in a Leading Role, Actress in a Leading Role, Gordon E. Sawyer Award, Award of Commendation \n";
	print "Jean Hersholt Humanitarian Award,John A. Bonner Medal of Commendation\n";
	print "\nEnter Category or Quit to exit: ";
	my $Category = <STDIN>;
	chomp($Category);
	my $isThere = 0;
	while ($Category ne "Quit" and $isThere == 0)
	{
		system('clear');
		my $dbh = DBI->connect ("DBI:mysql:host=localhost;database=goutheo", "goutheo", "goutheo_DB");
		my $sth = $dbh->prepare("Select name, year, winner from Nominees where award = \'$Category\'"); #Grabs all matching names
		$sth-> execute();
		my @q = $sth->fetchrow_array();
		my $count = @q; #Gets the count of matching Movie names
		if (!&isItNonBlank($Category)) {
			printf "Error: Input was blank\n";
		} elsif (&isItAnInteger($Category)) { #Checks if there are numbers
				print "Error: Input contained a Number\n";
				} elsif (!$count){ #Checks for matching, if none it is false
				  print "$Category was not a category\n";
				  } else {
							print "Name  						  	Year		  Winner(1 = yes)\n";
							print "==============================================================================\n";
							while (@q = $sth->fetchrow_array()) 
								{
								  printf "%-60s%-10s%5s\n", $q[0], $q[1], $q[2];
								}
							$isThere = 1;
							$sth->finish();
							$dbh->disconnect();
						}
		print "\n\t\t Some Awards to Search\n"; #Suggests some categories
	print "Actor, Actress, Director, Engineering Effects, Honorary Award\n";
	print "Writing(Adaption), Writing(Screenplay), Writing(Original Story), Actress in a Supporting Role\n";
	print "Assistant Director, Dance Direction, Actor in a Supporting Role, Irving G. Thalberg Memorial Award \n";
	print "Actor in a Leading Role, Actress in a Leading Role, Gordon E. Sawyer Award, Award of Commendation \n";
	print "Jean Hersholt Humanitarian Award,John A. Bonner Medal of Commendation\n";
	print "\nEnter Category: ";
		print "Enter a Category Name or Quit to exit: ";
		$Category = <STDIN>;
		chomp($Category);
			
		if($Category eq "Quit") #Checks for quit
			{
			 $isThere = 1;
			} else {
					$isThere = 0;
				   }
	}
	return 0;
}

sub SearchCategoryMovie{ #Search for movie Categories
system('clear');
	print "\tSearch for a Category\n\n";
	print "\n\t\t Some Awards to Search\n"; #Suggests some categories
	print "Cinematography, Art Direction, Directing, Costume Design\n";
	print "Writing(Adapted Screenplay), Writing(Original Screenplay), Writing(Original Story)\n";
	print "Visual Effects, Sound Mixing, Sound Editing, Short Film (Animated), Short Film (Live Action) \n";
	print "Best Picture, Music (Original Score), Music (Original Song, Make Up, Film Editing \n";
	print "Documentary (Feature),Documentary (Short Subject), Costume Design, Animated Feature Film\n";
	print "Foreign Language Film, Makeup and Hairstyling\n";
	print "\nEnter Category or Quit to exit: ";
	my $Mcat = <STDIN>;
	chomp($Mcat);
	my $isThere = 0;
	while ($Mcat ne "Quit" and $isThere == 0)
	{
		system('clear');
		my $dbh = DBI->connect ("DBI:mysql:host=localhost;database=goutheo", "goutheo", "goutheo_DB");
		my $sth = $dbh->prepare("Select name, year, winner from Nominees where award = \'$Mcat\'"); #Grabs all matching names
		$sth-> execute();
		my @q = $sth->fetchrow_array();
		my $count = @q; #Gets the count of matching Movie names
		if (!&isItNonBlank($Mcat)) { #Checks for blanks
			printf "Error: Input was blank\n";
		} elsif (!$count){ #Checks for no matches, false if there are matches
				  print "$Mcat was not a category\n";
				  } else {
							print "Name  						  	Year		  Winner(1 = yes)\n";
							print "==============================================================================\n";
							while (@q = $sth->fetchrow_array()) 
								{
								  printf "%-60s%-10s%5s\n", $q[0], $q[1], $q[2];
								}
							$isThere = 1;
							$sth->finish();
							$dbh->disconnect();
						}
	print "\tSearch for a Category\n\n";
	print "\n\t\t Some Awards to Search\n"; #Suggests some categories
	print "Cinematography, Art Direction, Directing, Costume Design\n";
	print "Writing(Adapted Screenplay), Writing(Original Screenplay), Writing(Original Story)\n";
	print "Visual Effects, Sound Mixing, Sound Editing, Short Film (Animated), Short Film (Live Action) \n";
	print "Best Picture, Music (Original Score), Music (Original Song, Make Up, Film Editing \n";
	print "Documentary (Feature),Documentary (Short Subject), Costume Design, Animated Feature Film\n";
	print "Foreign Language Film, Makeup and Hairstyling\n";
	print "\nEnter Category: ";
		print "Enter a Category Name or Quit to exit: ";
		$Mcat = <STDIN>;
		chomp($Mcat);
			
		if($Mcat eq "Quit")
			{
			 $isThere = 1;
			} else {
					$isThere = 0;
				   }
	}
	return 0;

}
sub isItNonBlank {	# a non-empty string - any non-white space will do
	$_ = $_[0];
	/\S+/				
}
sub isItAnInteger {		# a positive or negative integer with no leading zeroes
	$_ = $_[0];
	/\A-?[123456789][0123456789]*\z/ or /\A0\z/
}
sub isItARealNumber {	# a positive or negative real number, leading zeroes allowed
	$_ = $_[0];
	/\A-?[0123456789]*(\.[0123456789]*)?\z/	and /\d/ 
}

my $option = &menu;
while ($option != 0){ #Option switch, runs subroutines depending on input
	if ($option == 1){&FindActor;}
		
	if ($option == 2){&FindMovie;}
		
		
	if ($option == 3){&RangeYears;}
	
	if ($option == 4){&SearchCategoryActor;}
	
	if ($option == 5){&SearchCategoryMovie;}
	
	print "\nHit enter to continue:";
	<STDIN>;
	$option = &menu;
}
print "\nThe End!\n";
