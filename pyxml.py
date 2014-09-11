#!/usr/bin/env python
# get the 3 & 5 yr ratesetter rates
# http://www.ratesetter.com
#######################################################

import urllib2
from xml.dom.minidom import parseString

file = urllib2.urlopen('http://www.ratesetter.com/lending/rates_feed.aspx')
data = file.read()
file.close()
dom = parseString(data)
xmlTag = dom.getElementsByTagName('content')[0].toxml()
xmlData=xmlTag.replace('<content>', '').replace('</content>','')
#print xmlTag
print xmlData[:-83]  +  xmlData[79:]
