$ () ->
  $( ".buttonset" ).buttonset()
  $( "a", ".demo" ).click (event) ->
    event.preventDefault()

  $( "a.gallery" ).fancybox
    cyclic: true

  $( '.collpsed_trigger' ).click (event) ->
    event.preventDefault()
    $( this ).next( '.collepsed_content' ).toggleClass 'hidden'

  $( '#.sorting_options a, #results .pagination a' ).live 'click', (event) ->
    event.preventDefault()
    $.getScript this.href

  $( "#new_search" )
    .bind 'ajax:beforeSend', (event, xhr, settings) ->
      settings.data += ( "&" + $( "#filter_options, #search_town_form input[type='hidden']" ).serialize() )
#      this will be replaced by the results when the response returns
#      actually this is a bad idea, what if the response never comes??
      $( '#resultsContainer' ).html('locading')

  $( 'div#towns_list' )
    .find( 'a.delete_town' ).live 'click', (e) ->
      e.preventDefault()
      $( this ).parent( 'li' ).remove()
    .end()
    .find( 'a#delete_all' ).live 'click', (e) ->
      e.preventDefault()
      $( this ).next( 'ul' ).children( 'li' ).remove()

#  Advanced search option dialog
  $( 'div#advanced_search_dialog' ).dialog
    autoOpen: false,
    modal: true,
    width: 430,
    height: 500,
    resizable: false,
    draggable: false,
    hide: 'fade',
    show: 'fade',
    title: "Advanced Search Options",
    buttons:
      "Ok": () ->
        $.rails.handleRemote( $( "#new_search" ) )
        $( this ).dialog 'close'
      "Cancel": () ->
#        need to reset any superficial changes on the advanced form
        $( "#filter_options" )[0].reset()
        $( this ).dialog 'close'
        
  $( "div#advanced_search_fields" ).tabs()

  $( "a#advanced_search_trigger" ).click (e) ->
    e.preventDefault()
    $( "div#advanced_search_dialog" ).dialog 'open'

  min_payment = $( "input#search_min_payment" )
  max_payment = $( "input#search_max_payment" )
  $minTooltip = $("<span class=\"ui-slider-tooltip ui-widget-content ui-corner-all\">
                    <span class=\"ttContent\">€#{ min_payment.val() }</span>
                    <span class=\"ui-tooltip-pointer-down ui-widget-content\">
                    <span class=\"ui-tooltip-pointer-down-inner\"></span></span>
                    </span>")
  $maxTooltip = $("<span class=\"ui-slider-tooltip ui-widget-content ui-corner-all\">
                    <span class=\"ttContent\">€#{ max_payment.val() }</span>
                    <span class=\"ui-tooltip-pointer-down ui-widget-content\">
                    <span class=\"ui-tooltip-pointer-down-inner\"></span></span>
                    </span>")
  $paymentSlider = $( 'div#payment_slider' )

  $paymentSlider.slider
    range: true,
    min: 200,
    max: 2000,
    step: 10,
    values: [ min_payment.val() , max_payment.val() ],
    slide: ( event, ui ) ->
      min_payment.val( ui.values[ 0 ] )
      max_payment.val( ui.values[ 1 ] )
      $minTooltip.find( "span.ttContent" ).text( "€#{ui.values[0]}" )
      $maxTooltip.find( "span.ttContent" ).text( "€#{ui.values[1]}" )

  $paymentSlider.find( ".ui-slider-handle" ).eq(0).append $minTooltip
  $paymentSlider.find( ".ui-slider-handle" ).eq(1).append $maxTooltip