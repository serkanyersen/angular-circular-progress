
module.exports = function(grunt) {
    'use strict';

    // Livereload port
    var livereload = 1212;

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        clean: {
            build: {
                src: ['dist/**/*.*']
            }
        },

        coffee: {
            build: {
                options: {
                    join: true
                },
                files: {
                    'dist/js/app.js': [
                        'app/source/main.coffee',
                        'app/source/**/*.coffee',
                        '!app/source/**/*.spec.coffee'
                    ]
                }
            },
        },

        copy: {
            build: {
                files: [{
                    expand: true,
                    cwd: 'app/images/',
                    src: ['**'],
                    dest: 'dist/images/'
                }, {
                    expand: true,
                    cwd: 'app/',
                    src: ['index.html'],
                    dest: 'dist/'
                }]
            }
        },

        concat: {
            build: {
                files: [{
                    dest: 'dist/js/lib.js',
                    src: [
                        'app/lib/*.js',
                        '!app/lib/angular.mock.js',
                        '!app/lib/jasmine*.js',
                        '!app/lib/jquery.js'
                    ]
                }]
            }
        },

        sass: {
            build: {
                files: {
                    'dist/css/app.css': [
                        'app/styles/core.sass'
                    ]
                }
            }
        },

        watch: {
            coffee: {
                files: [
                    'app/**/*.coffee'
                ],
                tasks: ['coffee:build'],
                options: {
                    livereload: livereload
                }
            },
            js: {
                files: [
                    'app/**/*js'
                ],
                tasks: ['concat:build'],
                options: {
                    livereload: livereload
                }
            },
            html: {
                files: [
                    'app/index.html',
                    'app/**/*.html'
                ],
                tasks: ['copy:build'],
                options: {
                    livereload: livereload
                }
            },
            sass: {
                files: [
                    'app/styles/**/*.sass',
                    'app/styles/**/*.scss',
                    'app/lib/**/*.sass',
                    'app/lib/**/*.scss'
                ],
                tasks: ['sass:build'],
                options: {
                    livereload: livereload
                }
            }
        },

        connect: {
            serve: {
                options: {
                    port: 8088,
                    hostname: 'localhost',
                    livereload: livereload,
                    base: 'dist/'
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-sass');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-connect');
    grunt.loadNpmTasks('grunt-contrib-clean');

    grunt.registerTask('server', function () {

        grunt.task.run(['connect:serve', 'clean:build', 'copy:build', 'sass:build', 'coffee:build', 'concat:build', 'watch']);

    });

    grunt.registerTask('build', function () {

        grunt.task.run(['clean:build', 'copy:build', 'sass:build', 'coffee:build', 'concat:build']);

    });
};
