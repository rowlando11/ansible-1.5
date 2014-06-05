#!/usr/bin/env python
# install vmware tools
# rowlando - 16/05/2014 rowland dot ono at gmail dot com
########################################################

import os
import sys
import time
import errno
import shutil
import subprocess

dest = "/tmp/"
#source = "VMwareTools-9.0.10-1481436.tar.gz"

print
print "Ensure that VMWare Tools is installed from the vApp VM Menu"
time.sleep(1)
print

print "Starting install"

try:
    os.chdir("/root")
except OSError:
    print "The directory does not exist. Exiting"
    exit
else:
    print "Changing to /root directory"

if not os.path.exists("/root/tools"):
    print "tools directory does not exist - creating it"
    os.mkdir ("tools", 0755)
    print "tools directory created"
else:
    print "tools directory exists - good"


subprocess.call("mount" +  " /dev/sr0" + " tools", shell=True)
m = open("/etc/mtab", "r")
lines = m.read()
result = lines.find('sr0')
if result == -1:
    print "/root/tools not mounted - check that you have installed VMWare Tools in the vApp VM Menu first."
    exit 

os.chdir("tools")
print "Changing to tools directory"

# find the vmwaretools file whatever its name
# as the name changes with updates
for file in os.listdir("/root/tools"):
    if file.endswith(".gz"):
        source = file


print "Copying " + source, " to " +  dest 

try:
    shutil.copy (source, dest)
except shutil.Error as e:
    print('Error: %s' % e)
except IOError as e:
    print('Error %s' % e.strerror)

os.chdir("/tmp")
print "Changing to /tmp directory"
print
print "Uncompressing" + ' source' 

subprocess.call("tar" +  " xvfz " +  source, shell=True)
os.chdir("vmware-tools-distrib")

subprocess.call("./vmware-install.pl", shell=True)

print "Cleaning up"
subprocess.call("umount" +  " /root/tools", shell=True)

if os.path.isfile(dest + source):
    os.remove(dest + source)
    print "Removed %s" % source, "from /tmp" 
else:
    print "Error: file not available for removal %s" % dest + source
