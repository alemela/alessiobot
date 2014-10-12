# -*- coding: utf-8 -*-

import pywikibot, re, subprocess
from pywikibot import pagegenerators
import time

start = time.clock()

args = pywikibot.handleArgs()
site = pywikibot.Site('it', 'wikipedia')

today = time.strftime("%Y%m%d")

path = '/data/project/alessiobot/data/categorizzare/'+today+'.txt'
template = u'{{Categorizzare}}'
comment = u'Bot: voce non categorizzata'
has_template = r'\{\{(?:template:|)(categorizzare)[\|\}]'
has_category = r'\[\[categoria\:'
has_auto_category = r'\{\{(album|bio|brano musicale|canzone|film)'


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
	check_category = re.findall(has_category, oldtxt.lower())
	if check_category != []:
	    pywikibot.output(u'Category alreday in %s, skip' % page.title())
	    continue
	check_auto_category = re.findall(has_auto_category, oldtxt.lower())
	if check_auto_category != []:
	    pywikibot.output(u'Auto category alreday in %s, skip' % page.title())
	    continue
	
	# Ok, the page need the template. Let's put it there!
	newtxt = u"%s\n%s" % (oldtxt, template)
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
