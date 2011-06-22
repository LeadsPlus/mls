$ () ->
  $( ".buttonset" ).buttonset()
  $( "a", ".demo" ).click (event) ->
    event.preventDefault()

  $( "a.gallery" ).fancybox
    cyclic: true

  $( '.collapsed_trigger' ).live 'click', (event) ->
    event.preventDefault()
    $( this ).parent().next( '.collapsed_content' ).toggleClass 'hidden'

  $("#search_bar, #mort_search_options, #loc_search_options").hide()
  $mort_opts = $('#mort_search_options')
  $search_bar = $('#search_bar')
  $loc_opts = $('#loc_search_options')
  $search_bar.find('#close_search_bar').bind 'click', (event) ->
    event.preventDefault()
    $search_bar.slideUp 'fast', () ->
      $mort_opts.hide()
      $loc_opts.hide()
#      TODO reset the forms

#  TODO refactor this into a function
  $('button#mort_ctrl').bind 'click', (event) ->
    if $loc_opts.is ':visible'
      $search_bar.slideUp 'fast', () ->
        $loc_opts.hide()
        $mort_opts.show '0', () ->
          $search_bar.slideDown 'fast'
    else if $mort_opts.is ':visible'
      $search_bar.slideUp 'fast', () ->
        $mort_opts.hide()
    else
      $mort_opts.show()
      $search_bar.slideToggle 'fast'

  $('button#loc_ctrl').bind 'click', (event) ->
    if $mort_opts.is ':visible'
      $search_bar.slideUp 'fast', () ->
        $mort_opts.hide()
        $loc_opts.show '0', () ->
          $search_bar.slideDown 'fast'
    else if $loc_opts.is ':visible'
      $search_bar.slideUp 'fast', () ->
        $loc_opts.hide()
    else
      $loc_opts.show()
      $search_bar.slideToggle 'fast'

#  controls for  the towns list
# TODO the traversal needs to be fixed to make this work
  $( 'div#towns_list' )
    .find( 'a.delete_town' ).live 'click', (e) ->
      e.preventDefault()
      $( this ).parent( 'li' ).remove()
    .end()
    .find( 'a#delete_all' ).live 'click', (e) ->
      e.preventDefault()
      $( this ).next( 'ul' ).children( 'li' ).remove()

#  event handlers for the search form
  $( "#new_search" )
    .bind 'ajax:before', (event) ->
      $( this ).find( 'div#error_target' ).html( '' )
    .bind 'ajax:beforeSend', (event, xhr, settings) ->
      settings.data += "&#{ $( "#filter_options, #search_town_form input[type='hidden']" ).serialize() }"
#     this will be replaced by the results when the response returns
#     actually this is a bad idea, what if the response never comes??
      $( this ).find( 'span.loading' ).append '<img src="assets/loading.gif" />'
    .bind 'ajax:complete', (event, xhr, status) ->
      $( this ).find( 'span.loading' ).text ''
    .bind 'ajax:success', (event, data, status) ->
#      TODO fix the url and back button
#      $.address.value 'hello'

#  handling for the search form on the 'start' (intended homepage) page
#  TODO none of this works yet
  $('form#start_new_search')
    .bind 'ajax:beforeSend', (event, xhr, settings) ->
      settings.data += "&#{ $("#new_search, #search_town_form input[type='hidden'], #filter_options").serialize() }"
    .bind 'ajax:complete', (event, xhr, status) ->
      log xhr
#      document.location.href = 'hello'

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