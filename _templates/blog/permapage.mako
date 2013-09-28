<%inherit file="bf_base_template" />
<a id="top_of_post_anchor" />
<%include file="post.mako" args="post=post" />

% if bf.config.blog.disqus.enabled:
<div class="basic_block"><center> <a class="bottom_navigation_link" href="#top_of_post_anchor"> Back to top &uarr; </a></center> </div>

<div id="disqus_thread" class="basic_block"></div>
<script type="text/javascript">
  /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
  var disqus_shortname = '${bf.config.blog.disqus.name}'; // required: replace example with your forum shortname
  var disqus_url = "${post.permalink}";

  /* * * DON'T EDIT BELOW THIS LINE * * */
  (function() {
  var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
  dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
  (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
  })();
</script>
<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
<a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>








% endif
