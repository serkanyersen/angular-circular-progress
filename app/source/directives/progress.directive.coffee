app.directive 'progress', () ->
  template: 'actual is %{{ actualValue }} <br> expected is %{{ expectedValue }}'
  scope:
    actual: '='
    expected: '='
  link: (scope) ->
    # Update the value
    update = () ->
      scope.actualValue = (parseFloat(scope.actual) * 100 / 1).toFixed(2)
      scope.expectedValue = (parseFloat(scope.expected) * 100 / 1).toFixed(2)

    # Update the progress whenever the value changes
    scope.$watch 'actual', update
    scope.$watch 'expected', update
