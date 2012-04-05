import os, shutil, errno, re, time




### Configuration
#####################################
PAGES_DIR	= "_pages"
SITE_DIR	= "_site"
TEMPLATE_PATH 	= "site.template"



### Substitution patterns
#####################################
root = None
patterns = {
    "title" 	:	lambda x : x.title,
    "keywords"	:	lambda x : x.keywords,
    "description" :	lambda x : x.description,
    "content" 	:	lambda x : x.content,
    "bgcolor"	: 	lambda x : x.bgcolor,
    "textcolor" : 	lambda x : x.textcolor,
    "buildtime" : 	lambda _ : time.asctime(time.localtime()),
    "toc"	:	lambda _ : root.gen_toc(2)
}

    
class Directory:
    def __init__(self, rel_path):
        self.rel_path = rel_path
        self.children = []
        self.index = None

    def has_children(self):
        return len(self.children) == 0 #TODO: Find more pythonic way to express this.
   
    def gen_toc(self, depth): # TODO: Fix this!
        print "gen_toc dir", self.rel_path
        """ Generate an html table of contents out of the directory hierarchy """
        if depth == 0:
            return

        result = ""
        try: 
            result += "<ul>\n<li><a href=\"%s\">%s</a><li>\n" % (self.index.html_rel_path(), self.index.title)
        except:
            print "Warning: Directory %s has no index file, using directory name instead" % self.rel_path
            result += "<ul>\n<li>%s<li>\n" % (self.rel_path.split('/')[-1])
        
        for c in self.children:
            result += c.gen_toc(depth - 1)
       
        result += "</ul>"
        return result
    
    def fill_template(self, template):
        try: 
            self.index.fill_template(template)
        except:
            pass
        
        for c in self.children:
            c.fill_template(template)
        

    def __str__(self):
        return self.rel_path + "\n" +  "".join((c.__str__() for c in self.children))


class File:
    def __init__(self, rel_path):
        self.rel_path = rel_path

        f = open(PAGES_DIR + "/" + self.rel_path)
        while True:
            line = f.readline()
            if re.match('^[ \t]*$', line): 
                break
            
            m = re.compile("\s*=\s*|\n|\r\n|\r").split(line)
            self.__dict__[m[0]] = m[1]
            
        self.content = f.read()
        
        f.close()
        
    def gen_toc(self, depth):
        print "a"
        return "<li><a href=\"%s\">%s</a><li>\n" % (self.rel_path, self.title)

    def fill_template(self, template):
        global patterns

        result = template
        for p in patterns:
            try:
                result = re.sub('\[%[ \t]'+p+'[ \t]*%\]', (patterns[p])(self), result)
            except:
                print "Warning: file", self.rel_path, "does not contain attribute", p

        f = open(SITE_DIR + "/" + self.html_rel_path(), 'w')
        f.write(result)
        f.close()

    def html_rel_path(self):
        return '.'.join((self.rel_path).split('.')[0:-1]) + ".html"

    def __str__(self):
        return self.rel_path + "\n"




def build_directory(rel_path=""):
     print "D", rel_path
     d = Directory(rel_path)

     for c in os.listdir(PAGES_DIR + "/" + rel_path):        
         if c[0] == "_":
             continue  
 
         if rel_path != "": 
             rel_cpath = rel_path + "/" + c
         else:
             rel_cpath = c

         if os.path.isdir(PAGES_DIR + "/" + rel_cpath):
             os.makedirs(SITE_DIR + "/" + rel_cpath)
             d.children.append(build_directory(rel_cpath))
         elif len(c.split('.')) >= 2 and c.split('.')[-1] == "markdown":
             if c.split('.')[-2].split('/')[-1] == "index":
                 d.index = File(rel_cpath)
                 print "I", rel_cpath
             else:
                 d.children.append(File(rel_cpath))
                 print "M", rel_cpath
         else:
             shutil.copy(PAGES_DIR + "/" + rel_cpath, SITE_DIR + "/" + rel_cpath)
             print "F", rel_cpath

     return d



### Main
################################

try:
    shutil.rmtree(SITE_DIR)
except OSError as exc:
    if not exc.errno == errno.ENOENT:
        rasie
os.makedirs(SITE_DIR)

root = build_directory()


f = open(TEMPLATE_PATH)
template = f.read()
f.close()

root.fill_template(template)
