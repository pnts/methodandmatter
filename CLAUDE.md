# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a **Middleman-based static site** for Method & Matter, a leadership coaching and consulting business. The site features multiple content types managed through Middleman's blog extension:

- **Main site pages**: Static ERB templates for coaching services, about pages, etc.
- **Multiple blog configurations**:
  - `notes` blog (writing/notes) - General notes and articles
  - `the-becoming` blog - Newsletter content with newsletter layout
  - `essays` blog (writing/essays) - Long-form essays
  - `words-make-worlds` blog - Specialized newsletter content with wmw layout

## Ruby Version

This project requires **Ruby 2.7.8**. Ensure you're using the correct Ruby version before running any commands:

```bash
# Switch to Ruby 2.7.8 (using rvm)
rvm use 2.7.8
```

## Key Development Commands

```bash
# Install dependencies
bundle install

# Start development server
bundle exec middleman server

# Build for production
bundle exec middleman build

# Clean build directory
bundle exec middleman clean
```

## Project Structure

### Core Configuration
- `config.rb`: Main Middleman configuration with blog setups, redirects, and build settings
- `Gemfile`: Ruby dependencies including Middleman, autoprefixer, and blog extension

### Content Organization
- `source/`: All site content and assets
- `source/layouts/`: Template layouts (layout.erb, newsletter.erb, essays.erb, notes.erb, wmw.erb)
- `source/stylesheets/`: SCSS stylesheets with partials in `partials/` subdirectory
- `source/images/`: All image assets organized by content type
- `data/`: YAML data files (books.yml, writing.yml) for structured content

### Blog Content Structure
Each blog has its own template.yml file defining frontmatter structure:
- Articles use frontmatter with title, date, tags, description, image, and published status
- Newsletter content has specialized metadata for SEO and social sharing

### Layouts and Partials
- `layout.erb`: Main site layout with header, navigation, and footer
- Specialized layouts: `newsletter.erb`, `essays.erb`, `notes.erb`, `wmw.erb`
- Partials: `_footer.erb`, `_testimonials.erb`, `_lac_form.erb`, etc.

## Content Management

### Creating New Content
Use Middleman's blog helpers or manually create files following the established patterns:
- Blog posts use `.html.md` extension
- Frontmatter follows template.yml structure in each blog directory
- Images should be placed in appropriate subdirectories under `source/images/`

### Blog Configuration Details
- **Directory indexes** activated for clean URLs
- **Redirects** configured for moved content in config.rb
- **Build optimization** includes CSS/JS minification
- **RSS feeds** available for each blog

### Asset Management
- Custom fonts loaded from Typography.com
- Images organized by content type (books/, essays/, og/, etc.)
- SCSS with modular partial structure

## Development Notes

- Site uses ERB templating with Ruby helpers
- No JavaScript framework - minimal custom JS in `mm.js`
- Responsive design with SCSS breakpoint mixins
- SEO optimized with OpenGraph and Twitter Card meta tags
- RSS feeds generated for each blog
- No tracking or analytics implemented (privacy-focused)