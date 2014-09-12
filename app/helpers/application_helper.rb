module ApplicationHelper

  def checkbox_group(options)
    # options hash must include :collection, :ul_class, and :html_name
    @ul = options
    render "shared/checkbox_group"
  end

  def select_given_options(options)
    # options hash must include :label, :collection, :html_name
    @options = options
    render "shared/select_given_options"
  end

  def select_numerical_given_options(options)
    # options hash must include :label, :html_name, :limits
    @options = options
    render "shared/select_numerical"
  end

  def resource_name
   :user
  end

  def resource
     @resource ||= User.new
  end

  def devise_mapping
     @devise_mapping ||= Devise.mappings[:user]
  end

end