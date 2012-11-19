<%inherit file="base.mako" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    ${self.head()}
  </head>
  <body>
    <div id="content">
	  <div id="maincontent">
		<div class="innertube">
		  
		  ${self.header()}
		  <div id="main_block">
			<div id="prose_block">
			  ${next.body()}
			</div>
		  </div>
		</div>




		<!---<p id="credits">
		  Powered by <a href="http://www.blogofile.com">Blogofile</a>.<br/>
		  <br/>
		  RSS feeds for <a href="${bf.util.site_path_helper(bf.config.blog.path,'feed')}">Entries</a>
		  % if bf.config.blog.disqus.enabled:
		  and <a
				 href="http://${bf.config.blog.disqus.name}.disqus.com/latest.rss">Comments</a>.
		  % endif
		  <br>
		</p>--->
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
		</div>
	

	  <div id="footer">
        ${self.footer()}
      </div> <!-- End Footer -->
    </div> <!-- End Content -->
  </body>
</html>
<%def name="head()">
  <%include file="head.mako" />
</%def>
<%def name="header()">
  <%include file="header.mako" />
</%def>
<%def name="footer()">
  <%include file="footer.mako" />
</%def>
