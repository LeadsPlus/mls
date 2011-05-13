// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
  $( "button, input:submit, a.snazzy" ).button();
  $( "a", ".demo" ).click(function() { return false; });

  $( ".collapsed-trigger" ).bind("click", function(event){
    event.preventDefault();
    $(this).parent().siblings(".collapsed-content").toggleClass("hidden");
  });

  $(function() {
    var term = $( "#search_term" );
//    var $termSlideTip = $("<div/>").attr("id", "term-slide-tip").addClass("slider-tooltip")
//        .text( term.val() + " years" );

    $( "div#term-slider" ).slider({
      range: "min",
      min: 5,
      max: 50,
      value: term.val(),
//      create: function(event, ui) {
//        $( this ).find(".ui-slider-handle").append( $termSlideTip );
//      },
      slide: function( event, ui ) {
//        $termSlideTip.text( ui.value + " years" );
        term.val( ui.value );
      }
    });
  });

  $(function() {
    var deposit = $( "#search_deposit" );
//    var $deposSlideTip = $("<div/>").attr("id", "depos-slide-tip").addClass("slider-tooltip")
//        .text( "€" + deposit.val() );

    $( "div#deposit-slider" ).slider({
      range: "min",
      min: 1000,
      max: 100000,
      step: 1000,
      value: deposit.val(),
//      create: function(event, ui) {
//        $( this ).find(".ui-slider-handle").append( $deposSlideTip );
//      },
      slide: function( event, ui ) {
//        $deposSlideTip.text( "€" + ui.value );
        deposit.val( ui.value );
      }
    });
  });

  $(function(){
    var min_payment = $("#search_min_payment");
    var max_payment = $("#search_max_payment");

//    var $slideTip1 = $("<div/>").attr("id", "slide-tip-1").addClass("slider-tooltip")
//        .text( "€" + min_payment.val() );
//    var $slideTip2 = $("<div/>").attr("id", "slide-tip-2").addClass("slider-tooltip")
//        .text( "€" + max_payment.val() );

    $('div#jquery-slider').slider({
      range: true,
      min: 50,
      max: 2000,
      step: 10,
      values: [ min_payment.val() , max_payment.val() ],
//      create: function() {
//        var handles = $( this ).find(".ui-slider-handle");
//        handles.eq(0).append($slideTip1);
//        handles.eq(1).append($slideTip2);
//      },
      slide: function( event, ui ) {
//        $slideTip1.text( "€" + ui.values[ 0 ] );
//        $slideTip2.text( "€" + ui.values[ 1 ] );
        min_payment.val( ui.values[ 0 ] );
        max_payment.val( ui.values[ 1 ] );
      }
    });
  });
});