app.controller 'MainCtrl',
    class MainCtrl
        actual: 0.5
        expected: 0.5

        # Random set
        numbers: [
            actual: 0.6
            expected: 0.5
          ,
            actual: 0.75
            expected: 0.46
          ,
            actual: 0.932
            expected: 0.675
        ]

        random: ->
          # clear numbers
          for number in @numbers
            number.actual = Math.random()
            number.expected = Math.random()

