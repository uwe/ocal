#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;
use File::Slurp;
use Statistics::R;

use lib 'lib';
use OCal::Option;
use OCal::Position;


my $pos = OCal::Position->new;
$pos->add_leg( 1, OCal::Option->new(type => 'PUT', strike => 2100));
$pos->add_leg(-2, OCal::Option->new(type => 'PUT', strike => 2050));

warn Dumper $pos;

write_file('out.r', $pos->to_r);


my $R = Statistics::R->new;
#$R->run('pdf("file.pdf")');
#$R->run('X11()');
#$R->run('png(filename="out.png", width="1000", height="500", units="px", pointsize="12")');
$R->run('png(filename="out.png", width=1000, height=500, units="px", pointsize=12)');
$R->run($pos->to_r);

$R->stop;

