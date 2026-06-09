#!/usr/bin/env ruby
# scripts/preview_email.rb
# Words Make Worlds — email preview and send pipeline
# Added by Claude Code - 2026-06-08
#
# Usage:
#   bundle exec ruby scripts/preview_email.rb            # interactive picker → source/email_preview.html
#   bundle exec ruby scripts/preview_email.rb --send     # interactive picker → Buttondown draft
#   bundle exec ruby scripts/preview_email.rb path/to/file.html.md
#   bundle exec ruby scripts/preview_email.rb path/to/file.html.md --send

require 'yaml'
require 'erb'
require 'date'
require 'net/http'
require 'json'
require 'uri'

begin
  require 'dotenv'
  Dotenv.load(File.join(__dir__, '../.env'))
rescue LoadError
end

require 'redcarpet'
require 'sassc'
require 'premailer'

# ─── Config ──────────────────────────────────────────────────────────────────

ARTICLES_DIR  = File.join(__dir__, '../source/words-make-worlds')
NOTES_DIR     = File.join(__dir__, '../source/words-make-worlds/notes')
TEMPLATE_PATH = File.join(__dir__, '../source/layouts/wmw-email.erb')
SCSS_PATH     = File.join(__dir__, '../source/stylesheets/email-wmw.scss')
OUTPUT_FILE   = File.join(__dir__, '../source/email_preview.html')
BASE_URL      = 'https://methodandmatter.com'

# ─── Frontmatter ─────────────────────────────────────────────────────────────

def parse_frontmatter(file_content)
  if file_content =~ /\A---\s*\n(.*?)\n---\s*\n(.*)/m
    [YAML.safe_load($1) || {}, $2]
  else
    [{}, file_content]
  end
end

def parse_date(str)
  return nil if str.nil? || str.to_s.strip.empty?
  Date.parse(str.to_s.gsub(/(\d+)(st|nd|rd|th)/, '\1'))
rescue ArgumentError
  nil
end

# ─── Markdown ────────────────────────────────────────────────────────────────

def markdown_to_html(text)
  renderer = Redcarpet::Render::HTML.new(
    hard_wrap: false,
    link_attributes: { target: '_blank' }
  )
  md = Redcarpet::Markdown.new(renderer,
    footnotes:          true,
    autolink:           true,
    tables:             true,
    fenced_code_blocks: true,
    strikethrough:      true,
    superscript:        true
  )
  md.render(text)
end

def post_process_html(html)
  # {: .caption} on a line after an image paragraph
  html = html.gsub(/<p>(<img[^>]+>)\s*\n?(.*?)\{: \.caption\}<\/p>/m) do
    "#{$1}\n<p class=\"caption\">#{$2.strip}</p>"
  end
  # {: .caption} on a text-only paragraph
  html = html.gsub(/<p>((?!<img).+?)\{: \.caption\}<\/p>/m) do
    "<p class=\"caption\">#{$1.strip}</p>"
  end
  # {: .center}
  html = html.gsub(/<p>(.*?)\{: \.center\}<\/p>/m) do
    "<p class=\"center\">#{$1.strip}</p>"
  end
  html
end

# Rewrites bare relative image src paths to absolute URLs.
# WMW markdown uses `wmw/foo.jpg` which Middleman serves at /images/wmw/foo.jpg.
def rewrite_image_srcs(html, send_mode:)
  html.gsub(/src="([^"]*)"/) do |_match|
    src = $1
    next "src=\"#{src}\"" if src.start_with?('http://', 'https://', 'data:')
    src = src.sub(/^\//, '')
    src = "images/#{src}" unless src.start_with?('images/')
    send_mode ? "src=\"#{BASE_URL}/#{src}\"" : "src=\"/#{src}\""
  end
end

# ─── SCSS ────────────────────────────────────────────────────────────────────

def compile_scss
  SassC::Engine.new(
    File.read(SCSS_PATH),
    style: :expanded,
    load_paths: [File.join(__dir__, '../source/stylesheets')]
  ).render
end

# ─── URL helpers ─────────────────────────────────────────────────────────────

def web_url_for_article(filepath)
  slug = File.basename(filepath, '.html.md')
  "#{BASE_URL}/words-make-worlds/#{slug}/"
end

def web_url_for_note(filepath)
  # Middleman's blog extension concatenates the subdirectory name with the slug
  slug = File.basename(filepath, '.html.md')
  "#{BASE_URL}/words-make-worlds/notes-#{slug}/"
end

# ─── Notes since last issue ──────────────────────────────────────────────────

def previous_issue_date(current_filepath, all_article_files)
  current_data, _ = parse_frontmatter(File.read(current_filepath))
  current_date    = parse_date(current_data['date'])
  return nil unless current_date

  candidates = all_article_files
    .reject  { |f| f == current_filepath }
    .filter_map do |f|
      d, _ = parse_frontmatter(File.read(f))
      next if d['published'] == false
      article_date = parse_date(d['date'])
      next unless article_date && article_date < current_date
      article_date
    end

  candidates.max
end

def notes_since(cutoff_date)
  return [] unless cutoff_date

  Dir.glob(File.join(NOTES_DIR, '*.html.md')).filter_map do |f|
    data, _ = parse_frontmatter(File.read(f))
    next if data['published'] == false
    note_date = parse_date(data['date'])
    next unless note_date && note_date > cutoff_date
    { title: data['title'], url: web_url_for_note(f), date: note_date }
  end.sort_by { |n| n[:date] }
end

# ─── Build ───────────────────────────────────────────────────────────────────

def build_email(filepath, all_article_files, send_mode: false)
  raw = File.read(filepath)
  data, body = parse_frontmatter(raw)

  title   = data['title'] || 'Words Make Worlds'
  date    = data['date'].to_s
  issue   = data['issue']
  web_url = web_url_for_article(filepath)

  content = markdown_to_html(body)
  content = post_process_html(content)
  content = rewrite_image_srcs(content, send_mode: send_mode)

  prev_date    = previous_issue_date(filepath, all_article_files)
  recent_notes = notes_since(prev_date)

  circle_image_url = send_mode \
    ? "#{BASE_URL}/images/wmw/wmw-circle-transparent.png" \
    : "/images/wmw/wmw-circle-transparent.png"

  styles = compile_scss

  template = File.read(TEMPLATE_PATH)
  html = ERB.new(template).result(binding)

  premailer = Premailer.new(
    html,
    with_html_string: true,
    warn_level:       Premailer::Warnings::SAFE,
    base_url:         BASE_URL,
    input_encoding:   'UTF-8'
  )
  premailer.to_inline_css
end

# ─── Send to Buttondown ──────────────────────────────────────────────────────

def send_to_buttondown(filepath, all_article_files)
  api_key = ENV['BUTTONDOWN_API_KEY']
  unless api_key
    puts "ERROR: BUTTONDOWN_API_KEY not set. Add it to .env"
    exit 1
  end

  data, _ = parse_frontmatter(File.read(filepath))
  subject  = data['title'] || File.basename(filepath, '.html.md')
  issue    = data['issue']

  puts "\nBuilding HTML..."
  html = build_email(filepath, all_article_files, send_mode: true)

  puts "\nSubject : #{subject}"
  puts "Issue   : #{issue ? "№ #{issue}" : '(none)'}"
  puts "File    : #{File.basename(filepath)}"
  puts ""
  print "Post to Buttondown as DRAFT? [y/N] "
  confirm = $stdin.gets.chomp
  return unless confirm.downcase == 'y'

  uri  = URI('https://api.buttondown.email/v1/emails')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  req = Net::HTTP::Post.new(uri)
  req['Authorization'] = "Token #{api_key}"
  req['Content-Type']  = 'application/json'
  # Prepend editor-mode hint so Buttondown treats this as raw HTML (no template wrapper)
  raw_html = "<!-- buttondown-editor-mode: html -->#{html}"
  req.body = JSON.generate(subject: "(draft) #{subject}", body: raw_html, status: 'draft', template: nil)

  puts "Posting..."
  res = http.request(req)

  if res.code.to_i == 201
    draft = JSON.parse(res.body)
    puts "✓ Draft created: #{draft['id']}"
    puts "  https://buttondown.email/emails/#{draft['id']}"
  else
    puts "✗ #{res.code}: #{res.body}"
  end
end

# ─── Main ─────────────────────────────────────────────────────────────────────

send_mode = ARGV.delete('--send')
file_arg  = ARGV.first

all_article_files = Dir.glob(File.join(ARTICLES_DIR, '*.html.md'))
  .select { |f|
    d, _ = parse_frontmatter(File.read(f))
    d['issue'] && d['published'] != false
  }
  .sort_by { |f|
    d, _ = parse_frontmatter(File.read(f))
    d['issue'].to_i
  }

if file_arg
  filepath = File.expand_path(file_arg)
  unless File.exist?(filepath)
    puts "File not found: #{filepath}"
    exit 1
  end
else
  puts "\nWords Make Worlds — Email Pipeline"
  puts "─" * 38
  all_article_files.each_with_index do |f, i|
    d, _ = parse_frontmatter(File.read(f))
    puts "  #{i + 1}.  №#{d['issue'].to_s.ljust(4)}  #{d['title']}"
  end
  puts ""
  print "Select [1–#{all_article_files.length}]: "
  choice   = $stdin.gets.to_i
  filepath = all_article_files[choice - 1]
  unless filepath
    puts "Invalid selection."
    exit 1
  end
end

if send_mode
  send_to_buttondown(filepath, all_article_files)
else
  puts "Building preview..."
  html = build_email(filepath, all_article_files, send_mode: false)
  File.write(OUTPUT_FILE, html)
  puts "✓ Open source/email_preview.html in your browser"
end
