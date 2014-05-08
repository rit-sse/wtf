module ApplicationHelper

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
end
