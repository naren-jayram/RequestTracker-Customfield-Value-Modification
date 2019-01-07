#!/home/perl/bin/perl
use strict;
use warnings;
use lib qw(/opt/rt4/lib); # This depends on your installation paths. In this case RT resides in /opt
use RT;
use RT::Queues;
use RT::Tickets;
use Data::Dumper;

sub main
{
	my @custom_field_values = getCustomFiledValues();	# making a call to getCustomFiledValues. This will in turn return an array

	foreach (@custom_field_values)						# Iterating through array, custom_field_values
	{
		# CONFIGURATION
		my $queue = ' ';						# RT Queue name 
		my $cf_name = ' ';						# Concerned Custom Field name that exists under above queue
		my $old_value = $_; 					# NB: This must be a valid value for the CF
		my $new_value = '';						# You are free to add any values here. In this case it is NULL
		# END CONFIGURATION
		
		# print $_."\n";
		RT::LoadConfig();
 		RT::Init();
		my $tx = RT::Tickets->new($RT::SystemUser);
		my $cf = RT::CustomField->new($RT::SystemUser);
 		my $q  = RT::Queue->new($RT::SystemUser);
 		$tx->FromSQL(qq[queue="$queue" and "cf.$queue.{$cf_name}" = '$old_value']);
 		$q->Load($queue);
 		$cf->LoadByNameAndQueue(Queue => $q->Id, Name => $cf_name);
 		unless( $cf->id ) 
		{
   			# queue 0 is special case and is a synonym for global queue
   			$cf->LoadByNameAndQueue( Name => $cf_name, Queue => '0' );
 		}
 		unless( $cf->id ) 
		{
   			print "No field $cf_name in queue ". $q->Name;
   			die "Could not load custom field";
 		}
 
 		my $i=0;
 		while (my $t = $tx->Next)
		{
	        print "Processing record #" . ++$i . "\n";
	        my $old_type = $t->FirstCustomFieldValue($cf_name);
	        print "Old Type =" . $old_type . "\n";
	        my $new_custom_value = $t->AddCustomFieldValue(Field => $cf->Id,Value => $new_value);   #This will replace existing custom field value with a new value
	        my $new_type = $t->FirstCustomFieldValue($cf_name);
	        print "New Type =" . $new_type . "\n";
	    }

 
	}
}



sub getCustomFiledValues()
{	
	# Variables
	my $custom_field_value;
	my $line;
	my @custom_field_value_array;
	my $file = "input.csv";												# File that holds customfield values. You can change this value according to your needs.
	# End of Variables
	
	open(my $data, '<', $file) or die "Could not open '$file' $!\n";
	while (my $line = <$data>) 											# Iterating through file content
	{
  		chomp $line;													# Cleaning the data by getting rid of the trailing new line character
  		#next if ($. == 1);												# This will skip the first line in the csv. Comment it if it is not necessary
  		my $custom_field_value = $line;
  		push(@custom_field_value_array, $custom_field_value);
	}
	close($data);
	return @custom_field_value_array;
}


if (main()) 
{
	exit 0;
}
exit 1;
