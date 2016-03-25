# SimpleDateMath.pm, Version 0.01, Copyright 2016, Jim Melanson
# Distributed under GNU Free Documentation License Version 1.3 or later.

package SimpleDateMath;
use strict;
no strict "refs";
use Carp qw(carp croak confess);

our $VERSION = .01;

sub new {
    my ($class) = @_;
    my @gmt = gmtime();
    my $self = {
        _date_format => "International", 
        _daysinmonth => [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ],
        _monthnames => ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'], 
        _weekdaynames => ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'], 
    };
    bless $self, $class;
    return $self;
}

sub DESTROY {
    my $self = shift;
    foreach(keys %{$self}) {
        delete $self->{$_};
    }
    undef(%$self);
    undef $self;
}

sub date_format { $_[0]->{_date_format} = $_[1] if $_[1]; return $_[0]->{_date_format}; }

sub weekday_name { return ${$_[0]->{_weekdaynames}}[$_[1]] if defined($_[1]); return "Julian Date" if $_[1] < 0; carp "No argument passed to weekday_name(). "; return 0; }

sub month_name { return ${$_[0]->{_monthnames}}[$_[1] - 1] if defined($_[1]); return "Julian Date" if $_[1] < 0; carp "No argument passed to month_name(). "; return 0; }

sub days_in_month {
    if($_[1] && $_[2]) {
        if($_[0]->is_leap_year($_[1]) && ($_[2] == 2)) {
            return 29;
        } else {
            return @{$_[0]->{_daysinmonth}}[$_[2] - 1];
        }
    } else {
        croak "Insufficient arguments passed to Date::Math->days_in_month(). ";
    }
}

sub month_integer_from_name {
    if($_[1]) {
        for(my $i = 0; $i <= 11; $i++) {
            if(uc(substr($_[1], 0, 3)) eq uc(substr(${$_[0]->{_daysinmonth}}[$i], 0, 3))) {
                return $i + 1;
            }
        }
    } else {
        croak "Did not receive month name at month_integer_from_name(). ";
    }
}

sub parse_date {
    my ($parse_y, $parse_m, $parse_d);
    if($_[1] =~ /^(\d\d\d\d)\D(\d{1,2})\D(\d{1,2})$/) {
        $parse_y = $1;
        $parse_m = abs($2);
        $parse_d = abs($3);

    }
    elsif($_[1] =~ /^(\d{1,2})\D(\d{1,2})\D(\d\d\d\d)$/) {
        $parse_y = $3;
        $parse_m = abs($1);
        $parse_d = abs($2);
    } else {
        croak "No date string was passed to Date::Math->parse_date().";
    }
    return ($parse_y < -46) ? (-46, 1, 1) : ($parse_y, $parse_m, $parse_d);
}

sub difference_in_days {
    my $self = shift;
    my ($start_year, $start_month, $start_day, $compare_year, $compare_month, $compare_day) = $self->extract_date_parts(@_);
    if( ($start_year > 0) && ($start_month > 0) && ($start_day > 0) && ($compare_year > 0) && ($compare_month > 0) && ($compare_day > 0) ) {
        if($self->_m100($start_year, $start_month, $start_day) eq $self->_m100($compare_year, $compare_month, $compare_day)) {
            return 0;
        } else {
            my $return_value = 0;
            if($compare_year == $start_year) {
                if($compare_month == $start_month) {
                    $return_value = $compare_day - $start_day;
                } else {
                    $return_value = ($self->days_in_month($start_year, $start_month) - $start_day) + $compare_day;
                    if(($compare_month - $start_month) > 1) {
                        for(my $i = ($start_month + 1); $i <= ($compare_month - 1); $i++) {
                            $return_value += $self->days_in_month($start_year, $i);
                        }
                    }
                }
            } else {
                if(($compare_year - $start_year) > 1) {
                    for(my $i = ($start_year + 1); $i <= ($compare_year - 1); $i++) {
                        $return_value += 365;
                        if($self->is_leap_year($i)) {
                            $return_value += 1;
                        }
                    }
                }
                if($start_month == 12) {
                    $return_value += (31 - $start_day)
                } else {
                    for(my $i = ($start_month + 1); $i <= 12; $i++) {
                        $return_value += $self->days_in_month($start_year, $i);
                    }
                    $return_value += ($self->days_in_month($start_year, $start_month) - $start_day);
                }
                if($compare_month == 1) {
                    $return_value += $compare_day;
                } else {
                    for(my $i = 1; $i <= ($compare_month - 1); $i++) {
                        $return_value += $self->days_in_month($start_year, $i);
                    }
                    $return_value += $compare_day;
                }
            }
            if($self->_julian_crossover($start_year, $start_month, $start_day, $compare_year, $compare_month, $compare_day)) {
                $return_value -= 10;
            }
            return $return_value;
        }
    } else {
        croak "Compare date and or start date was not defined for Date::Math->difference_in_days().";
    }
}

sub is_dst {
    #For more information on calculation of DST in other locations, see: https://en.wikipedia.org/wiki/Daylight_saving_time_by_country
    #$obj->IsDST([location name, [datestring]]);
    #$obj->IsDST([location name, [year, [month, day]]]);
    my $self = shift;
    my $location = shift;
    my ($test_year, $test_month, $test_day) = $self->extract_date_parts(@_);
    if($test_year && $test_month && $test_day) {
        my $target_m100 = $self->_m100($test_year, $test_month, $test_day);
        my $results = 0;
        my $start_m100;
        my $end_m100;
        if($location eq "North America") {
            #Canada and USA (except Arizona and Hawaii)
            #Start: 2nd Sunday in March ;  (Day of Month = 14 - (1+Y*5/4) Mod 7)
            #End:   1st Sunday in November; (Day of Month = 7 - (1 + 5*Y/4) Mod 7)
            $start_m100 = $self->_m100($test_year, 3, $self->nth_weekday_of_the_month(6, 2, $test_year, 3));
            $end_m100 = $self->_m100($test_year, 11, $self->nth_weekday_of_the_month(6, 1, $test_year, 11));

        }
        elsif($location eq "Mexico") {
            #Mexico Note: some border states follow the US Standard
            #Start: 1st Sunday in April ;  (Day of Month = 1 + (2+6*Y-Y/4) mod 7)
            #End:   Last Sunday in October; (Day of Month = 31 - (1 + 5*Y/4) mod 7)
            $start_m100 = $self->_m100($test_year, 4, $self->nth_weekday_of_the_month(6, 1, $test_year, 4));
            $end_m100 = $self->_m100($test_year, 10, $self->nth_weekday_of_the_month(6, 5, $test_year, 10));
        }
        elsif($location eq "Europe") {
            #Europe (not all countries)
            #Start: Last Sunday in March ;  (Day of Month = 31 - (4+ 5*Y/4 ) mod 7)
            #End:   Last Sunday in October; (Day of Month = 31 - (1 + 5*Y/4) mod 7)
            $start_m100 = $self->_m100($test_year, 3, $self->nth_weekday_of_the_month(6, 5, $test_year, 3));
            $end_m100 = $self->_m100($test_year, 10, $self->nth_weekday_of_the_month(6, 5, $test_year, 10));
        } else {
            croak "The argument to Date::Math::DST->is_dst() was not recognized as a region for which this module will calculate DST.";
        }
        
        if( ($target_m100 >= $start_m100) && ($target_m100 <= $end_m100) ) {
            return 1;
        } else {
            return 0;
        }
        
        
    } else {
        croak "Insufficient arguments were passed to Date::Math::DST->is_dst(). ";
    }
}

sub is_leap_year {
    #A leap year is divisable by 4, but not by 100 (except if divisable by 400.)
    if($_[1] < 1584) {
        return 0;
    }
    elsif($_[1] > 0) {
        if($_[1] % 4 == 0) {
            if($_[1] % 100 == 0) {
                if($_[1] % 400 == 0) {
                    return 1;
                } else {
                    return 0;
                }
            } else {
                return 1;
            }
        } else {
            return 0;
        }
    } else {
        croak "No argument passed to subroutine is_leap_year().";
    }
}

sub day_of_week_by_date {
    #Arithmetic formula by Kim Larson, downloaded from: http://collaboration.cmc.ec.gc.ca/science/rpn/biblio/ddj/Website/articles/DDJ/1995/9504/9504k/9504k.htm
    #and http://www.databasesql.info/article/7252333046/
    #Monday = 0
    my $self = shift;
    my ($calc_year, $calc_month, $calc_day) = $self->extract_date_parts(@_);
    if($calc_year && $calc_month && $calc_day) {
        if($self->_is_julian($calc_year, $calc_month, $calc_day)) {
            #Cannot compute weekdays in the Julian Calendar in day_of_week_by_date().
            return -1;
        } else {
            if($calc_month <= 2) {
                $calc_month += 12;
                $calc_year--;
            }
            my $result = (($calc_day + (2 * $calc_month) + (3 * int($calc_month + 1)/5) + $calc_year + int($calc_year/4) - int($calc_year/100) + int($calc_year/400)) % 7);
            return $result;
        }
    } else {
        croak "No argument or insufficient arguments passed to the subroutine day_of_week_by_date().";
    }
}

sub nth_weekday_of_the_month {
    #$obj->nth_weekday_of_the_month([interger dow-Monday as 0], [integer nth], [year], [month]);
    #http://sqllessons.com/second_tuesday_of_the_month.html
    if( defined($_[1]) && ($_[2] > 0) && ($_[3] > 0) && ($_[4] > 0) ) {
        my $dow = $_[1];
        if($dow =~ /[a-zA-Z]/) {
            my $dn = uc(substr($dow, 0, 3));
            $dow = ($dn eq 'MON') ? 0 : ($dn eq 'TUE') ? 1 : ($dn eq 'WED') ? 2 : ($dn eq 'THU') ? 3 : ($dn eq 'FRI') ? 4 : ($dn eq 'SAT') ? 5 : 6;
        }
        my $first_weekday = $_[0]->day_of_week_by_date($_[3], $_[4], 1);
        my %first_factor = (
            1 => [1, 2, 3, 4, 5, 6, 7], #Monday
            2 => [7, 1, 2, 3, 4, 5, 6], #Tuesday
            3 => [6, 7, 1, 2, 3, 4, 5], #Wendesday
            4 => [5, 6, 7, 1, 2, 3, 4], #Thursday
            5 => [4, 5, 6, 7, 1, 2, 3], #Friday
            6 => [3, 4, 5, 6, 7, 1, 2], #Saturday
            7 => [2, 3, 4, 5, 6, 7, 1], #Sunday
        );
           #FD   #M  T  W  Th F  Sa Su
        my $return_value;
        if($_[2] > 1) {
            $return_value = $first_factor{$first_weekday + 1}[$dow] + (($_[2] - 1) * 7);
            if($return_value > $_[0]->days_in_month($_[3], $_[4])) {
                $return_value = $first_factor{$first_weekday + 1}[$dow] + (($_[2] - 2) * 7);
            }
        } else {
            $return_value = $first_factor{$first_weekday + 1}[$dow];
        }
        return $return_value;
    } else {
        croak "Insufficient arguments passed to subroutine nth_weekday_of_the_month(). ";
    }
}

sub add {
    #$obj->_add([type, [integer, [year, [month, [day, dateformat]]]]]);
    #$obj->_add([type, [integer, [datestring]]]);
    my $self = shift;
    my $type = shift;
    $type = substr($type, 0, 1);
    my $addvalue = shift;
    if($addvalue > 0) {
       my ($set_year, $set_month, $set_day) = $self->extract_date_parts(@_);
       if( $set_year > 0 && $set_month > 0 && $set_day > 0 ) {
            my @julianparts = ($set_year, $set_month, $set_day);
            if((uc($type) eq 'D') || (uc($type) eq 'W')) {
                $addvalue = $addvalue * 7 if uc($type) eq 'W';
                for(my $i = 1; $i <= $addvalue; $i++) {
                    if($self->days_in_month($set_year, $set_month) > $set_day) {
                        $set_day += 1;
                    }
                    elsif($self->days_in_month($set_year, $set_month) == $set_day) {
                        $set_month += 1;
                        $set_day = 1;
                        if($set_month > 12) {
                            $set_year += 1;
                            $set_month = 1;
                        }
                    }
                }
            }
            elsif((uc($type) eq 'M') || (uc($type) eq 'Y')) {
                $addvalue = $addvalue * 12 if uc($type) eq 'Y';
                for(my $i = 1; $i <= $addvalue; $i++) {
                    if($set_month == 12) {
                        $set_month = 1;
                        $set_year += 1;
                    } else {
                        $set_month += 1;
                    }
                }
                unless($self->is_leap_year($set_year)) {
                    if($set_month == 2 && $set_day == 29) {
                        $set_month = 3;
                        $set_day = 1;
                    }
                }

                
            } else {
                croak "Unrecognized addition type argument when evaluated by _add(). ";
            }
            if($self->_julian_crossover($julianparts[0], $julianparts[1], $julianparts[2], $set_year, $set_month, $set_day)) {
                $set_day += 10;
                if($set_day > $self->days_in_month($set_year, $set_month)) {
                    $set_day -= $self->days_in_month($set_year, $set_month);
                    $set_month--;
                }
            }
            return $self->_return_formatted_date($set_year, $set_month, $set_day);
        } else {
            croak "Start date not set when evaluated by _add(). ";
        }
    } else {
        croak "No argument passed to private subroutine _add(). ";
    }
}

sub subtract {
    #$obj->subtract([integer, [year, [month, [day, dateformat]]]]]);
    #$obj->subtract([integer, [datestring]]);
    my $self = shift;
    my $type = shift;
    $type = substr($type, 0, 1);
    my $subtractvalue = shift;
    if($subtractvalue > 0) {
       my ($set_year, $set_month, $set_day) = $self->extract_date_parts(@_);
       if( $set_year > 0 && $set_month > 0 && $set_day > 0 ) {
            my @julianparts = ($set_year, $set_month, $set_day);
            if((uc($type) eq 'D') || (uc($type) eq 'W')) {
                $subtractvalue = $subtractvalue * 7 if uc($type) eq 'W';
                for(my $i = 1; $i <= $subtractvalue; $i++) {
                    if($set_day > 1) {
                        $set_day -= 1;
                    } else {
                        $set_month -= 1;
                        if($set_month == 0) {
                            $set_year -= 1;
                            $set_month = 12;
                            $set_day = 31;
                        } else {
                            $set_day = $self->days_in_month($set_year, $set_month);
                        }
                    }
                }
            }
            elsif((uc($type) eq 'M') || (uc($type) eq 'Y')) {
                $subtractvalue = $subtractvalue * 12 if uc($type) eq 'Y';
                for(my $i = 1; $i <= $subtractvalue; $i++) {
                    if($set_month == 1) {
                        $set_month = 12;
                        $set_year -= 1;
                    } else {
                        $set_month -= 1;
                    }
                }
            } else {
                croak "Unrecognized subtraction type argument when evaluated by _subtract(). ";
            }
            if($self->_julian_crossover($julianparts[0], $julianparts[1], $julianparts[2], $set_year, $set_month, $set_day)) {
                if($set_day <= 10) {
                    $set_month--;
                    if($set_month == 0) {
                        $set_year--;
                        $set_month = 12;
                        $set_day = 31 - (10 - $set_day);
                    } else {
                        $set_day = $self->days_in_month($set_year, $set_month) - (10 - $set_day);
                    }
                } else {
                    $set_day -= 10;
                }
            }
            if($set_year < -46) {
                return $self->_return_formatted_date(46, 1, 1);
            }
            unless($self->is_leap_year($set_year)) {
                if($set_month == 2 && $set_day == 29) {
                    $set_day = 28;
                }
            }
            return $self->_return_formatted_date($set_year, $set_month, $set_day);
        } else {
            croak "Start date not set when evaluated by _subtract(). ";
        }
    } else {
        croak "No argument passed to private subroutine _subtract(). ";
    }
}

sub extract_date_parts {
    my $self = shift;
    my @temp = @_;
    my $array_size = @temp;
    if($array_size == 6) {
        #got yymdymd
        if($self->_m100($temp[0], $temp[1], $temp[2]) > $self->_m100($temp[3], $temp[4], $temp[5])) {
            return ($temp[3], $temp[4], $temp[5], $temp[0], $temp[1], $temp[2]);
        } else {
            return ($temp[0], $temp[1], $temp[2], $temp[3], $temp[4], $temp[5]);
        }
    }
    elsif($array_size == 4) {
        #got ymd datestring
        if(length($temp[0]) > 4) {
            my @ret = $self->parse_date($temp[0]);
            push @ret, $temp[1], $temp[2], $temp[3];
            return @ret; 
        } else {
            my @ret = ($temp[0], $temp[1], $temp[2]);
            push @ret, $self->parse_date($temp[3]);
            return @ret; 
        }
    }
    elsif($array_size == 3) {
        #got ymd
        return ($temp[0], $temp[1], $temp[2]);
    }
    elsif($array_size == 2) {
        #got datestring datestring
        if($self->_m100($self->parse_date($temp[0])) > $self->_m100($self->parse_date($temp[1]))) {
            return ($self->parse_date($temp[1]), $self->parse_date($temp[0]));
        } else {
            return ($self->parse_date($temp[0]), $self->parse_date($temp[1]));
        }
    }
    elsif($array_size == 1) {
        #got datestring
        return $self->parse_date($temp[0]);
    } else {
        croak "Unknown combination of elements passed to Date::Math->extract_date_parts(). ";
    }
}

sub _valid_date_format_international { return 1 if $_[1] =~ /^\d\d\d\d\D\d{1,2}\D\d{1,2}$/; return 0; }

sub _valid_date_format_us { return 1 if $_[1] =~ /^\d{1,2}\D\d{1,2}\D\d\d\d\d$/; return 0; }

sub _return_formatted_date {
    if($_[1] && $_[2] && $_[3]) {
        my $formatted = "";
        if($_[0]->{_date_format} eq "US") {
            if(abs($_[2]) < 10) {
                $formatted = "0";
            }
            $formatted .= abs($_[2]) . "/";
            if(abs($_[3]) < 10) {
                $formatted .= "0";
            }
            $formatted .= $_[3] . "/";
            $formatted .= $_[1];
        } else {
            $formatted = $_[1] . "-";
            if(abs($_[2]) < 10) {
                $formatted .= "0";
            }
            $formatted .= abs($_[2]) . "-";
            if(abs($_[3]) < 10) {
                $formatted .= "0";
            }
            $formatted .= $_[3];
        }
        return $formatted;
    } else {
        croak "No argument or insufficient arguments passed to private subroutine Date::Math->_return_formatted_date().";
    }
}

sub _julian_crossover {
    # 1582-10-04 jumps to 1582-10-15, the intermediary ten days do not exist.
    # http://aa.usno.navy.mil/data/docs/JulianDate.php
    if($_[0]->_is_julian($_[1], $_[2], $_[3]) && !$_[0]->_is_julian($_[4], $_[5], $_[6])) {
        return 1;
    }
    elsif(!$_[0]->_is_julian($_[1], $_[2], $_[3]) && $_[0]->_is_julian($_[4], $_[5], $_[6])) {
        return 1;
    } else {
        return 0;
    }
}

sub _is_julian {
    if($_[1] < 1582) {
        return 1;
    }
    elsif($_[1] > 1582) {
        return 0;
    } else {
        if($_[2] < 10) {
            return 1;
        }
        elsif($_[2] > 10) {
            return 0;
        } else {
            if($_[3] < 15) {
                return 1;
            } else {
                return 0;
            }
        }
    }
}

sub _m100 {
    if($_[1] && $_[2] && $_[3]) {
        my $return_value = $_[1];
        $return_value .= ($_[2] + 100);
        $return_value .= (length($_[3]) < 2) ? "0" . $_[3] : $_[3];
        return $return_value;
    }
    else {
        croak "Invalid number of arguments passed to _m100().";
    }
}

1;

