import os, shutil, errno, re, time


### Configuration
#####################################
WEB_ROOT        = "/home/artium/Documents/Website/_site"
PAGES_DIR	= "_pages"
SITE_DIR	= "_site"
TEMPLATE_PATH 	= "site.template"
IGNORE_TOC_PATTERNS = ["^images$", "^files$", "^menu$"]


### Substitution patterns
#####################################
patterns = {
    "root"	:	lambda _  :WEB_ROOT,
    "title" 	:	lambda x : x.title,
    "keywords"	:	lambda x : x.keywords,
    "description" :	lambda x : x.description,
    "content" 	:	lambda x : x.content,
    "bgcolor"	: 	lambda x : x.bgcolor,
    "textcolor" : 	lambda x : x.textcolor,
    "buildtime" : 	lambda _ : time.asctime(time.localtime()),
    "toc"	:	lambda _ : root.gen_toc_root()
}

### Globals and utility functions
#####################################
root = None
toc_root_cache = None

def conc_path(p1, p2): 
    if not p1: return p2
    if not p2: return p1
    return p1 + "/" + p2

def pages_path(rel_path):return conc_path(PAGES_DIR, rel_path) 

def site_path(rel_path): return conc_path(SITE_DIR, rel_path)

### Data structures and logic
#####################################
class Directory:
    def __init__(self, rel_path):
        self.rel_path = rel_path
        self.children = []
        self.index = None
        
        for c in os.listdir(pages_path(rel_path)):        
            if c[0] == "_":
                continue  

            rel_cpath = conc_path(rel_path, c)

            if os.path.isdir(pages_path(rel_cpath)):
                os.makedirs(site_path(rel_cpath))
                self.children.append(Directory(rel_cpath))
            elif len(c.split('.')) >= 2 and c.split('.')[-1] == "markdown":
                if c.split('.')[-2].split('/')[-1] == "index":
                    self.index = File(rel_cpath)
                    print "I", rel_cpath
                else:
                    self.children.append(File(rel_cpath))
                    print "M", rel_cpath
            else:
                shutil.copy(pages_path(rel_cpath), site_path(rel_cpath))
                print "F", rel_cpath
         

    def has_children(self):
        return len(self.children) > 0 or self.index

    def gen_toc_root(self):
        """ Generate an html table of contents out of the directory hierarchy """
        global toc_root_cache

        if not toc_root_cache:
            toc_root_cache = "<ul>\n"
            for c in [self.index] + self.children:
                toc_root_cache += c.gen_toc()
            toc_root_cache += "</ul>\n"
        return toc_root_cache

    def gen_toc(self): # TODO: Fix this!?
        for pattern in IGNORE_TOC_PATTERNS:
            if re.match(pattern, self.rel_path.split('/')[-1]):
                return ""
            
        result = ""

        if self.index: 
            result += "<li><a href=\"%s\">%s</a>\n" % (self.index.html_path(), self.index.title)
        else:
            print "Warning: Directory %s has no index file, using directory name instead" % self.rel_path
            result += "<li><a>%s</a>\n" % (self.rel_path.split('/')[-1])
        
        child_results = "" 
        for c in self.children:
            child_results += c.gen_toc()
        if child_results:
            result += "<ul>\n%s\n</ul>\n" % child_results

        result += "</li>\n"

        return result
    
    def fill_template(self, template):
        if self.index: 
            self.index.fill_template(template)
        
        for c in self.children:
            c.fill_template(template)

class File:
    def __init__(self, rel_path):
        self.rel_path = rel_path

        f = open(pages_path(rel_path))
        while True:
            line = f.readline()
            if re.match('^[ \t]*$', line): 
                break
            
            m = re.compile("\s*=\s*|\n|\r\n|\r").split(line)
            self.__dict__[m[0]] = m[1]
            
        self.content = f.read()
        
        f.close()
        
    def gen_toc(self):
        return "<li><a href=\"%s\">%s</a></li>\n" % (self.html_path(), self.title)

    def fill_template(self, template):
        """ Fills the template with values according to the patterns and the fields of the file. Outputs the file
            to it's destinateion.
        """
        global patterns

        result = template
        for p in patterns:
            try:
                result = re.sub('\[%[ \t]'+p+'[ \t]*%\]', (patterns[p])(self), result)
            except IndexError:
                print "Warning: file", self.rel_path, "does not contain attribute", p
            
        f = open(site_path(self.html_rel_path()), 'w')
        f.write(result)
        f.close()

    def html_rel_path(self):
        """ Substitutes file extension to html. """
        return '.'.join((self.rel_path).split('.')[0:-1]) + ".html"

    def html_path(self):
        return conc_path(WEB_ROOT, self.html_rel_path())

### Main
################################
try:
    shutil.rmtree(SITE_DIR)
except OSError as exc:
    if not exc.errno == errno.ENOENT:
        rasie
os.makedirs(SITE_DIR)

root = Directory("")

f = open(TEMPLATE_PATH)
template = f.read()
f.close()

root.fill_template(template)
