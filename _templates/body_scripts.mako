  <script src="//ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js"></script>
  <script>!window.jQuery && document.write(unescape('%3Cscript src="/js/libs/jquery-1.5.1.min.js"%3E%3C/script%3E'))</script>
  <script src="${bf.util.site_path_helper('js/plugins.js')}"></script>
  <script src="${bf.util.site_path_helper('js/script.js')}"></script>
  <script src="${bf.util.site_path_helper('js/jquery.tweet.js')}"></script>  
  <script src="${bf.util.site_path_helper('js/site.js')}"></script>
  <!--[if lt IE 7 ]>
  <script src="js/libs/dd_belatedpng.js"></script>
  <script> DD_belatedPNG.fix('img, .png_bg');</script>
  <![endif]-->
  <script>
      var _gaq=[['_setAccount','${bf.config.blog.googleanlytics_id}'],['_trackPageview']];
      (function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];g.async=1;
      g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js';
      s.parentNode.insertBefore(g,s)}(document,'script'));
  </script>

  % if bf.config.blog.disqus.enabled:
  <script>

    /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
    var disqus_shortname = 'artiumsblog'; // required: replace example with your forum shortname

    /* * * DON'T EDIT BELOW THIS LINE * * */
    (function () {
        var s = document.createElement('script'); s.async = true;
        s.type = 'text/javascript';
        s.src = '//' + disqus_shortname + '.disqus.com/count.js';
        (document.getElementsByTagName('HEAD')[0] || document.getElementsByTagName('BODY')[0]).appendChild(s);
    }());

  /*(function() {
      var links = document.getElementsByTagName('a');
      var query = '?';
      for(var i = 0; i < links.length; i++) {
          if(links[i].href.indexOf('#disqus_thread') >= 0) {
              query += 'url' + i + '=' + encodeURIComponent(links[i].href) + '&';
          }
      }
      document.write('<script charset="utf-8" type="text/javascript" src="http://disqus.com/forums/artiumsblog/get_num_replies.js' + query + '"></' + 'script>');
  })();*/
  </script>
  % endif
