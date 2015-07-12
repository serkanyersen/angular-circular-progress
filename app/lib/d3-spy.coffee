d3Spy = do ->

  d3SelectionSpyGenerator = (parent, name) ->
    if parent and parent[name]
      return parent[name]

    methods = [
      'append'
      'attr'
      'call'
      'datum'
      'style'
      'svg'
      'arc'
      'text'
      'select'
      'transition'
      'duration'
    ]

    spy = jasmine.createSpyObj(name, methods)

    for method in methods
      if method is 'append'
        spy.append.and.callFake (tag) ->
          res = d3SelectionSpyGenerator(this, tag)
          if typeof res is 'function' then res() else res
      else
        spy[method].and.returnValue spy

    if parent
      parent[name] = spy

    spy

  ->
    d3SelectionSpyGenerator null, 'selection'
