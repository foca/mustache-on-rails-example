require "mustache"

class Mustache::Rails < Mustache
  attr_accessor :view

  def method_missing(method, *args, &block)
    view.send(method, *args, &block)
  end

  def respond_to?(method, include_private=false)
    super(method, include_private) || view.respond_to?(method, include_private)
  end
end

class Mustache::Rails::TemplateHandler < ActionView::TemplateHandler
  def render(template, local_assigns, &block)
    mustache = template.path.gsub(".html.mustache", "").classify.constantize
    mustache.template_file = Rails.root.join("app", "templates", template.path)

    returning mustache.new do |result|
      copy_instance_variables_to(result)
      result.view    = @view
      result[:yield] = @view.instance_variable_get(:@content_for_layout)
    end.to_html
  end

  def copy_instance_variables_to(mustache)
    variables  = @view.controller.instance_variable_names
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
