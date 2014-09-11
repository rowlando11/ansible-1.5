#!/usr/bin/env python
# get the monthly  ratesetter rates
#########################################

import urllib2
from xml.dom import minidom


doc = minidom.parse('rateset.xml')
nodes = doc.getElementsByTagName('content')
for node in nodes:
	print node.firstChild.nodeValue



