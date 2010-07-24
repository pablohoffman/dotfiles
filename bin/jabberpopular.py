#!/usr/bin/python
# jabberpopular - script to get most popular people in jabber rooms, parsing
# ejabberd room logs. pablo - 14 Apr 2008

import sys, os, re

NICK_RE = re.compile('<font class="mn">&lt;(.*?)&gt;</font>')

lines = {}
for dir, _, files in os.walk(sys.argv[1]):
    for file in files:
        if file.endswith('.html'):
            f = open("%s/%s" % (dir, file))
            for l in f.readlines():
                m = NICK_RE.search(l)
                if m:
                    lines[m.group(1)] = lines.get(m.group(1), 0) + 1
            f.close()

import pprint
toplist = [(v, k) for k, v in lines.iteritems()]
toplist.sort(reverse=True)
pprint.pprint(toplist)
