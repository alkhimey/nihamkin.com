import markdown
import re

config = {
    'name': "Spoiler",
    'description': "Generates HTML that with appropriate CSS will hide spoiler text.",
    'author' : "Artium Nihamkin",
    }



pattern = re.compile(
  r"\$.*\$",
  re.IGNORECASE and re.DOTALL)


def run(content):
    print content 
    print "-----------------------------------------"


    return pattern.sub('<span class="spoiler"><span>XXXXX</span></span>', content)

