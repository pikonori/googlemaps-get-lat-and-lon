$.googleMaps = ()->
    @OPTION =
        ad: ''
        ido: ''
        keido: ''
        collback: ()-> false
    @APIOPTION =
        zoom: 15
        mapTypeId: google.maps.MapTypeId.ROADMAP
        scaleControl: true
        mapTypeControl: false
        scrollwheel: false
    @

$.googleMaps.prototype =
    # To override the default options.
    _extends:(option)->
        @OPTION = $.extend @OPTION, option

    # To draw a googlemap
    _mapCreate:(domObj)->
        self = @
        $.when(@_mapLatLngObject(@OPTION.ido, @OPTION.keido)).always (ido, keido)->
            self.APIOPTION.center = new google.maps.LatLng(ido, keido)
            self.OPTION.collback ido, keido
            #create googlemap
            map = new google.maps.Map domObj.get(0), self.APIOPTION
            self._markerCreate self.APIOPTION.center, map
            @
        @
    # Create a marker & Add event marker
    _markerCreate:(latlng, mapObj)->
        markerOption =
            'position': latlng
            'map': mapObj
            'draggable': true

        marker = new google.maps.Marker markerOption
        self = @

        google.maps.event.addListener marker, 'dragend', ()->
            position = marker.position
            mapObj.setCenter position
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

$.fn.googleMaps = (option)->
    #instance
    instance = new $.googleMaps()
    instance._extends option
    instance._mapCreate @
