resource = require 'steroids-data/lib/steroids/data/resource'

module.exports = {
  ###
   # @category core
   # @module data
   # @name resource
   # @function
   # @description
   # Allows access to cloud resources you have configured for your app through Steroids Connect.
   # @param {string} resourceName
   # @returns {Resource}
   # @usage
   # ```coffeescript
   # supersonic.data.resource("task").findAll().then (tasks) ->
   #   console.log "Got tasks!"
   # ```
  ###
  resource
}