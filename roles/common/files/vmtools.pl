#!/usr/bin/perl -w
# install vm tools - rowlando -  rowland dot ono at gmail dot com 
# Copyright Centrality Ltd 14/05/2014
################################i################################
use strict;
use 5.10.0;
use File::Copy;

my $source = "VMwareTools-9.0.11-1743336.tar.gz";
my $dest = "/tmp";


say <<_WP_;

Before we begin, please ensure that you have installed VMWare Tools in the vApp VM Menu.

_WP_

# pause here for a bit so that the above warning is seen
sleep 2;

say "Starting install";

# change to the root dir
chdir "/root" or die "$!\n";

# check and create tools dir if 
# it does not exist
if ( ! -d "tools" ) {
    say "tools does not exist - creating it";
}
mkdir "tools", 0755;
say "tools directory created";

# mount tools dir to the dvd device
system ("mount", "/dev/sr0", "tools");

# check if the mount exists
open(F, "/etc/mtab") or die "$!\n";
my @string = (<F>);
close F;
my $f = grep /sr0/, @string;

# if the mount exists we are good to go
if ( $f ) {
    say "Ok - found $f";
}
# if the mount is missing, stop here and warn.
else {
    say <<_TOOLS; 
/root/tools not mounted - please check that you have installed VMWare Tools in the vApp VM Menu first.
    
_TOOLS
    exit 1;
}

# if we reach here, copy the files to the /tmp,
# uncompress them and install
chdir "tools" or die "$!\n";
say "Copying $source to $dest";
copy ($source, $dest) or die "File cannot be copied.\n";
chdir "/tmp";
say "uncompressing ${source}..";
system ("tar", "xvfz", "$source");
chdir "vmware-tools-distrib";
system ("./vmware-install.pl");

# unmount /root/tools dir
system ("umount", "/root/tools");

# delete /root/tools dir
rmdir "/root/tools" or die "$!\n";
