app.controller 'MainCtrl',
    class MainCtrl
        actual: 0.5
        expected: 0.5

        # Random set
        numbers: [
            actual: 0.2
            expected: 0.3
          ,
            actual: 0.4
            expected: 0.6
          ,
            actual: 0.6
            expected: 0.9
        ]

        random: ->
          # clear numbers
          for number in @numbers
            number.actual = Math.random()
            number.expected = Math.random()

