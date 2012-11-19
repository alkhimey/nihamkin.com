<%page args="post"/>


<%
category_styles = {"Special" : "background-color: gold;",
                   "Another Example" : "border: 3px dashed black;" }
category_names = [x.name for x in post.categories]
style = "".join([v for k,v in category_styles.items() if k in category_names])
%>


<div class="blog_post" style="${style}">
  <a name="${post.slug}"></a>
  <h2 class="blog_post_title"><a href="${post.permapath()}" rel="bookmark" title="Permanent Link to ${post.title}">${post.title}</a></h2>
  <small>${post.date.strftime("%B %d, %Y at %I:%M %p")} | categories: 
<% 
   category_links = []
   for category in post.categories:
       if post.draft:
           #For drafts, we don't write to the category dirs, so just write the categories as text
           category_links.append(category.name)
       else:
           category_links.append("<a href='%s'>%s</a>" % (category.path, category.name))
%>
${", ".join(category_links)}

<!---
% if bf.config.blog.disqus.enabled:
 | <a href="${post.permalink}#disqus_thread">View Comments</a>
% endif
-->
</small><p/>
  <div class="post_prose">
	${self.post_prose(post)}
  </div>
  
  ${self.additional_footer(post)}
  
</div>

<%def name="post_prose(post)">
  ${post.content}
</%def>

<%def name="additional_footer(post)">
</%def>
