describe "supersonic.data.channel", ->
  it "is a function", ->
    supersonic.data.channel.should.be.a 'function'

  it "accepts a channel name and returns a channel", ->
    supersonic.data.channel('foo').name.should.equal 'foo'

  describe "subscribe()", ->
    it "is a function", ->
      supersonic.data.channel('foo').subscribe.should.be.a 'function'

    it "should attach a listener to messages from channel.inbound", (done) ->
      channel = supersonic.data.channel 'foo'
      channel.inbound = new Bacon.Bus
      new Promise((resolve) ->
        channel.subscribe resolve
      ).should.eventually.equal('message').and.notify(done)
      channel.inbound.push 'message'

    it "should run listener in a scope with reply()", (done) ->
      channel = supersonic.data.channel 'foo'
      channel.inbound = new Bacon.Bus
      channel.subscribe ->
        done asserting =>
          @reply.should.be.a 'function'
      channel.inbound.push 'message'

    describe "reply()", ->
      it "pipes to publish", (done) ->
        channel = supersonic.data.channel 'foo'
        channel.inbound = new Bacon.Bus
        new Promise((resolve) ->
          channel.publish = resolve
        ).should.eventually.equal('bar').and.notify done
        channel.subscribe ->
          @reply('bar')
        channel.inbound.push 'message'

  describe "publish()", ->
    it "is a function", ->
      supersonic.data.channel('foo').publish.should.be.a 'function'

    describe "intra-view message passing", (done) ->
      it "allows other channel instances with the same name to subscribe to messages", ->
        producer = supersonic.data.channel 'foo'
        consumer = supersonic.data.channel 'foo'

        new Promise((resolve) ->
          consumer.subscribe resolve
        ).should.eventually.equal('message').and.notify done

        producer.publish 'message'

    describe "cross-view message passing", ->
      startedView = null
      channelName = "foo-#{Math.random()}"
      beforeEach ->
        supersonic.ui
          .view("data#channel/pingback?channel=#{channelName}")
          .start()
          .then (view) ->
            startedView = view
      afterEach ->
        startedView.stop()

      it "can publish a message that will be received by another view", (done) ->
        channel = supersonic.data.channel(channelName)
        channel.publish 'bar'
        new Promise((resolve) ->
          channel.inbound.skip(1).onValue resolve
        ).should.eventually.equal('bar').and.notify done
