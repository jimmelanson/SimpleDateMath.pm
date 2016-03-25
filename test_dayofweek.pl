#!/usr/bin/perl - T

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

my $date2 = "2017/11/02";
my $date3 = "2115/8/5";
my $date4 = "2300/4/01";
my $date5 = "1856/9/4";
my $date6 = "1312/6/19";
print "Content-type: text/html\n\n";
print "<html><head><title>Test Weekday Name</title></head><body>\n";

my $obj = SimpleDateMath->new();
$obj->date_format("International");

my @dateparts = $obj->extract_date_parts($date1);
print "$date1 is on a ", $obj->weekday_name($obj->day_of_week_by_date($dateparts[0], $dateparts[1], $dateparts[2])), "<br>\n";

print "Ten days later is a ", $obj->weekday_name($obj->day_of_week_by_date($obj->add('days', 10, $date1))), " on ", $obj->add('days', 10, $date1), "<br>\n";
print "Fifty-two days later is a ", $obj->weekday_name($obj->day_of_week_by_date($obj->add('days', 52, $date1))), " on ", $obj->add('days', 52, $date1), "<br>\n";
print "Seventy-five days later is a ", $obj->weekday_name($obj->day_of_week_by_date($obj->add('days', 75, $date1))), " on ", $obj->add('days', 75, $date1), "<br>\n";
print "Ninety-nine days later is a ", $obj->weekday_name($obj->day_of_week_by_date($obj->add('days', 99, $date1))), " on ", $obj->add('days', 99, $date1), "<br><br><br><br>\n";

my @dateparts2 = $obj->extract_date_parts($date2);
print "The date $date2 falls on a ", $obj->weekday_name($obj->day_of_week_by_date($dateparts2[0], $dateparts2[1], $dateparts2[2])), "<br>\n";

my @dateparts3 = $obj->extract_date_parts($date3);
print "The date $date3 falls on a ", $obj->weekday_name($obj->day_of_week_by_date($dateparts3[0], $dateparts3[1], $dateparts3[2])), "<br>\n";

print "The date $date4 falls on a ", $obj->weekday_name($obj->day_of_week_by_date($date4)), "<br>\n";

my @dateparts4 = $obj->extract_date_parts($date5);
print "The date $date5 falls on a ", $obj->weekday_name($obj->day_of_week_by_date($dateparts4[0], $dateparts4[1], $dateparts4[2])), "<br>\n";

print "The date $date6 falls on a ", $obj->weekday_name($obj->day_of_week_by_date($date6)), "<br><br><br><br>\n";

print "Compare the results with timeanddate.com<br>\n";
print qq~<a href="http://www.timeanddate.com/calendar/?year=2017" target="_blank">http://www.timeanddate.com/calendar/?year=2017</a><br>\n~;
print qq~<a href="http://www.timeanddate.com/calendar/?year=2115" target="_blank">http://www.timeanddate.com/calendar/?year=2115</a><br>\n~;
print qq~<a href="http://www.timeanddate.com/calendar/?year=2300" target="_blank">http://www.timeanddate.com/calendar/?year=2300</a><br>\n~;
print qq~<a href="http://www.timeanddate.com/calendar/?year=1856" target="_blank">http://www.timeanddate.com/calendar/?year=1856</a><br>\n~;
exit;
