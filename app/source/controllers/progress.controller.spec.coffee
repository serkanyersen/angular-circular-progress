describe 'Progress Indicator Controller', ->
  createController = undefined
  ctrl = undefined
  scope = undefined

  beforeEach ->
    module 'circular'

    # spy on d3
    f3 = d3Spy();
    spyOn(d3, 'select').and.returnValue(f3);

    inject ($compile, $rootScope) ->
      scope = $rootScope.$new()
      element = angular.element '<div progress data-actual="0.5" data-expected="0.5"></div>'
      $compile(element)(scope)

      ctrl = element.controller('progress');
      scope.$digest()

    # Initialize the controller
    # inject ($controller, $rootScope) ->
    #   scope = $rootScope.$new()
    #   scope.actual = 0.5
    #   scope.expected = 0.5

    #   createController = ->
    #     ctrl = $controller 'ProgressCtrl',
    #       $scope: scope

  it 'should render correctly', ->
    #createController()


