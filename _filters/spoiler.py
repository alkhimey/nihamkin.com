""" An extension for markdown that will recognize spoiler tags. 
	author: Artium Nihamkin
	version: 1
"""

"""
from markdown import Extension, Markdown, preprocessors
from markdown.inlinepatterns import Pattern







class SpoilerExtension(markdown.Extension):
    def add_inline(self, md, name, klass, re):
        pattern = klass(re)
        pattern.md = md
        pattern.ext = self
        md.inlinePatterns.add(name, pattern, "<reference")

    def extendMarkdown(self, md, md_globals):
        self.add_inline(md, 'bliptv', Bliptv,
            r'([^(]|^)http://(\w+\.|)blip.tv/file/get/(?P<bliptvfile>\S+.flv)')
     







class SpoilerPattern(markdown.inlinepatterns.Pattern):
    def handleMatch(self, m):
        pass


def makeExtension(configs=None) :
    return SpoilerExtension(configs=configs)
"""
