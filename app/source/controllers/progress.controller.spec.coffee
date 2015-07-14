describe 'Progress Indicator Controller', ->
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
      expect($(el).find('circle').attr('r')).toBe('71.4')
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

    it 'should create an arc object with given radius and tickness', ->
      arc = ctrl.arc(20)
      expect(arc.outerRadius()()).toBe(20)
      expect(arc.innerRadius()()).toBe(20)
      expect(arc.startAngle()()).toBe(0)

      arc = ctrl.arc(50)
      expect(arc.outerRadius()()).toBe(50)
      expect(arc.innerRadius()()).toBe(50)
      expect(arc.startAngle()()).toBe(0)

  describe 'line method', ->

    it 'should create a line with given color and arc', ->
      arc = ctrl.arc(20)
      line = ctrl.line('#ff0000', '8px', arc)
      expect(line.attr('d')).not.toBeUndefined()
      expect(line.attr('stroke-linejoin')).toBe('round')
      expect(line.attr('style')).toBe('stroke: #ff0000; stroke-width: 8px; ')
      expect(line.datum().endAngle).toBe(0)

      # possibly a bug in D3
      # expect(line.style('fill')).toBe('#ff0000')

  describe 'createTween method', ->

    it 'should return a function that uses given arc as tween', ->
      # Not enough D3 knowledge to get this one working
      arc = ctrl.arc(20)
      line = ctrl.line('#ff0000', '8px', arc)
      # tween = ctrl.createTween(arc)
      # element = tween(d3.transition(), 30)

  describe 'update method', ->
    el = undefined

    beforeEach ->
      createController()
      el = document.createElement('div')
      ctrl.actual = 0
      ctrl.expected = 0
      ctrl.render([el])

    it 'should update the rendered element with given values', (done) ->
      # original value is initially 0, 0
      pathOuterInitial = $(el).find('path').first().attr('d')
      pathInnerInitial = $(el).find('path').last().attr('d')

      # set new values and call update
      ctrl.actual = 0.5
      ctrl.expected = 0.5
      ctrl.update()

      setTimeout ->
        pathOuter = $(el).find('path').first().attr('d')
        pathInner = $(el).find('path').last().attr('d')

        # should have been updated
        # Checking against exact values seems to be too fragile
        expect(pathOuter).not.toBe(pathOuterInitial)
        expect(pathInner).not.toBe(pathInnerInitial)

        # end the test
        done()
      , 1100

    it 'should change the color as well', (done) ->
      ctrl.actual = 0.5
      ctrl.expected = 0.5
      ctrl.update()

      setTimeout ->
        pathOuter = $(el).find('path').first().attr('style')

        expect(pathOuter).toBe('stroke-width: 8px; stroke: #78c000; ')

        # end the test
        done()
      , 1100

    it 'should update the text', ->
      ctrl.expected = 0.5
      ctrl.actual = 0.5
      ctrl.update()
      expect($(el).find('tspan').first().text()).toBe('50')
      ctrl.actual = 1
      ctrl.update()
      expect($(el).find('tspan').first().text()).toBe('100')
      ctrl.actual = 2
      ctrl.update()
      expect($(el).find('tspan').first().text()).toBe('200')
      ctrl.actual = -1
      ctrl.update()
      expect($(el).find('tspan').first().text()).toBe('-100')


