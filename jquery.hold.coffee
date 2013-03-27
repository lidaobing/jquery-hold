class Holder
  constructor: (@$) ->
    @queue = []
    @_refreshDefer()
    @defer.resolve()

  hold: (time)->
    @queue.push ['hold', time]
    @_trigger()
    @

  fire: (callback)->
    @queue.push ['fire', callback]
    @_trigger()
    @

  _refreshDefer: ->
    that = this
    @defer = @$.Deferred()
    @defer.done ->
      that._processQueue()

  _trigger: ->
    that = this
    setTimeout ->
      that._processQueue()
    , 1

  _processQueue: ->
    that = this
    return if @queue.length == 0
    return if @defer.state() == 'pending'
    item = @queue.shift()
    if item[0] == 'hold'
      @_refreshDefer()
      setTimeout ->
        that.defer.resolve()
      , item[1] * 1000
    else
      that._trigger()
      item[1]()


$.hold = (time)->
  if time
    new Holder($).hold(time)
  else
    new Holder($)
