#! /usr/bin/perl -w 

use strict;

use Data::Dumper;

# adding "on | off" as arguments that will toggle to that state regardless
# of current state

my $state;
#wonder if can ssume this means ARGV[0] defined
if(@ARGV) {
    $state = lc($ARGV[0]) eq 'on'  ? 1 :
             lc($ARGV[0]) eq 'off' ? 0 :
 undef ;
}

my $results = `xinput list-props "SynPS/2 Synaptics TouchPad"`;
#could I do this more efficiently?   
#seems like I should be able to put the results into a file handle
my @lines = split("\n",$results);


#the first and last line don't seem to be properties
my @props = @lines[1..scalar(@lines) - 1];


my %props = ();

my %displayToNumeric = ();

my $count = 0;
foreach my $propLine (@props) {

#    print "At $count: $propLine \n";

    my $displayName;
    my $numericId;
    my $value;
    
    $propLine =~ /\t*(.+) \((\d+)\):\s*(.*)$/;
    

# Device Enabled 
    
    ($displayName,$numericId,$value) = ($1,$2,$3);

    $props{$displayName} = $value;
    $props{$numericId} = $value;

    $displayToNumeric{ $displayName } = $numericId ;
    
    
    $count++;
}

#print Dumper(\%props);

if(   ( defined($state)  && $state == 1)
   || ( !defined($state) && $props{'Device Enabled'} == 0) ) {
    setPropertyState($displayToNumeric{'Device Enabled'}, 1);
}
else {
    setPropertyState($displayToNumeric{'Device Enabled'}, 0);
}

sub trim {
    
    my $value = shift;
    
    $value =~ s/^\s*//;
    $value =~ s/\s*$//;

    return $value;

}

sub setPropertyState {

    my $setting = shift;
    my $value   = shift;

    system("xinput set-prop 'SynPS/2 Synaptics TouchPad' $setting $value") ;
}
