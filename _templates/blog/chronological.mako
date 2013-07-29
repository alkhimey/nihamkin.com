<%inherit file="bf_base_template" />
% for post in posts:

<%include file="post.mako" args="post=post, excerpted=bf.config.blog.post_excerpts.enabled" />
  % if bf.config.blog.disqus.enabled:
    <div class="after_post"><a href="${post.permalink}#disqus_thread">Read and Post Comments</a></div>
  % endif
##  <hr class="interblog" />
% endfor
%if prev_link or next_link:
<div class="basic_block">
% if prev_link:
  <a href="${prev_link}" class="bottom_navigation_link">« Previous Page</a>
% endif
% if prev_link and next_link:
  --  
% endif
% if next_link:
  <a href="${next_link}" class="bottom_navigation_link">Next Page »</a>
% endif
</div>
%endif
