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
    mustache = _mustache_class_from_template(template)
    mustache.template_file = template.filename

    returning mustache.new do |result|
      _copy_instance_variables_to(result)
      result.view    = @view
      result[:yield] = @view.instance_variable_get(:@content_for_layout)
      result.context.update(local_assigns)
    end.to_html
  end

  def _copy_instance_variables_to(mustache)
    variables  = @view.controller.instance_variable_names
    variables -= %w(@template)

    if @view.controller.respond_to?(:protected_instance_variables)
      variables -= @view.controller.protected_instance_variables
    end

    variables.each do |name|
      mustache.instance_variable_set(name, @view.controller.instance_variable_get(name))
    end
  end

  def _mustache_class_from_template(template)
    const_name = [template.base_path, template.name].compact.join("/").classify
    defined?(const_name) ? const_name.constantize : Mustache
  end
end

ActiveSupport::Dependencies.load_paths << Rails.root.join("app", "views").to_s
ActionController::Base.prepend_view_path(Rails.root.join("app", "templates").to_s)
ActionView::Template.register_template_handler(:mustache, Mustache::Rails::TemplateHandler)
