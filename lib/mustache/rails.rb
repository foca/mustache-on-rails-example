require "mustache"

class Mustache::Rails < Mustache
  attr_accessor :view

  def partial(name)
    name.strip!
  end

  # Delegate anything we don't understand back to the ActionView::Base instance
  def method_missing(method, *args, &block)
    view.send(method, *args, &block)
  end
end

class Mustache::Rails::TemplateHandler < ActionView::TemplateHandler
  def render(template, local_assigns, &block)
    mustache_class_name = template.path.gsub(".html.mustache", "").classify
    mustache_class = mustache_class_name.constantize

    result = mustache_class.new
    copy_instance_variables_to(result)
    result.template_file = Rails.root.join("app", "templates", template.path)
    result.view          = @view
    result[:yield]       = @view.instance_variable_get(:@content_for_layout)
    result.to_html
  end

  def copy_instance_variables_to(mustache)
    variables = @view.controller.instance_variable_names
    variables -= %w(@template)
    if @view.controller.respond_to?(:protected_instance_variables)
      variables -= @view.controller.protected_instance_variables
    end
    variables.each do |name|
      mustache.instance_variable_set(name, @view.controller.instance_variable_get(name))
    end
  end
end

ActionView::Template.register_template_handler(:mustache, Mustache::Rails::TemplateHandler)
