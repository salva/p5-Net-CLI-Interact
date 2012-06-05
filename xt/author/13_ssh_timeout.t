#!/usr/bin/perl

use strict; use warnings FATAL => 'all';
use Test::More 0.88;

BEGIN { use_ok( 'Net::CLI::Interact') }

my $s = Net::CLI::Interact->new(
    transport => "SSH",
    ($^O eq 'MSWin32' ?
        (app => "$ENV{HOMEPATH}\\Desktop\\plink.exe") : () ),
    connect_options => { host => "route-server.bb.pipex.net" },
    personality => "cisco",
);

# should fail
eval { $s->cmd('show clock') };
like( $@, qr/Connection timed out/, 'Timed Out' );

done_testing;