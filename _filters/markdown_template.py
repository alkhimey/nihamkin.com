import markdown
#from markdown import Extension, Markdown, preprocessors
#from markdown.inlinepatterns import Pattern

import logging

config = {
    'name': "Markdown",
    'description': "Renders markdown formatted text to HTML",
    'aliases': ['markdown']
    }


#Markdown logging is noisy, pot it down:
logging.getLogger("MARKDOWN").setLevel(logging.ERROR)










def run(content):
    return markdown.markdown(content)
