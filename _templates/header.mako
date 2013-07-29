<header>

  <div id="header" class="basic_block">

    <a href="${bf.util.site_path_helper()}">
          Artium Nihamkin's Blog
##      <img src="${bf.util.site_path_helper(bf.config.blog.path,'/files/title.gif')}" alt="${bf.config.blog.name}" />
    </a>

## Currently, no need for navigation
##

##  <div id="navigation" class="grid_12">
<%
def nav_class(path):
   render_path = bf.template_context.render_path.rsplit("/index.html")[0]
   if render_path == path or (path == "/" and render_path == "."):
       return "selected"
   return ""
%>

##    <ul class="theme_font">
##      <li><a href="${bf.util.site_path_helper()}"
##             class="${nav_class(bf.util.site_path_helper())}">Home</a></li>
##      <li><a href="${bf.util.site_path_helper(bf.config.blog.path)}"
##             class="${nav_class(bf.util.site_path_helper(bf.config.blog.path))}">Blog</a></li>
##      <li><a href="${bf.util.site_path_helper(bf.config.blog.path,'archive')}"
##             class="${nav_class(bf.util.site_path_helper(bf.config.blog.path,'archive'))}">Archives</a></li>
##    </ul>
##</div>
  </div>
</header>
