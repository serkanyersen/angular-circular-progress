module.exports = (config) ->
  config.set
    frameworks: [ 'jasmine' ]
    reporters: [ 'spec' ]
    preprocessors: 'app/**/*.coffee': [ 'coffee' ]
    port: 8089
    hostname: 'localhost'
    browsers: [ 'PhantomJS' ]
    autoWatch: true
    files: [
      # Lib files
      'app/lib/angular.js'
      'app/lib/angular*.js'
      'app/lib/d3.js'

      # test helper
      'app/lib/jquery.js'
      'app/lib/jasmine-jquery.js'
      'app/lib/d3-spy.coffee'

      # App files
      'app/source/**/main.coffee'
      'app/source/**/*.coffee'
    ]
