app.controller 'MainCtrl',
    class MainCtrl
        actual: 0.5
        expected: 0.5

        # Random set
        numbers: [
            actual: 0.2
            expected: 0.2
          ,
            actual: 0.4
            expected: 0.4
          ,
            actual: 0.8
            expected: 0.8
        ]

        random: ->
          # clear numbers
          for number in @numbers
            number.actual = Math.random()
            number.expected = Math.random()

