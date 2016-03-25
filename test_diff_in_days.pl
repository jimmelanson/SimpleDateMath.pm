#!/usr/bin/perl -T

#Test script for SimpleDateMath.pm provided by Jim Melanson, jmelanson1965@gmail.com
#Install the module, or simply place SimpleDateMath.pm in the same directory as the script calling it.

BEGIN{
    push(@INC, '/home2/jmelpubs/public_html/jimmelanson/cgi-bin/programming/modules');
    #$| = 1;
    #open(STDERR, ">&STDOUT");
    #print "Content-type: text/html\n\n";
}

use SimpleDateMath;;
use strict;

my $start_date = "2016/03/15";
my $compare_date = "2016/09/02";

my $obj = SimpleDateMath->new();
$obj->date_format("US");
print "Content-type: text/plain\n\n";
print '$obj->difference_in_days($start_date, $compare_date)', " From $start_date to $compare_date there is a difference of ", $obj->difference_in_days($start_date, $compare_date), " days.\n\n";

print '$obj->difference_in_days($compare_date, $start_date)', " From $start_date to $compare_date there is a difference of ", $obj->difference_in_days($compare_date, $start_date), " days.\n\n";

print '$obj->difference_in_days(2016, 3, 15, 2016, 9, 2)', " From $start_date to $compare_date there is a difference of ", $obj->difference_in_days(2016, 3, 15, 2016, 9, 2), " days.\n\n";

print '$obj->difference_in_days($start_date, 2016, 9, 2)', " From $start_date to $compare_date there is a difference of ", $obj->difference_in_days($start_date, 2016, 9, 2), " days.\n\n";

print '$obj->difference_in_days(2016, 3, 15, $compare_date)', " From $start_date to $compare_date there is a difference of ", $obj->difference_in_days(2016, 3, 15, $compare_date), " days.\n\n";

print "See? It's very forgiving. Just like my mom.\n\n";

exit;
