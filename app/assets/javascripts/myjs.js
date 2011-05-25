// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
//  $( "button, input:submit, a.snazzy" ).button();
  $( "a", ".demo" ).click(function() { return false; });

  $( ".collapsed-trigger" ).bind("click", function(event){
    event.preventDefault();
    $(this).parent().siblings(".collapsed-content").toggleClass("hidden");
  });

  $("#.sorting_options a, #results .pagination a").live("click", function(event) {
    event.preventDefault();
    $.getScript(this.href);
  });

  $("a.gallery").fancybox({
    cyclic: true
  });

  $(function() {
    var term = $( "#search_term" );

    $( "div#term-slider" ).slider({
      range: "min",
      min: 5,
      max: 50,
      value: term.val(),
      slide: function( event, ui ) {
        term.val( ui.value );
      }
    });
  });

  $(function() {
    var deposit = $( "#search_deposit" );

    $( "div#deposit-slider" ).slider({
      range: "min",
      min: 1000,
      max: 100000,
      step: 1000,
      value: deposit.val(),
      slide: function( event, ui ) {
        deposit.val( ui.value );
      }
    });
  });

  $(function(){
    var min_payment = $("#search_min_payment");
    var max_payment = $("#search_max_payment");
    $('div#jquery-slider').slider({
      range: true,
      min: 50,
      max: 2000,
      step: 10,
      values: [ min_payment.val() , max_payment.val() ],
      slide: function( event, ui ) {
        min_payment.val( ui.values[ 0 ] );
        max_payment.val( ui.values[ 1 ] );
      }
    });
  });
});