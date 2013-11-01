module PagesHelper
  def render_section(section)
    render partial: "pages/section", locals: {section: section}
  end

  def render_block(block)
    render partial: "blocks/block", locals: {block: block}
  end

  def available_block_types
  	[Markdown, NavigationTree, Youtube]
  end

  def available_layout_types
  	[SingleColumn, TwoColumn]
  end

  def get_pages_tree(parent_id=nil, level=0)
    pages_tree = []

    pages = (parent_id.nil? ? Page.roots : Page.children_of(parent_id)).order("title")

    pages.each do |page|
      spacer = (("-" * level) + " " || "")
      pages_tree << [spacer + page.title, page.id]
      pages_tree += get_pages_tree(page.id, level+1)
    end

    pages_tree
  end

  def navigation_tree(node)
    fuc = lambda do |nodes|
      return "" if nodes.empty?
      return "<ul>" +
        nodes.inject("") do |string, (node, children)|
          string + "<li rel='#{node.id}'>" +
          node.title +
          fuc.call(children) +
          "</li>"
        end +
        "</ul>"
    end
    fuc.call(node.descendants.arrange).html_safe
  end
end
