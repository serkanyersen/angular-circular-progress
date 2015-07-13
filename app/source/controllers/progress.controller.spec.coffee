describe 'Progress Indicator Controller', ->
  # createController = undefined
  # ctrl = undefined
  # scope = undefined
  # f3 = undefined

  # beforeEach ->
  #   module 'circular'

  #   # spy on d3
  #   f3 = d3Spy();
  #   spyOn(d3, 'select').and.returnValue(f3);

  #   inject ($compile, $rootScope) ->
  #     scope = $rootScope.$new()
  #     element = angular.element '<div progress data-actual="0.5" data-expected="0.5"></div>'
  #     $compile(element)(scope)

  #     ctrl = element.controller('progress');
  #     scope.$digest()

  # it 'should call all methods with correct arguments', ->
  #   expect(f3.svg).toHaveBeenCalledWith();
  createController = undefined
  ctrl = undefined

  beforeEach ->
    module 'circular'

    # Initialize the controller
    inject ($controller, $rootScope) ->
      scope = $rootScope.$new()

      scope.actual = 0.5
      scope.expected = 0.5

      createController = ->
        ctrl = $controller 'ProgressCtrl',
          $scope: scope

  describe 'render method', ->
    el = undefined

    beforeEach ->
      createController()
      el = document.createElement('div')
      ctrl.render([el])

    it 'should render svg width correct parameters', ->
      expect($(el)).toContainElement('svg')
      expect($(el).find('svg').attr('width')).toBe('200')
      expect($(el).find('svg').attr('height')).toBe('200')

    it 'should render group in svg with correct translate', ->
      expect($(el).find('svg')).toContainElement('g')
      $g = $(el).find('svg > g')
      expect($g.attr('transform')).toBe('translate(100,100)')

    it 'should get arcs created', ->
      expect(ctrl.innerArc).not.toBeUndefined()
      expect(ctrl.outerArc).not.toBeUndefined()

    it 'should render circle background', ->
      expect($(el)).toContainElement('circle')
      # check if circle has the correct radius
      expect($(el).find('circle').attr('r')).toBe('81')
      # check color
      expect($(el).find('circle').attr('fill')).toBe('#f5f5f5')

    it 'should render the text group with percentage and progress text', ->
      expect($(el)).toContainElement('text')
      expect($(el).find('text').length).toBe(2)

    it 'should render progress number and sign in tspan elements', ->
      expect($(el).find('text')).toContainElement('tspan')
      tspans = $(el).find('text > tspan')
      expect(tspans.length).toBe(2)
      expect($(tspans[0]).text()).toBe('0')
      expect($(tspans[1]).text()).toBe('%')

    it 'should render Progress text', ->
      expect($($(el).find('text')[1]).text()).toBe('Progress')

  describe 'getColor method', ->

    it 'should return red when less than 0.25', ->
      expect(ctrl.getColor(0.24)).toBe('#ff0000')

    it 'should return bright red when less than 0.50', ->
      expect(ctrl.getColor(0.49)).toBe('#F7640A')

    it 'should return orange for bigger values', ->
      expect(ctrl.getColor(0.60)).toBe('#78c000')

    it 'should allow bad values', ->
      expect(ctrl.getColor(12)).toBe('#78c000')
      expect(ctrl.getColor(NaN)).toBe('#78c000')
      expect(ctrl.getColor('bad')).toBe('#78c000')
      expect(ctrl.getColor()).toBe('#78c000')
      # false is 0
      expect(ctrl.getColor(false)).toBe('#ff0000')
      expect(ctrl.getColor(-1)).toBe('#ff0000')

  describe 'arc method', ->

    it 'should create an arc object with gven radius and tickness', ->
      arc = ctrl.arc(20, 5)
      expect(arc.outerRadius()()).toBe(20)
      expect(arc.innerRadius()()).toBe(15)
      expect(arc.startAngle()()).toBe(0)

      arc = ctrl.arc(50, 15)
      expect(arc.outerRadius()()).toBe(50)
      expect(arc.innerRadius()()).toBe(35)
      expect(arc.startAngle()()).toBe(0)

  describe 'line method', ->

    it 'should create a line with given color and arc', ->
      arc = ctrl.arc(20, 5)
      line = ctrl.line('#ff0000', arc)
      expect(line.attr('d')).toBe('M1.2246467991473533e-15,' +
                                  '-20A20,20 0 0,1 1.2246467991473533e-15,' +
                                  '-20L9.18485099360515e-16,-15A15,' +
                                  '15 0 0,0 9.18485099360515e-16,-15Z')
      expect(line.attr('stroke-linecap')).toBe('round')
      expect(line.attr('stroke-linejoin')).toBe('round')
      expect(line.datum().endAngle).toBe(0)

      # possibly a bug in D3
      # expect(line.style('fill')).toBe('#ff0000')

  describe 'createTween method', ->

    it 'should return a function that uses given arc as tween', ->
      arc = ctrl.arc(20, 5)
      line = ctrl.line('#ff0000', arc)
      tween = ctrl.createTween(arc)
      element = tween(d3.transition(), 30)
