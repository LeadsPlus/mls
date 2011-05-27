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

  $(".multiselect").multiselect({
    selectedText: function(numChecked, numTotal, checkedItems){
      if(numChecked === numTotal) {
        return "All selected";
      }
      else {
        return numChecked + ' selected';
      }
    }
  });

  $("#search_term").buttonset();
//  $(function() {
//    var term = $( "#search_term" );
//    var $tooltip = $('<span class="ui-slider-tooltip ui-widget-content ui-corner-all">'
//                      + '<span class="ttContent">' + term.val() + ' years</span>'
//                      + '<span class="ui-tooltip-pointer-down ui-widget-content">'
//                      + '<span class="ui-tooltip-pointer-down-inner"></span></span>'
//                      + '</span>');
//
//    $( "div#term_slider" ).slider({
//      range: "min",
//      min: 5,
//      max: 50,
//      value: term.val(),
//      slide: function( event, ui ) {
//        term.val( ui.value );
//        $tooltip.find( "span.ttContent" ).text( ui.value + ' years' );
//      }
//    }).find(  ".ui-slider-handle" ).append($tooltip);
//  });

  $(function() {
    var deposit = $( "#search_deposit" );
    var $tooltip = $('<span class="ui-slider-tooltip ui-widget-content ui-corner-all">'
                      + '<span class="ttContent"> €' + deposit.val() + '</span>'
                      + '<span class="ui-tooltip-pointer-down ui-widget-content">'
                      + '<span class="ui-tooltip-pointer-down-inner"></span></span>'
                      + '</span>');

    $( "div#deposit_slider" ).slider({
      range: "min",
      min: 1000,
      max: 100000,
      step: 1000,
      value: deposit.val(),
      slide: function( event, ui ) {
        $tooltip.find( "span.ttContent" ).text( "€" + ui.value );
        deposit.val( ui.value );
      }
    }).find(  ".ui-slider-handle" ).append($tooltip);
  });

  $(function(){
    var min_payment = $( "input#search_min_payment" );
    var max_payment = $( "input#search_max_payment" );
    var $minTooltip = $('<span class="ui-slider-tooltip ui-widget-content ui-corner-all">'
                      + '<span class="ttContent">€' + min_payment.val() + '</span>'
                      + '<span class="ui-tooltip-pointer-down ui-widget-content">'
                      + '<span class="ui-tooltip-pointer-down-inner"></span></span>'
                      + '</span>');
    var $maxTooltip = $('<span class="ui-slider-tooltip ui-widget-content ui-corner-all">'
                      + '<span class="ttContent">€' + max_payment.val() + '</span>'
                      + '<span class="ui-tooltip-pointer-down ui-widget-content">'
                      + '<span class="ui-tooltip-pointer-down-inner"></span></span>'
                      + '</span>');
    var $paymentSlider = $('div#payment_slider');

    $paymentSlider.slider({
      range: true,
      min: 400,
      max: 3000,
      step: 50,
      values: [ min_payment.val() , max_payment.val() ],
      slide: function( event, ui ) {
        min_payment.val( ui.values[ 0 ] );
        max_payment.val( ui.values[ 1 ] );
        $minTooltip.find( "span.ttContent" ).text( "€" + ui.values[0] );
        $maxTooltip.find( "span.ttContent" ).text( "€" + ui.values[1] );
      }
    });
    $paymentSlider.find( ".ui-slider-handle" ).eq(0).append($minTooltip);
    $paymentSlider.find( ".ui-slider-handle" ).eq(1).append($maxTooltip);

  });
});