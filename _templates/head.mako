<title>${bf.config.blog.name}</title>
<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="${bf.util.site_path_helper(bf.config.blog.path,'/feed')}" />
<link rel="alternate" type="application/atom+xml" title="Atom 1.0" href="${bf.util.site_path_helper(bf.config.blog.path,'/feed/atom')}" />

% for css_file in bf.config.filters.syntax_highlight.mod.css_files_written:
<link rel="stylesheet" href="${bf.util.site_path_helper(bf.config.blog.path, css_file)}" type="text/css" />
% endfor
<link rel="stylesheet" href="${bf.util.site_path_helper(bf.config.blog.path,'/css/menu.css')}" type="text/css" />
<link rel="stylesheet" href="${bf.util.site_path_helper(bf.config.blog.path,'/css/style.css')}" type="text/css" />

<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-20036869-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>

