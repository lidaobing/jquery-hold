class Holder
  constructor: (@$) ->
    @defer = @$.Deferred()

  hold: (time)->
    that = this
    setTimeout ->
      that.defer.resolve(that)
    , time*1000
    @

  fire: (callback)->
    @defer.done ->
      callback()
    @


$.hold = ->
  new Holder($)
