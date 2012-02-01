module ApplicationHelper
  require 'redcarpet'

  def title(title_str)
    content_for :title do
      title_str
    end
  end

  def markdown(text)
    options = {
      autolink: true,
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      strikethrough: true,
      space_after_headers: true
    }
    renderer_options = {
      # hard_wrap: true,
      with_toc_data: true
    }
    mdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
    mdown.render(text).html_safe
  end
end
