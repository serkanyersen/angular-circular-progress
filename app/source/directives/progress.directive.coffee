app.directive 'progress', () ->
  scope:
    actual: '='
    expected: '='

  link: (scope, element) ->
    τ = 2 * Math.PI
    width = 200
    height = 200
    rad = (width / 2)
    offset = rad * 0.02

    svg = d3.select(element[0])
            .append('svg')
            .attr('width', width)
            .attr('height', height)
            .append('g')
            .attr('transform', 'translate(' + width / 2 + ',' + height / 2 + ')')

    # creates an arc with outer radius
    # and given tickness
    arc = (outer, tickness) ->
      d3.svg.arc()
        .outerRadius(outer)
        .innerRadius(outer - tickness)
        .startAngle(0)

    # draws a line with given color
    # that follow given destination
    line = (color, d) ->
      svg.append('path')
         .datum(endAngle: 0)
         .style('fill', color)
         .attr('d', d)
         # does not work for unknown reason
         .attr('stroke-linecap', 'round')
         .attr('stroke-linejoin', 'round')

    # return a color according to given value
    getColor = (value) ->
      if value < 0.25 then '#ff0000' else if value < 0.50 then '#F7640A' else '#78c000'

    # arc for path to follow
    outerArc = arc(rad, 10)
    innerArc = arc(rad - (offset + 10), 5)

    # inner and outer paths
    outer = line('orange', outerArc)
    inner = line('#c7e596', innerArc)

    # circle for the text backrgound
    circle = svg.append('circle')
                .attr('r', rad - offset*2 - 15)
                .attr('fill', '#f5f5f5')

    # First line of text
    line1 = svg.append('text')
               .style("text-anchor", "middle")

    # Span for the number field which we will update later
    number = line1.append('tspan')
                  .style('font-size', '3em')
                  .style('fill', '#444')
                  .text('80%')

    # Percentage sign. it's separate because
    # it has a different style
    line1.append('tspan')
         .style('font-size', '1.5em')
         .text('%')

    # Progress text
    line2 = svg.append('text')
               .attr('dy', '10%')
               .style("text-anchor", "middle")
               .style('font-size', '1em')
               .style('fill', '#888')
               .text('Progress')

    # return a new tween function that uses
    # given arc for animation
    createTween = (arc) ->
      (transition, newAngle) ->
        transition.attrTween 'd', (d) ->
          interpolate = d3.interpolate(d.endAngle, newAngle)
          (t) ->
            d.endAngle = interpolate(t)
            arc d

    update = () ->
      # make sure actual and expected is in between 0 and 1
      actual = [0, parseFloat(scope.actual) or 0, 1].sort()[1];
      expected = [0, parseFloat(scope.expected) or 0, 1].sort()[1];

      # Percantage to show
      actualPercentage = (parseFloat(scope.actual) or 0) * 100

      outer.transition()
           .duration(1000)
           .style('fill', getColor(actual))
           .call(createTween(outerArc), actual * τ);

      inner.transition()
           .duration(1000)
           .call(createTween(innerArc), expected * τ);

      # update the text
      number.text(actualPercentage.toFixed(0))

    # Update the progress whenever the value changes
    scope.$watch('actual', update)
    scope.$watch('expected', update)
