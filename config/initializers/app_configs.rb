# change the default markup behavior for form fields with errors
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  html_tag # output the html tag without wrapping it in Div tags

#  alternatively we could do something like this
#  "<span class=\"field_with_errors\">#{html_tag}</span>"

#  the instance tag is a representation of the html tag before it is
#  actually converted to html. Contains the model options etc. idk
end