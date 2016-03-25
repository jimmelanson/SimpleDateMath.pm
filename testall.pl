#!/usr/bin/perl -wT

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
my $date2 = "2017/9/5";

print "Content-type: text/html\n\n";
print "<html><head><title>Test Weekday Name</title></head><body>\n";

my $math = SimpleDateMath->new();
my @partsdim = $math->parse_date($date1);
for(my $i = 1; $i <= 12; $i++) {
    print "There are ", $math->days_in_month($partsdim[0], $i), " days in ", $math->month_name($i), " of $partsdim[0].<br>\n";
}
print "<br>\n";

print "(International Date Format)<br><br>\n";
print "Parse date extracts: ", join(',', $math->parse_date($date1)), " from $date1.<br><br>\n";
print "The difference in days between $date1 and $date2 is ", $math->difference_in_days($date1, $date2), ".<br><br>\n";
print "The difference in days between $date2 and $date1 is ", $math->difference_in_days($date2, $date1), ".<br><br>\n";
my @parts = $math->parse_date($date1);
print "The year $parts[0] ", $math->is_leap_year($parts[0]) ? " is " : " is not ", " a leap year.<br><br>\n";
print "Passing $date1 and $date2 to the extract_date_parts() method returns: ", join(',', $math->extract_date_parts($date1, $date2)), ".<br><br>\n";
print "45 days added to $date1 gives a date of ", $math->add_days('Days', 45, $date1), ".<br><br>\n";
print "45 days subtracted from $date1 gives a date of ", $math->subtract_days('days', 45, $date1), ".<br><br>\n";
print "12 weeks added to $date1 gives a date of ", $math->add_weeks('weeks', 12, $date1), ".<br><br>\n";
print "12 weeks subtracted from $date1 gives a date of ", $math->subtract_weeks('w', 12, $date1), ".<br><br>\n";
print "18 months added to $date1 gives a date of ", $math->add_months('m', 18, $date1), ".<br><br>\n";
print "18 months subtracted from $date1 gives a date of ", $math->subtract_months('Month', 18, $date1), ".<br><br>\n";
print "7 years added to $date1 gives a date of ", $math->add_years('Year', 7, $date1), ".<br><br>\n";
print "7 years subtracted from $date1 gives a date of ", $math->subtract_years('year', 7, $date1), ".<br><br><br><br>\n";

print "Testing DST<br><br>\n";
print "Dayling Savings Time ", $math->is_dst("North America", $date2) ? " is " : " is not ", " in effect on $date2.<br><br><br><br>\n";

$math->date_format("US");
print "Response Date Format is now ", $math->date_format, "<br><br>\n";
print "90 days after $date1 is ", $math->add('Days', 90, $date1), " and it falls on a ", $math->weekday_name($math->day_of_week_by_date($math->add('Days', 90, $date1))), ".<br><br>\n";
print "$date2 falls on a ", $math->weekday_name($math->day_of_week_by_date($date2)), ".<br><br>\n";

print "The 4th Tuesday in August in 2018 is: ", $math->nth_weekday_of_the_month(1, 4, 2018, 8), ".<br><br>\n";
print "The 1st Wednesday in August in 2018 is: ", $math->nth_weekday_of_the_month(2, 1, 2018, 8), ".<br>\n";
print "The 2nd Wednesday in August in 2018 is: ", $math->nth_weekday_of_the_month(2, 2, 2018, 8), ".<br>\n";
print "The 3rd Wednesday in August in 2018 is: ", $math->nth_weekday_of_the_month(2, 3, 2018, 8), ".<br>\n";
print "The 4th Wednesday in August in 2018 is: ", $math->nth_weekday_of_the_month(2, 4, 2018, 8), ".<br>\n";
print "The 5th Wednesday in August in 2018 is: ", $math->nth_weekday_of_the_month(2, 5, 2018, 8), ".<br><br><br><br>\n";

print "Compare the results with timeanddate.com<br>\n";
print qq~<a href="http://www.timeanddate.com/calendar/?year=2017" target="_blank">http://www.timeanddate.com/calendar/?year=2017</a><br>\n~;

exit;
