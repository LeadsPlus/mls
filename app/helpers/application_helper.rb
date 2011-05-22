module ApplicationHelper
#  Return a title on a per page basis
  def title
    base_title = "How Much House"
    @title ? "#{@title} | #{base_title}" : base_title
  end

  def county_choices
    COUNTIES.collect {|name| [name, name] }
  end

  def lender_options
    LENDERS.collect {|name| [name, name] }.unshift ["Any", "Any"]
  end

  def loan_type_options
    LOAN_TYPES.collect {|name| [name, name] }.unshift ["Any", "Any"]
  end

  def initial_period_length_options
    LOAN_PERIODS.collect {|period| ["#{period} years", period]}.unshift ["", nil]
  end

  def sortable(column, title = nil)
    title ||= column.titleize
#    I've no idea whats going on in this logic
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
#    if column is the current "one" set css_class to "current direction" otherwise set it to nil
    css_class = column == sort_column ? "current #{sort_direction}" : nil
#    I assume that since this doesn't have a path it just refreshes the page
#    we have to put the brackets in here otherwise this will all be treated as one hash
    link_to title, { sort: column, direction: direction }, { class: css_class }
  end
end
