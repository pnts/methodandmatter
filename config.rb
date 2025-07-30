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
redirect "essays/building-a-relationship-with-change", to: "writing/guides/building-a-relationship-with-change"
redirect "essays/end-of-a-cycle", to: "writing/guides/end-of-a-cycle"

# Words Make Worlds to Essays redirects
redirect "words-make-worlds/001", to: "writing/essays/welcome-to-coaching-leadership"
redirect "words-make-worlds/002", to: "writing/essays/the-learning-container"
redirect "words-make-worlds/003", to: "writing/essays/working-with-strengths"
redirect "words-make-worlds/004", to: "writing/essays/the-loop-of-awareness"
redirect "words-make-worlds/005", to: "writing/essays/optimism"
redirect "words-make-worlds/006", to: "writing/essays/curiosity"
redirect "words-make-worlds/007", to: "writing/essays/beginning-together"
redirect "words-make-worlds/008", to: "writing/essays/asking-questions"
redirect "words-make-worlds/009", to: "writing/essays/the-coaching-process"
redirect "words-make-worlds/010", to: "writing/essays/noticing-and-exploring"
redirect "words-make-worlds/011", to: "writing/essays/reflection-and-meaning-making"
redirect "words-make-worlds/012", to: "writing/essays/taking-action"
redirect "words-make-worlds/013", to: "writing/essays/ending-well"
redirect "words-make-worlds/014", to: "writing/essays/soft-eyes"
redirect "words-make-worlds/015", to: "writing/essays/presence"
redirect "words-make-worlds/016", to: "writing/essays/seasons"
redirect "words-make-worlds/017", to: "writing/essays/living-in-language"
redirect "words-make-worlds/018", to: "writing/essays/listening"
redirect "words-make-worlds/019", to: "writing/essays/distinctions"
redirect "words-make-worlds/020", to: "writing/essays/metaphors"

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
