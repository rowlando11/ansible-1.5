#!/usr/bin/perl -w
# install vm tools - rowlando ronobrauch@centrality.com 14/05/2014
# Copyright Centrality Ltd
##################################################################
use strict;
use File::Copy;

my $source = "VMwareTools-9.0.10-1481436.tar.gz";
my $dest = "/tmp";


print <<_WP_;

Before we begin, please ensure that you have installed VMWare Tools in the vApp VM Menu.

_WP_

# wait here fir a bit so that the above warning is seen
sleep 5;

print "Starting install\n";

# change to the root dir
chdir "/root" or die "$!\n";

# check and create tools dir if 
# it does not exist
if ( ! -d "tools" ) {
    print "tools does not exist - creating it\n";
}
mkdir "tools", 0755;
print "tools directory created\n";

# mount tools dir to the dvd device
system ("mount", "/dev/sr0", "tools");

# check if the mount exists
open(F, "/etc/mtab") or die "$!\n";
my @string = (<F>);
close F;
my $f = grep /sr0/, @string;

# if the mount exists we are good to go
if ( $f ) {
    print "Ok - found $f\n";
}
# if the mount is missing, stop here and warn.
else {
    print <<_TOOLS; 
/root/tools not mounted - please check that you have installed VMWare Tools in the vApp VM Menu first.
    
_TOOLS
    exit 1;
}

# if we reach here, copy the files to the /tmp,
# uncompress them and install
chdir "tools" or die "$!\n";
print "Copying $source to $dest\n";
copy ($source, $dest) or die "File cannot be copied.\n";
chdir "/tmp";
print "uncompressing VMwareTools-9.0.10-1481436.tar.gz..\n";
system ("tar", "xvfz", "VMwareTools-9.0.10-1481436.tar.gz");
chdir "vmware-tools-distrib";
system ("./vmware-install.pl");

# unmount /root/tools dir
system ("umount", "/root/tools");

# delete /root/tools dir
rmdir "/root/tools" or die "$!\n";
