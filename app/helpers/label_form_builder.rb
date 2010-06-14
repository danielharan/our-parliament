#http://onrails.org/articles/2008/06/13/advanced-rails-studio-custom-form-builder
class LabelFormBuilder < ActionView::Helpers::FormBuilder
  helpers = field_helpers +
            %w{date_select datetime_select time_select} +
            %w{collection_select select country_select time_zone_select} -
            %w{hidden_field label fields_for} # Don't decorate these

  helpers.each do |name|
    define_method(name) do |field, *args|
      options = args.extract_options!
      label = label(field, options.delete(:label), :class => options.delete(:label_clas))
      @template.content_tag(:div, label + super)  #wrap with a paragraph 
    end
  end
end