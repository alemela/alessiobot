# -*- coding: utf-8 -*-

import pywikibot, re, subprocess
from pywikibot import pagegenerators
import time, sys

start = time.clock()

args = pywikibot.handleArgs()
site = pywikibot.Site('it', 'wikipedia')

today = time.strftime("%Y%m%d")

if sys.argv[1] == "immagini_orfane_libere":
    path = '/data/project/alessiobot/data/immagini_orfane/immagini_orfane_libere/'+today+'.txt'
    template = u'{{Immagine orfana|libera}}'
    comment = u'Bot: immagine orfana con licenza libera'
elif sys.argv[1] == "immagini_orfane_non_libere":
    path = '/data/project/alessiobot/data/immagini_orfane/immagini_orfane_non_libere/'+today+'.txt'
    template = u'{{Immagine orfana|non libera}}'
    comment = u'Bot: immagine orfana con licenza non libera'
elif sys.argv[1] == "immagini_orfane_pd_italia":
    path = '/data/project/alessiobot/data/immagini_orfane/immagini_orfane_PD-italia/'+today+'.txt'
    template = u'{{Immagine orfana|PD-Italia}}'
    comment = u'Bot: immagine orfana con licenza PD italia'
elif sys.argv[1] == "immagini_orfane_sconosciute":
    path = '/data/project/alessiobot/data/immagini_orfane/immagini_orfane_sconosciute/'+today+'.txt'
    template = u'{{Immagine orfana}}'
    comment = u'Bot: immagine orfana con licenza sconosciuta'
else:
    print "Unvalid type of licence"
    exit()

has_template = r'\{\{(?:template:|)(immagine_orfana)[\|\}]'


def main():
    add_lists = pagegenerators.TextfilePageGenerator(path)
    for page in add_lists:
        # Check if the page exists or if there's already the template 
	try:
	    oldtxt = page.get()
	except pywikibot.NoPage:
	    pywikibot.output(u"%s doesn't exist! Skip" % page.title())
	    continue
        except pywikibot.IsRedirectPage:
            pywikibot.output(u"%s is redirect, skip" % page.title(asLink=True))
            return
	check_notice = re.findall(has_template, oldtxt.lower())
	if check_notice != []:
	    pywikibot.output(u'Template alreday in %s, skip' % page.title())
	    continue
	
	# Ok, the page need the template. Let's put it there!
	newtxt = u"%s\n%s" % (template, oldtxt)
        try:
	    page.put(newtxt, comment)
	    pywikibot.output(u"\t\t>>> %s <<<" % page.title())
            # pywikibot.output(u"editing!!!")
        except pywikibot.LockedPage:
            pywikibot.output(u'%s is a locked page! Skip' %page.title())
	    continue
	except pywikibot.EditConflict:
            pywikibot.output(u'Edit Conflict! Skip')
	    continue


if __name__ == "__main__":
    try:
        main()
    finally:
        pywikibot.stopme()
	end=time.clock()
        print "Run time: ", end-start
