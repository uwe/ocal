#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

use lib 'lib';
use OCal::Option;
use OCal::Position;


my $pos = OCal::Position->new;
$pos->add_leg( 1, OCal::Option->new(type => 'PUT', strike => 2100));
$pos->add_leg(-2, OCal::Option->new(type => 'PUT', strike => 2050));

warn Dumper $pos;

print $pos->to_r;

