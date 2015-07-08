app.controller 'MainCtrl',
    class MainCtrl
        actual: 0.6
        expected: 0.5

        random: ->
            @actual = Math.random()
            @expected = Math.random()

