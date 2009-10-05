require "mustache"

ActiveSupport::Dependencies.load_paths << Rails.root.join("app", "views")

class Mustache::Rails < Mustache
  include ActionController::UrlWriter
  include ActionView::Helpers

  attr_accessor :request, :response, :params, :controller, :view, :flash

  # ActionView::Helpers overrides the +render+ method, so we need to copy it
  # back from Mustache. Ugly.
  def render(html, context = {})
    @context = context = (@context || {}).merge(context)
    html = render_sections(html)
    @context = context
    render_tags(html)
  end

  # Use rails' html_escape ("h") for escaping.
  alias_method :escape, :html_escape
end

class Mustache::Rails::TemplateHandler < ActionView::TemplateHandler
  def render(template, local_assigns, &block)
    mustache_class_name = template.path.gsub(".html.mustache", "").classify
    mustache_class = mustache_class_name.constantize

    result = mustache_class.new
    copy_instance_variables_to(result)
    result.template_file = Rails.root.join("app", "views", template.path)
    result.view          = @view
    result.controller    = result.view.controller
    result.request       = result.controller.request
    result.response      = result.controller.response
    result.params        = result.controller.params
    result.flash         = result.controller.send(:flash)
    result[:yield]       = block && block.call
    result.to_html
  end

  def copy_instance_variables_to(mustache)
    variables = @view.controller.instance_variable_names
    variables -= %w(@template)
    variables -= @view.controller.protected_instance_variables if @view.controller.respond_to?(:protected_instance_variables)
    variables.each {|name| mustache.instance_variable_set(name, @view.controller.instance_variable_get(name)) }
  end
end

ActionView::Template.register_template_handler(:mustache, Mustache::Rails::TemplateHandler)
