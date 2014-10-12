# -*- coding: utf-8 -*-

import pywikibot, re, subprocess
from pywikibot import pagegenerators
import time

start = time.clock()

args = pywikibot.handleArgs()
site = pywikibot.Site('it', 'wikipedia')

today = time.strftime("%Y%m%d")

path = '/data/project/alessiobot/data/voci_senza_uscita/'+today+'.txt'
template = u'{{Voci senza uscita}}'
comment = u'Bot: voce senza uscita'
regexp = r'\{\{(?:template:|)(voci senza uscita)[\|\}]'


def main():
    add_lists = pagegenerators.TextfilePageGenerator(path)
    for page in add_lists:
        # Check if the page exists or if there's already the template 
	try:
	    oldtxt = page.get()
	except pywikibot.NoPage:
	    pywikibot.output(u"%s doesn't exist! Skip" % page.title())
	    continue
	res = re.findall(regexp, oldtxt.lower())
	if res != []:
	    pywikibot.output(u'Template alreday in %s, Skip' % page.title())
	    continue
	
	# Ok, the page need the template. Let's put it there!
	newtxt = u"%s\n%s" % (template, oldtxt)
	pywikibot.output(u"\t\t>>> %s <<<" % page.title())
        try:
	    page.put(newtxt, comment)
	except pywikibot.EditConflict:
            pywikibot.output(u'Edit Conflict! Skip')
	    continue
        except pywikibot.LockedPage:
            pywikibot.output(u'Locked page! Skip')
	    continue


if __name__ == "__main__":
    try:
        main()
    finally:
        pywikibot.stopme()
	end=time.clock()
        print "Run time: ", end-start
