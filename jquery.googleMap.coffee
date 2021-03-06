$.googleMaps = ()->
  @OPTION =
    ad: ''
    ido: ''
    keido: ''
    markerDrag: true
    markerReturn: ''
    collback: ()-> false
  @APIOPTION =
    zoom: 15
    mapTypeId: google.maps.MapTypeId.ROADMAP
    scaleControl: true
    mapTypeControl: false
    scrollwheel: false
  @GLOBAL =
    map: ""
    marker: ""
  @

$.googleMaps.prototype =
  # To override the default options.
  _extends:(option, apiOption)->
    @OPTION = $.extend @OPTION, option
    @APIOPTION = $.extend @APIOPTION, apiOption

  # To draw a googlemap
  _mapCreate:(domObj)->
    self = @
    $.when(@_mapLatLngObject(@OPTION.ido, @OPTION.keido)).always (ido, keido)->
      self.APIOPTION.center = new google.maps.LatLng(ido, keido)
      self.OPTION.collback ido, keido
      #create googlemap
      self.GLOBAL.map = new google.maps.Map domObj.get(0), self.APIOPTION
      self._markerCreate self.APIOPTION.center
      self._markerReturn()
      @
    @

  # Create a marker & Add event marker
  _markerCreate:(latlng)->
    markerOption =
      'position': latlng
      'map': @GLOBAL.map
      'draggable': @OPTION.markerDrag

    @GLOBAL.marker = new google.maps.Marker markerOption
    self = @

    google.maps.event.addListener @GLOBAL.marker, 'dragend', ()->
      position = self.GLOBAL.marker.position
      self.GLOBAL.map.setCenter position
      self.OPTION.collback position.lat(), position.lng()

  # Object returned by the latitude and longitude.
  _mapLatLngObject:(ido, keido)->
    $def = $.Deferred()
    self = @
    if(ido == '' || keido == '')
      geocoder = new google.maps.Geocoder()
      geocoder.geocode({address: self.OPTION.ad}, (results, status)->
        if (status == google.maps.GeocoderStatus.OK)
          $def.resolve(results[0].geometry.location.lat(), results[0].geometry.location.lng())
        else
          #To Tokyo
          $def.reject(35.6894875, 139.69170639999993)
      )
    else
      $def.resolve(ido, keido)
    $def.promise()

  _markerReturn:()->
    self = @
    if(@OPTION.markerReturn != "")
      $(@OPTION.markerReturn).click(()->
        position = self.GLOBAL.marker.position
        self.GLOBAL.map.setCenter position
      )

$.fn.googleMaps = (option, apiOption)->
  if($(@).size() > 0)
    #instance
    instance = new $.googleMaps()
    instance._extends option, apiOption
    instance._mapCreate @
