#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = u'Artium Nihamkin'
SITENAME = u"Artium Nihamkin's Blog"

SITETITLE = 'Artium\'s Blog'
SITESUBTITLE = 'Records of software development <br> (and other stuff)'
# SITEDESCRIPTION = 'Foo Bar\'s Thoughts and Writings' # Not used in Flex theme theme

SITEURL = 'http://127.0.0.1:8000'

PATH = 'content'

TIMEZONE = 'Asia/Tel_Aviv'

DEFAULT_LANG = u'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = (('Blog', '/'),
         #('Projects', '/projects'),
         ('About', '/2012/09/01/about-this-blog/#about-this-blog') )

# Social widget
SOCIAL = (('github', 'https://github.com/alkhimey'),
          ('stack-overflow', 'http://stackoverflow.com/users/452483/artium'),)


DEFAULT_PAGINATION = 10

#ROBOTS = u'index, follow'

# Uncomment following line if you want document-relative URLs when developing
# RELATIVE_URLS = True


STATIC_PATHS = [
    'files', 
#    'images',
    'extra', 
]

EXTRA_PATH_METADATA = {
    'extra/robots.txt' : {'path': 'robots.txt'},
    'extra/favicon.ico': {'path': 'favicon.ico'},
    'extra/servbot.png': {'path': 'servbot.png'}
}

THEME = "./pelican-themes/Flex"

PYGMENTS_STYLE = 'monokai'

MAIN_MENU = True

MENUITEMS = (('Archives', '/archives.html'),
             ('Categories', '/categories.html'),
             ('Tags', '/tags.html'),)
             
COPYRIGHT_YEAR = '2012-2019'
 
FAVICON  = '/favicon.ico'
SITELOGO = '/servbot.png'

GITHUB_URL = 'https://github.com/alkhimey'

DISQUS_SITENAME = 'local-artiumsblog'
DISQUS_COMMENT_COUNT = True
#GOOGLE_ANALYTICS = "UA-36977465-1"


# Specific to the Flex theme
#
DISABLE_PAGE_BLANK_TARGET = True

#YEAR_ARCHIVE_SAVE_AS = 'posts/{date:%Y}/index.html'
#MONTH_ARCHIVE_SAVE_AS = 'posts/{date:%Y}/{date:%b}/index.html'


PLUGIN_PATHS = ['pelican-plugins']

PLUGINS = ['neighbors', 'related_posts', ] # TODO: add 'better_figures_and_images' and fix errors


# http://duncanlock.net/blog/2013/05/29/better-figures-images-plugin-for-pelican/
RESPONSIVE_IMAGES = True

# RELATED_POSTS_MAX = 10















