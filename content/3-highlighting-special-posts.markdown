Tags: Blogofile, Special
date: 2012/09/25 17:00:00
title: Highlighting Special Posts in Blogofile
draft: false

This simple but use-full blogofile hack will allow you to alter the style of posts which are marked as special. 
For example the post you are reading belongs to the "Special" category and therefore has a golden background instead of the gray default one.

This is quite straightforward hack, all you have to do is to modify the "_templates/site.mako" template (assuming version 0.7.1). 

Replace the line:

$$code(lang=mako)
<div class="blog_post">
$$/code

with the following snippet:

$$code(lang=mako)
% if "Special" in [x.name for x in post.categories]:
<div class="blog_post" style="background-color: gold;">
% else:
<div class="blog_post">
% endif
$$/code

As can be seen, we check for the existence of the category name "Style" in a list that contains the names of all the categories of the current post. 
If this name exists we output the div element with custom style.


This is enough for simple usage, but the idea can be extended for multiple category names and styles, allowing us to style each category differently.

Add the following code at the top of "_templates/site.mako":
$$code(lang=mako)
<%
category_styles = {"Special" : "background-color: gold;",
                   "Another Example" : "border: 3px dashed black;" }
category_names = [x.name for x in post.categories]
style = "".join([v for k,v in category_styles.items() if k in category_names])
%>
$$/code

As you can see, it is possible to add more category-style pairs into the "category_styles" dictionary. Ideally we would like to put this into the _config.py file , but currently I do not know how to do it.

And finally, we need to update the div element to look like this:
$$code(lang=mako)
<div class="blog_post" style="${style}">
$$/code
