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

my $date2 = "2017/11/02";
my $date3 = "2115/8/5";
my $date4 = "2300/4/01";
my $date5 = "1856/9/4";
my $date6 = "1312/6/19";
print "Content-type: text/html\n\n";
print "<html><head><title>Test nth_weekday_of_the_month()</title></head><body>\n";

my $obj = SimpleDateMath->new();
$obj->date_format("International");


print "The 1st Monday of January, 2017, is 2017-01-", $obj->nth_weekday_of_the_month(0, 1, 2017, 1), "<br><br>\n";
print "The 2nd Tuesday of February, 2017, is 2017-02-", $obj->nth_weekday_of_the_month(1, 2, 2017, 2), "<br><br>\n";
print "The 3rd Wednesday of March, 2017, is 2017-03-", $obj->nth_weekday_of_the_month(2, 3, 2017, 3), "<br><br>\n";
print "The 4th Thursday of April, 2017, is 2017-04-", $obj->nth_weekday_of_the_month(3, 4, 2017, 4), "<br><br>\n";
print "The Last Friday of May, 2017, is 2017-05-", $obj->nth_weekday_of_the_month(4, 5, 2017, 5), "<br><br>\n";
print "The Last Sunday of July, 2016, is 2016-07-", $obj->nth_weekday_of_the_month(6, 6, 2016, 7), "<br><br>\n";
print "The Last Sunday of February, 2026, is 2026-02-", $obj->nth_weekday_of_the_month(6, 5, 2026, 2), "<br><br>\n";
print "The Last Sunday of December, 2017, is 2017-12-", $obj->nth_weekday_of_the_month("Sunday", 5, 2017, 12), "<br><br>\n";
print "The 4th Saturday of November, 2017, is 2017-11-", $obj->nth_weekday_of_the_month("SaTuRdAy", 4, 2017, 11), "<br><br>\n";
print "The 3rd Thursday of October, 2017, is 2017-10-", $obj->nth_weekday_of_the_month("thur", 3, 2017, 10), "<br><br>\n";
print "The 2nd Wednesday of September, 2017, is 2017-09-", $obj->nth_weekday_of_the_month("wed", 2, 2017, 9), "<br><br>\n";
print "The 1st Tuesday of August, 2017, is 2017-08-", $obj->nth_weekday_of_the_month("tuesdAY", 1, 2017, 8), "<br><br><br><br>\n";

print "Compare the results with timeanddate.com<br>\n";
print qq~<a href="http://www.timeanddate.com/calendar/?year=2017" target="_blank">http://www.timeanddate.com/calendar/?year=2017</a><br>\n~;

exit;
