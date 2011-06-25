$ () ->
  $( ".buttonset" ).buttonset()
#  $( "a", ".demo" ).click (event) ->
#    event.preventDefault()
#
  $( "a.gallery" ).fancybox
    cyclic: true

#  $( '.collapsed_trigger' ).live 'click', (event) ->
#    event.preventDefault()
#    $( this ).parent().next( '.collapsed_content' ).toggleClass 'hidden'

  $( '.collapsed_trigger' ).live 'click', (event) ->
    event.preventDefault()
    $( this ).parent().next( '.collapsed_content' ).toggleClass 'hidden'

#  controls for  the towns list
  $( 'div#loc_search_options' )
    .find( 'a.delete_town' ).live 'click', (e) ->
      e.preventDefault()
      $( this ).parent( 'li' ).fadeOut()
    .end()
    .find( 'a#delete_all' ).live 'click', (e) ->
      e.preventDefault()
      $( 'div#loc_search_options' ).find( 'li' ).fadeOut()
      $('#search_town').val('')

  $(".accordion").accordion { collapsible: true, active: false }

  console.log $( ".new_search" )

#  event handlers for the search form
  $( "#search" )
    .bind 'ajax:before', (event) ->
      $( '#search_bar' ).find( 'div#error_target' ).html ''
    .bind 'ajax:beforeSend', (event, xhr, settings) ->
      settings.data += "&#{ $( "#mort_fields, #option_fields, #search_town_form input[type='hidden']" ).serialize() }"
#     this will be replaced by the results when the response returns
#     actually this is a bad idea, what if the response never comes??
      $( this ).find( 'span.loading' ).append '<img src="assets/loading.gif" />'
    .bind 'ajax:complete', (event, xhr, status) ->
      $( this ).find( 'span.loading' ).text ''
    .bind 'ajax:success', (event, data, status) ->
#      TODO fix the url and back button

##  handling for the search form on the 'start' (intended homepage) page
##  TODO none of this works yet
#  $('form#start_new_search')
#    .bind 'ajax:beforeSend', (event, xhr, settings) ->
#      settings.data += "&#{ $("#new_search, #search_town_form input[type='hidden'], #filter_options").serialize() }"
#    .bind 'ajax:complete', (event, xhr, status) ->
#      log xhr
##      document.location.href = 'hello'
#
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
    step: 50,
    values: [ min_payment.val() , max_payment.val() ],
    slide: ( event, ui ) ->
      min_payment.val( ui.values[ 0 ] )
      max_payment.val( ui.values[ 1 ] )
      $minTooltip.find( "span.ttContent" ).text( "€#{ui.values[0]}" )
      $maxTooltip.find( "span.ttContent" ).text( "€#{ui.values[1]}" )

  $paymentSlider.find( ".ui-slider-handle" ).eq(0).append $minTooltip
  $paymentSlider.find( ".ui-slider-handle" ).eq(1).append $maxTooltip
