class Layouts::Application < Mustache::Rails
  def stylesheets
    stylesheet_link_tag 'scaffold'
  end

  def link_to_root
    link_to "The Awesome Blog", root_path
  end

  def flash_messages
    content_tag(:p, flash[:notice], :class => "flash notice")
  end
end
