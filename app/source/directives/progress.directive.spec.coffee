describe 'Progress Indicator Directive', () ->
  scope = null
  element = null

  beforeEach ->
    module 'circular'
    inject ($compile, $rootScope) ->
      scope = $rootScope.$new()
      element = angular.element '<div><div hd-header></div></div>'
      $compile(element)(scope)
      scope.$digest()

  it 'should work', () ->
    expect(true).toBe true
