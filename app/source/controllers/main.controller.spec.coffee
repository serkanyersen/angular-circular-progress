describe 'Main Controller', ->
  createController = undefined
  ctrl = undefined
  # to check if it's float
  isFloat = (n) -> n is Number(n) and n % 1 isnt 0

  beforeEach ->
    module 'circular'

    # Initialize the controller
    inject ($controller) ->
      createController = ->
        ctrl = $controller 'MainCtrl'

  it 'should have default values', ->
    createController()

    expect(ctrl.actual).toBe(0.5)
    expect(ctrl.expected).toBe(0.5)

  it 'should have default list of 3 values', ->
    createController()

    expect(ctrl.numbers.length).toBe(3)

  it 'numbers should contain correct values', ->
    createController()

    for number in ctrl.numbers
      expect(isFloat number.actual).toBe yes
      expect(isFloat number.expected).toBe yes

  it 'should generate random values', ->
    current = JSON.stringify(ctrl.numbers)

    # Due to the nature of random, this test might fail
    # randomly. This can be resolved by writing error
    # resistant tests, for example I can run this test 10
    # and only pass if there are less the %50 errors
    for i in [0..3]
      ctrl.random()
      expect(JSON.stringify ctrl.numbers).not.toBe(current)
      current = JSON.stringify ctrl.numbers
