<!-- Menu Start -->
<div id="framecontent">
  <div class="menu">
	<ul>
	  <li><a href="${bf.config.blog.path}">Home</a></li>
	  <li><a href="${bf.util.site_path_helper(bf.config.blog.path, 'category/about/')}">About</a></li>
	  <li><a>Projects</a>
		<ul>
		  <li><a href="${bf.util.site_path_helper(bf.config.blog.path, 'category/blogofile')}">Blogofile Extension</a></li>
		</ul>
	  </li>
	  <li><a href="${bf.util.site_path_helper(bf.config.blog.path, 'category/cg/')}">CG</a></li>
	  <li><a href="${bf.util.site_path_helper(bf.config.blog.path, 'category/robotics/')}">Robotics</a></li>
	  </li>
	</ul>
	
  </div>
</div> 
<!-- Menu End -->



<!--
<p id="credits">
Powered by <a href="http://www.blogofile.com">Blogofile</a>.<br/>
<br/>
RSS feeds for <a href="${bf.util.site_path_helper(bf.config.blog.path,'feed')}">Entries</a>
% if bf.config.blog.disqus.enabled:
 and <a
href="http://${bf.config.blog.disqus.name}.disqus.com/latest.rss">Comments</a>.
% endif
<br>
</p>
% if bf.config.blog.disqus.enabled:
<script type="text/javascript">
//<![CDATA[
(function() {
		var links = document.getElementsByTagName('a');
		var query = '?';
		for(var i = 0; i < links.length; i++) {
			if(links[i].href.indexOf('#disqus_thread') >= 0) {
				query += 'url' + i + '=' + encodeURIComponent(links[i].href) + '&';
			}
		}
		document.write('<script charset="utf-8" type="text/javascript" src="http://disqus.com/forums/${bf.config.blog.disqus.name}/get_num_replies.js' + query + '"></' + 'script>');
	})();
//]]>
</script>
% endif
-->

