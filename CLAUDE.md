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

## HTML Guidelines

- **Semantic markup**: Use the right element for the job — `<article>`, `<section>`, `<nav>`, `<aside>`, `<header>`, `<footer>`, `<main>`, `<figure>`, `<time>`, etc. Don't reach for `<div>` when a semantic element fits.
- **No superfluous nesting**: Don't add wrapper `<div>`s or extra container elements unless they serve a clear layout purpose. Keep the DOM shallow.
- **Navigation uses `<ul>`**: All nav patterns use `<ul>/<li>` — never bare `<a>` tags, `<span>`s, or other ad-hoc markup for navigation.
- **Layout structure**: The canonical two-column layout is `<section class="content">` with `<div class="col-1">` and `<div class="col-2">`. Use this before reaching for any new grid pattern.
- **Element roles**:
  - `<section>` for major content areas (`.hero`, `.content`, `.essay`)
  - `<div>` for non-semantic containers (`.inner`, `.col-1`, `.col-2`, `.text`)
  - `<article>` for editorial/blog content (used in essays and newsletter layouts)
  - `<main>` wraps the page body at the layout level — don't nest `<main>` inside content sections
- **`.inner`** is the established centering/padding wrapper used inside `header` and `footer`. Reuse it — don't invent `.wrapper`, `.container`, or similar.
- **No inline styles**: The essays masthead uses inline styles because the color comes from frontmatter data. Everywhere else, styles belong in `mm.css.scss`.

## CSS Guidelines

- **Reuse before adding**: Before writing new styles, check `mm.css.scss` and the partials for existing classes, variables, and mixins that already do the job. Prefer extending or composing existing styles.
- **Page context scoping**: Use Middleman's `<%= page_classes %>` body classes (e.g., `.writing .hero`) to scope page-specific overrides rather than adding new one-off classes.
- **No utility classes**: This codebase uses semantic, purpose-driven class names — not utility classes like `.mt-2` or `.flex`. Follow that convention.
- **IDs are for forms only**: Never use IDs as CSS selectors. IDs are reserved for form inputs and JavaScript targets.
- **Avoid redundant CSS**: Don't duplicate rules that already exist. If something looks similar to an existing pattern, reuse or extend it.

### Always use SCSS variables — never hardcode values

- **Colors**: Use `$dark-gray`, `$pink`, `$white`, `$medium-gray`, `$light-gray`, `$lightest-gray`, `$warm-highlight`, `$cool-highlight`, `$yellow` from `_variables.scss`. Don't introduce bare hex values for colors that already have variables.
- **Font sizes**: Use `$font-size-x-x-large` through `$font-size-x-small` from `_fonts.scss`. Don't hardcode `rem` values that match an existing variable.
- **Font families**: Use `$font-heading` (Ideal Sans), `$font-heading-serif` (Chronicle), or the Romie face names (`RomieRegular`, `RomieItalic`, `RomieMedium`). Never hardcode font names.
- **Spacing and transitions**: Use `$main-padding` (3rem) and `$transition` (all .15s ease) where applicable.

### Responsive rules

- **Mobile-first**: Write base styles for mobile, then override inside `@include breakpoint(large)` for desktop. The `large` breakpoint (55rem) is where the main layout shifts happen.
- **`medium`** (30rem) is for subtle tweaks only. **`xlarge`** (75rem) is rarely needed.
- Use the `@include breakpoint()` mixin — don't write raw `@media` queries.

### Existing components — reuse, don't recreate

- `.btn` — the styled CTA button (pink, pill shape). Use it for calls to action.
- `.mini` — the pattern for secondary sections like newsletter signups and small CTAs.
- `.section-label` — uppercase category/section labels.
- `.mini-bio` — author bio block with floated image.
- `.newsletter-lockup` and `.nav-lockup` — grouped headline + supporting copy blocks.
- `.collection` + `<ul>/<li>` — the footer link group pattern. Already fully styled.

## Code Change Guidelines

- **Always comment changes with attribution and date**: When making changes to CSS, HTML, or JavaScript files, include a comment indicating:
  - The change was made by Claude Code
  - The date of the change
  - Examples:
    - CSS: `/* Updated by Claude Code - 2025-08-16 */`
    - HTML: `<!-- Updated by Claude Code - 2025-08-16 -->`
    - JavaScript: `// Updated by Claude Code - 2025-08-16`