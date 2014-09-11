#!/usr/bin/env python
# get the monthly  ratesetter rates
#########################################

import urllib2
import subprocess
from xml.dom import minidom

url = 'www.ratesetter.com/lending/rates_feed.aspx'

subprocess.call(["curl", "-s", url, "-o", "/tmp/rateset.xml"])
doc = minidom.parse('/tmp/rateset.xml')
nodes = doc.getElementsByTagName('content')
for node in nodes:
	print node.firstChild.nodeValue



