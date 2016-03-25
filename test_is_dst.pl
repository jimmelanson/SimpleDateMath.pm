#!/usr/bin/perl -T

#Test script for SimpleDateMath.pm provided by Jim Melanson, jmelanson1965@gmail.com
#Install the module, or simply place SimpleDateMath.pm in the same directory as the script calling it.

BEGIN{
    push(@INC, '/home2/jmelpubs/public_html/jimmelanson/cgi-bin/programming/modules');
    #$| = 1;
    #open(STDERR, ">&STDOUT");
    #print "Content-type: text/html\n\n";
}

use SimpleDateMath;
use strict;

my $date1 = "2017/03/15";
my $date2 = "2017/06/12";
my $date3 = "2017/10/1";
print "Content-type: text/html\n\n";
print "<html><head><title>Test is_dst()</title></head><body>\n";

my $obj = SimpleDateMath->new();
$obj->date_format("US");

print "In North America, the date $date1 ", $obj->is_dst("North America", 2017, 3, 15) ? " is " : " is not ", "using Daylight Savings Time.<br><br>\n";

print "In North America, the date $date2 ", $obj->is_dst("North America", $date2) ? " is " : " is not ", "using Daylight Savings Time.<br><br>\n";

print "In North America, the date $date3 ", $obj->is_dst("North America", $date3) ? " is " : " is not ", "using Daylight Savings Time.<br><br><br><br>\n";



print "In Mexico, the date $date1 ", $obj->is_dst("Mexico", $date1) ? " is " : " is not ", "using Daylight Savings Time.<br><br>\n";

print "In Mexico, the date $date2 ", $obj->is_dst("Mexico", 2017, 6, 12) ? " is " : " is not ", "using Daylight Savings Time.<br><br>\n";

print "In Mexico, the date $date3 ", $obj->is_dst("Mexico", $date3) ? " is " : " is not ", "using Daylight Savings Time.<br><br><br><br>\n";



print "In Europe, the date $date1 ", $obj->is_dst("Europe", $date1) ? " is " : " is not ", "using Daylight Savings Time.<br><br>\n";

print "In Europe, the date $date2 ", $obj->is_dst("Europe", $date2) ? " is " : " is not ", "using Daylight Savings Time.<br><br>\n";

print "In Europe, the date $date3 ", $obj->is_dst("Europe", 2017, 10, 1) ? " is " : " is not ", "using Daylight Savings Time.<br><br><br><br>\n";
exit;
