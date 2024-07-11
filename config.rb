# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

activate :directory_indexes

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false


# Redirects
redirect "essays/building-a-relationship-with-change", to: "writing/essays/building-a-relationship-with-change"

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

# proxy(
#   '/this-page-has-no-template.html',
#   '/template-file.html',
#   locals: {
#     which_fake_page: 'Rendering a fake page with a local variable'
#   },
# )

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

# helpers do
#   def some_helper
#     'Helping'
#   end
# end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

configure :build do
   activate :minify_css
   activate :minify_javascript
end

activate :blog do |blog|
  blog.name = "notes"
  blog.prefix = "writing/notes"
  blog.sources = "{title}.html"
  blog.permalink = "{title}"
  blog.layout = "layouts/notes"

  blog.default_extension = ".md"

  blog.new_article_template = File.expand_path('../source/notes/template.yml', __FILE__)

  #blog.tag_template = "tag.html"
  #blog.calendar_template = "calendar.html"

  # Enable pagination
  #blog.paginate = true
end

activate :blog do |blog|
  blog.name = "the-becoming"
  blog.prefix = "the-becoming"
  blog.sources = "{title}.html"
  blog.permalink = "{title}"
  blog.layout = "layouts/newsletter"

  blog.default_extension = ".md"

  blog.new_article_template = File.expand_path('../source/the-becoming/template.yml', __FILE__)

  #blog.tag_template = "tag.html"
  #blog.calendar_template = "calendar.html"

  # Enable pagination
  #blog.paginate = true
end

activate :blog do |blog|
  blog.name = "essays"
  blog.prefix = "writing/essays"
  blog.sources = "{title}.html"
  blog.permalink = "{title}"
  blog.layout = "layouts/essays"

  blog.default_extension = ".md"

  #blog.new_article_template = File.expand_path('../source/kp/template.yml', __FILE__)

  #blog.tag_template = "tag.html"
  #blog.calendar_template = "calendar.html"

  # Enable pagination
  #blog.paginate = true
end

activate :blog do |blog|
  blog.name = "words-make-worlds"
  blog.prefix = "words-make-worlds"
  blog.sources = "{title}.html"
  blog.permalink = "{title}"
  blog.layout = "layouts/notes"

  blog.default_extension = ".md"

  #blog.new_article_template = File.expand_path('../source/kp/template.yml', __FILE__)

  #blog.tag_template = "tag.html"
  #blog.calendar_template = "calendar.html"

  # Enable pagination
  #blog.paginate = true
end

# alternate layouts
page "the-becoming/*", :layout => :newsletter
page "notes/*", :layout => :essays
page "essays/*", :layout => :essays
page "words-make-worlds/*", :layout => :wmw
page "writing/*", :layout => :essays
