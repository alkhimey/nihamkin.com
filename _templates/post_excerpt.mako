<%inherit file="post.mako" />
<%def name="post_prose(post)">
  ${post.excerpt}
</%def>
<%def name="additional_footer(post)">
% if bf.config.blog.disqus.enabled:
  <div class="after_post"><a href="${post.permalink}#disqus_thread">Read and Post Comments</a></div>
% endif
</%def>
