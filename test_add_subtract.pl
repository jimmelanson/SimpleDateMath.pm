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

my $start_date = "2016/03/15";

my $obj = SimpleDateMath->new();
$obj->date_format("US");

print "Content-type: text/html\n\n";
print "<html><head><title>Test Add/Subtract</title></head><body>\n";
print "Start Date: $start_date<br><br>\n";
print qq~
<table border="1" cellspacing="1" cellpadding="3">
  <tr>
    <td colspan="4" align="center"><span style="font-weight:bold;">US Date Format</span></td>
    <td>&nbsp;</td>
    <td colspan="4" align="center"><span style="font-weight:bold;">International Date Format</span></td>
  </tr>
  <tr>
    <td align="center"><span style="font-weight:bold;">Adding Days</span></td>
    <td align="center"><span style="font-weight:bold;">Adding Weeks</span></td>
    <td align="center"><span style="font-weight:bold;">Adding Months</span></td>
    <td align="center"><span style="font-weight:bold;">Adding Years</span></td>
    <td>&nbsp;</td>
    <td align="center"><span style="font-weight:bold;">Subtracting Days</span></td>
    <td align="center"><span style="font-weight:bold;">Subtracting Weeks</span></td>
    <td align="center"><span style="font-weight:bold;">Subtracting Months</span></td>
    <td align="center"><span style="font-weight:bold;">Subtracting Years</span></td>
  </tr>
  <tr>
    <td valign="top">
~;
for(my $c = 1; $c <= 1000; $c++) {
    print "+", $c, " ", $obj->add('days', $c, $start_date), "<br />\n";
}
print qq~</td><td valign="top">\n~;
for(my $c = 1; $c <= 1000; $c++) {
    print "+", $c, " ", $obj->add('weeks', $c, $start_date), "<br />\n";
}
print qq~</td><td valign="top">\n~;
for(my $c = 1; $c <= 1000; $c++) {
    print "+", $c, " ", $obj->add('months', $c, $start_date), "<br />\n";
}
print qq~</td><td valign="top">\n~;
for(my $c = 1; $c <= 1000; $c++) {
    print "+", $c, " ", $obj->add('years', $c, $start_date), "<br />\n";
}
print qq~<td>&nbsp;</td></td><td valign="top">\n~;
$obj->date_format("International");
for(my $c = 1; $c <= 1000; $c++) {
    print "-", $c, " ", $obj->subtract('days', $c, $start_date), "<br />\n";
}
print qq~</td><td valign="top">\n~;
for(my $c = 1; $c <= 1000; $c++) {
    print "-", $c, " ", $obj->subtract('weeks', $c, $start_date), "<br />\n";
}
print qq~</td><td valign="top">\n~;
for(my $c = 1; $c <= 1000; $c++) {
    print "-", $c, " ", $obj->subtract('months', $c, $start_date), "<br />\n";
}
print qq~</td><td valign="top">\n~;
for(my $c = 1; $c <= 1000; $c++) {
    print "-", $c, " ", $obj->subtract('years', $c, $start_date), "<br />\n";
}
print "</td></tr></table><br /></body></html>\n\n";
exit;

