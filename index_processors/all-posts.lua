-- *Pre-requisite*: `site/index.html` should contain a placeholder `<ul class='all-posts'></ul>` element even if we don't wish to put the list of all posts in our main index. Failing this, soupault will not pick up the above `[index.views.all-posts-list]` definition for processing at all.

-- Now, soupault sees the placeholder `<ul class='all-posts'>` element in `site/index.html` and processes `[index.views.all-posts-list]`, which asks soupault to

-- 1. delete the placeholder node from `site/index.html`, thus tidying up the main index page.
-- 2. generate the HTML for the list of all posts
-- 3. generate an index page `site/posts.html` and put the above HTML in it
-- 4. store the generated `site/posts.html` in `pages` env, from where soupault will pick the page and add it to the output.

-- From the manual:
-- As you can see, generated pages are stored in the pages environment. When an index processor finishes, soupault extracts that variable from its environment and adds generated pages to the page processing queue.
-- The pages variable must be a table, and its items must be tables with page_file and page_content fields.
-- The page_file field is the file path where the page would have been at if it was hand-written. Most of the time you will want to generate it with Sys.join_path(Sys.dirname(page_file), "page_name.html") to make it appear in the same directory as the index page being processed, but there are no restrictions: you can use any path and place the generated page in any section.

-- see pre-requisite and step 1 above
placeholder_container_on_main_index = HTML.select_one(page, config["index_selector"])
HTML.delete(placeholder_container_on_main_index)

-- step 2
env = {}
env["entries"] = site_index
rendered_entries = HTML.parse(String.render_template(config["index_template"], env))

-- step 3
all_posts_index_file = Sys.join_path(Sys.dirname(page_file), "posts.html")
all_posts_index_content = HTML.pretty_print(rendered_entries)

-- step 4
pages = {}
pages[1] = {}
pages[1]["page_file"] = all_posts_index_file
pages[1]["page_content"] = all_posts_index_content
