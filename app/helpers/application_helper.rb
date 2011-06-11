module ApplicationHelper
#  Return a title on a per page basis
  def title
    base_title = "How Much House"
    @title ? "#{@title} | #{base_title}" : base_title
  end

  def select_options constant_array
    constant_array.collect {|name| [name, name] }
  end

  def checkbox(type, field_number, checked)
    check_box_tag "search[#{type}][]", "#{field_number}", checked, id: "search_#{type}_#{field_number}", class: "filter_button"
  end

  def checkbox_label(type, id, text = nil)
    label_tag "search_#{type}_#{id}", (text || id.to_s)
  end

  def radio(type, id, checked)
    radio_button_tag("search[#{type}]", id, checked)
  end

  def sortable(column, title = nil, classes = '', remote = false)
    title ||= column.titleize
#    I've no idea whats going on in this logic
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
#    if column is the current "one" set css_class to "current direction" otherwise set it to nil
    css_class = column == sort_column ? "current #{sort_direction}" : nil
#    I assume that since this doesn't have a path it just refreshes the page
#    we have to put the brackets in here otherwise this will all be treated as one hash
    link_to title, { sort: column, direction: direction }, { class: "#{css_class} #{classes}", :'data-remote' => remote }
  end
end
