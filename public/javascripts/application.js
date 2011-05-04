// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {

  $( "button, input:submit, a").button();
  $( "a", ".demo" ).click(function() { return false; });
});