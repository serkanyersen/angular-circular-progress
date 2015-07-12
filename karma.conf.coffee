module.exports = (config) ->
  config.set
    frameworks: [ 'jasmine' ]
    reporters: [ 'dots' ]
    preprocessors: 'app/source/**/*.coffee': [ 'coffee' ]
    port: 8089
    hostname: 'localhost'
    browsers: [ 'PhantomJS' ]
    autoWatch: true
    files: [
      # Lib files
      'app/lib/angular.js'
      'app/lib/angular*.js'
      'app/lib/*.js'
      # App files
      'app/source/**/main.coffee'
      'app/source/**/*.coffee'
    ]
