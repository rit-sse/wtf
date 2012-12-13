module PagesHelper
  def render_section(section)
    render partial: "pages/section", locals: {section: section}
  end

  def render_block(block)
    render partial: "blocks/block", locals: {block: block}
  end

  def available_block_types
  	[Markdown]
  end
end
