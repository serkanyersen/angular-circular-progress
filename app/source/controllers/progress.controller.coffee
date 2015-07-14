app.controller 'ProgressCtrl',
    class ProgressCtrl

      constructor: ($scope) ->
        @τ = 2 * Math.PI
        @width = 200
        @height = 200
        @rad = (@width / 2) - 10
        @offset = @rad * 0.02

      # creates an arc generator with given radius
      arc: (radius) ->
        d3.svg.arc()
          .outerRadius(radius)
          .innerRadius(radius)
          .startAngle(0)

      # draws a line with given color
      # that follows given destination
      line: (color, width, d) ->
        @svg.append('path')
          .datum(endAngle: 0)
          .style('stroke', color)
          .style('stroke-width', width)
          .attr('d', d)
          .attr('stroke-linejoin', 'round')

      # return a color according to given value
      getColor: (value) ->
        if value < 0.25
          return '#ff0000'
        else if value < 0.50
          return '#F7640A'
        else
          return '#78c000'

      # return a font size adjusted to the value
      getFontSize: (value) ->
        length = (Number(value) or 0).toFixed(0).length
        if length >= 7
          return '1.7em'
        if length >= 6
          return '2em'
        else if length >= 4
          return '2.5em'
        else
          return '3em'

      # return a new tween function that uses
      # given arc generator for animation
      createTween: (arc) ->
        (transition, newAngle) ->
          transition.attrTween 'd', (d) ->
            interpolate = d3.interpolate(d.endAngle, newAngle)
            (t) ->
              d.endAngle = interpolate(t)
              arc d

      # get the element from directive and render values there
      render: (element) ->
        @svg = d3.select(element[0])
                .append('svg')
                .attr('width', @width)
                .attr('height', @height)
                .append('g')
                .attr('transform',
                    'translate(' + @width / 2 + ',' + @height / 2 + ')')

        # arc for path to follow
        @outerArc = @arc(@rad)
        @innerArc = @arc(@rad - (@offset + 8))

        # inner and outer paths
        @outer = @line('orange', '8px', @outerArc)
        @inner = @line('#c7e596', '4px', @innerArc)

        # circle for the text backrgound
        circle = @svg.append('circle')
                    .attr('r', @rad - @offset * 2 - 15)
                    .attr('fill', '#f5f5f5')

        # First line of text
        line1 = @svg.append('text')
                  .style("text-anchor", "middle")

        # Span for the number field which we will update later
        @number = line1.append('tspan')
                      .style('font-size', @getFontSize(0))
                      .style('fill', '#444')
                      .text('0')

        # Percentage sign. it's separate because
        # it has a different style
        line1.append('tspan')
            .style('font-size', '1.5em')
            .text('%')

        # Progress text
        line2 = @svg.append('text')
                  .attr('dy', '10%')
                  .style("text-anchor", "middle")
                  .style('font-size', '1em')
                  .style('fill', '#888')
                  .text('Progress')

      update: ->
        # make sure actual and expected is in between 0 and 1
        actual = [0, parseFloat(@actual) or 0, 1].sort()[1]
        expected = [0, parseFloat(@expected) or 0, 1].sort()[1]

        # Percantage to show
        actualPercentage = (parseFloat(@actual) or 0) * 100
        
        # animate paths
        @outer.transition()
            .duration(1000)
            .style('stroke', @getColor(actual))
            .call(@createTween(@outerArc), actual * @τ)

        @inner.transition()
            .duration(1000)
            .call(@createTween(@innerArc), expected * @τ)

        # update the text
        @number.text(actualPercentage.toFixed(0)).style('font-size', @getFontSize(actualPercentage))
