module ApplicationHelper
  require 'redcarpet'

  def title(title_str)
    content_for :title do
      title_str
    end
  end

  def active_link_to(title, url)
    if url == '/'
      css = "active" if request.path == '/'
    elsif request.path.start_with? url
      css = "active"
    end
    link_to title, url, class: css
  end

  def markdown(text)
    if text == nil
      return ""
    end
    options = {
      autolink: true,
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      strikethrough: true,
      tables: true,
      strikethrough: true,
      lax_spacing: true
    }
    renderer = Redcarpet::Render::HTML.new(:with_toc_data => true, :hard_wrap => true)
    mdown = Redcarpet::Markdown.new(renderer, options)
    mdown.render(text).html_safe
  end
end
