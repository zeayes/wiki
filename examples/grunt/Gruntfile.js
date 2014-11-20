module.exports = function(grunt) {
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        compass: {
            dev: {
                options: {
                    sassDir: 'css/scss',
                    cssDir: 'dist/css',
                    imagesDir: 'images',
                    outputStyle: 'expanded',
                    generatedImagesDir: 'dist/images',
                }
            },
            dist: {
                options: {
                    sassDir: 'css/scss',
                    cssDir: 'dist/css',
                    imagesDir: 'images',
                    outputStyle: 'compressed',
                    generatedImagesDir: 'dist/images',
                }
            }, 
        },

        concat: {
            options: {
                separator: ''
            },
            dist: {
                src: ['js/*.js'],
                dest: 'dist/js/<%= pkg.name %>.js'
            }
        },

        uglify: {
            options: {
                banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
            },
            dist: {
                files: {
                    'dist/js/<%= pkg.name %>.min.js': ['<%= concat.dist.dest %>']
                }
            },
        },

        jshint: {
            files: ['Gruntfile.js', 'js/*.js'],
            options: {
                globals: {
                    jQuery: true,
                    console: true,
                    module: true,
                    document: true
                }
            }
        },

        clean: {
            js: ['dist/js/*.js', '!js/*.js'],
            css: ['dist/css/*.css'],
            images: ['dist/images']
        },

        watch: {
            options: {
                livereload: true
            },
            scripts: {
                files: ['<%= jshint.files %>'],
                tasks: ['jshint']
            },
            scss: {
                files: ['css/scss/*scss'],
                tasks: ['compass:dev']
            }, 
        }

    });

    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-compass');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-clean');

    grunt.registerTask('dist', ['jshint', 'concat', 'uglify', 'compass:dist']);
    grunt.registerTask('default', ['clean', 'jshint', 'concat', 'compass:dev', 'watch']);
};
