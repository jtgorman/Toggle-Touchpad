#! /usr/bin/perl -w 

use strict;

use Data::Dumper;


my $results = `xinput list-props "SynPS/2 Synaptics TouchPad"`;
#could I do this more efficiently?   
#seems like I should be able to put the results into a file handle
my @lines = split("\n",$results);


#the first and last line don't seem to be properties
my @props = @lines[1..scalar(@lines) - 1];


my %props = ();
my $count = 0;
foreach my $propLine (@props) {

#    print "At $count: $propLine \n";

    my $displayName;
    my $numericId;
    my $value;
    
    $propLine =~ /\t*(.+) \((\d+)\):\s*(.*)$/;
    


    ($displayName,$numericId,$value) = ($1,$2,$3);

    $props{$displayName} = $value;
    $props{$numericId} = $value;

    $count++;
}

#print Dumper(\%props);

if($props{125} == 0) {
    system("xinput set-prop 'SynPS/2 Synaptics TouchPad' 125 1");
}
else {
    system("xinput set-prop 'SynPS/2 Synaptics TouchPad' 125 0");
}

sub trim {
    
    my $value = shift;
    
    $value =~ s/^\s*//;
    $value =~ s/\s*$//;

    return $value;

}
