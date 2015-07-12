app.directive 'progress', () ->
  scope: {}
  bindToController:
    actual: '='
    expected: '='
  controller: 'ProgressCtrl as ctrl'
  link: (scope, element, attrs, ctrl) ->
    # render the svg on element
    ctrl.render(element)

    # Update the progress whenever the value changes
    scope.$watch 'ctrl.actual', -> ctrl.update()
    scope.$watch 'ctrl.expected', -> ctrl.update()
