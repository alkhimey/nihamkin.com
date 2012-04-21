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
    "toc"	:	lambda _ : root.gen_toc(10, True)
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
   
    def gen_toc(self, depth, is_root=False): # TODO: Fix this!
        """ Generate an html table of contents out of the directory hierarchy """
        global toc_root_cache

        if is_root and toc_root_cache:
            return toc_root_cache
        
        if depth == 0:
            return ""
        
        for pattern in IGNORE_TOC_PATTERNS:
            if re.match(pattern, self.rel_path.split('/')[-1]):
                return ""
            
        result = ""
        if is_root:
            result += "<ul>\n"

        try: 
            result += "<li><a href=\"%s\">%s</a>\n" % (self.index.html_rel_path(), self.index.title)
        except:
            print "Warning: Directory %s has no index file, using directory name instead" % self.rel_path
            result += "<li>%s\n" % (self.rel_path.split('/')[-1])
        
        child_results = "" 
        for c in self.children:
            child_results += c.gen_toc(depth - 1)
        if child_results:
            result += "<ul>%s</ul>" % child_results

        result += "</li>\n"

        if is_root:
            result += "</ul>\n"
            toc_root_cache = result
        return result
    
    def fill_template(self, template):
        try: 
            self.index.fill_template(template)
        except:
            pass
        
        for c in self.children:
            c.fill_template(template)
        

    def __str__(self):
        return self.rel_path #+ "\n" +  "".join((c.__str__() for c in [self.children] + [self.index]))


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
        
    def gen_toc(self, depth):
        print "      file", self.rel_path, depth
        return "<li><a href=\"%s\">%s</a></li>\n" % (self.html_rel_path(), self.title)

    def fill_template(self, template):
        """ Fills the template with valuies according to the patterns and the fields of the file. Outputs the file
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

    def __str__(self):
        return self.rel_path

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
print root

# for c in root.children:
#     print c.rel_path
#     try:
#         print ">", c.index.title
#     except:
#         print ">", None


root.fill_template(template)
