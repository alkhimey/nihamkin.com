<%page args="post, excerpted=False"/>

<% 
   category_links = []
   for category in post.categories:
       if post.draft:
           #For drafts, we don't write to the category dirs, so just write the categories as text
           category_links.append(category.name)
       else:
           category_links.append("<a href='%s'>%s</a>" % (category.path, category.name))    
   category_styles = {"special" : "background-color: gold;",
                      "Another Example" : "border: 3px dashed black;" }
   category_names = [x.name for x in post.categories]
  
   style = "".join([v for k,v in category_styles.items() if k in category_names])
%>

<article>
  <div class="blog_post basic_block" style="${style}">
    <header>
      <div id="${post.slug}"></div>
      <h2 class="blog_post_title"><a href="${post.permapath()}" rel="bookmark" title="Permanent Link to ${post.title}">${post.title}</a></h2>
      <p><small><span class="blog_post_date">${post.date.strftime("%B %d, %Y at %I:%M %p")}</span> | categories: 
        <span class="blog_post_categories">${", ".join(category_links)}</span>
        % if bf.config.blog.disqus.enabled:
        | <a href="${post.permalink}#disqus_thread">View Comments</a>
        % endif
      </small></p>
    </header>
    <div class="post_prose">
      ${self.post_prose(post, excerpted)}
    </div>
  </div>
</article>

<%def name="post_prose(post, excerpted)">
  % if excerpted:
    ${post.excerpt}
  % else:
    ${post.content}
  % endif
</%def>
