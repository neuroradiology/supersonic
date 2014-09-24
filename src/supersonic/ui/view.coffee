Promise = require 'bluebird'


module.exports = (steroids, log) ->
  # TODO: add bug later
  # bug = log.debuggable "supersonic.ui.view"

  class View

    ###*
     * @ngdoc method
     * @name view
     * @module ui
     * @description
     * Creates a new view
     * @param {string} URL of a view
     * @returns View object
     * @usage
     * ```coffeescript
     * supersonic.ui.view("http://www.google.com")
     * ```
    ###
    constructor: (location, id) ->
      # if this !instanceof View
      #   return new View(location, id)

      @location = location
      @id = id || location

      supersonic.logger.info "'#{@location}' view was created with '#{@id}' id"

      @_view = new steroids.views.WebView {
        location: @location,
        id: @id
      }

    # TODO: Maybe preloads whould happen in contructor by default?

    ###*
     * @ngdoc method
     * @name preload
     * @module view
     * @description
     * Preloads a new
     * @param {string} URL of a view
     * @returns View object
     * @usage
     * ```coffeescript
     * supersonic.ui.view("http://www.google.com").preload
     *
     * v = supersonic.ui.view("http://www.google.com")
     * v.preload()
     * ```
    ###
    preload: () ->
      new Promise (resolve) ->
        @_view.preload( {
          id: @id
        }, {

          onSuccess: ()->
            supersonic.logger.info "'#{@id}' view was preloaded"
            resolve()

          onFailure: ()->
            supersonic.logger.error "Preloading of '#{@id}' was failed"
        })

  return (location, id)->
    return new View(location, id)
