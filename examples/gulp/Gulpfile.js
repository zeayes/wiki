var del = require('del');
var gulp = require('gulp');
var concat = require('gulp-concat');
var uglifyjs = require('gulp-uglifyjs');
var compass = require('gulp-compass');
var postcss = require('gulp-postcss');
var autoprefixer = require('autoprefixer-core');
var minifyCSS = require('gulp-minify-css');
var livereload = require('gulp-livereload');

gulp.task('compass', function() {
    gulp.src('css/scss/*.scss')
    .pipe(compass({
        project: __dirname,
        sass: 'css/scss',
        css: 'dist/css',
        images: 'images'
    }))
    .pipe(postcss([ autoprefixer({browsers: ['last 2 version']})]))
    .pipe(minifyCSS())
    .pipe(gulp.dest('dist/css'));
});

gulp.task('scripts', function() {
    gulp.src('js/*.js')
    .pipe(concat('index.js'))
    .pipe(uglifyjs('index.min.js', {
            outSourceMap: true
        }))
    .pipe(gulp.dest('dist/js'));
});

gulp.task('clean', function() {
    del(['dist/css', 'dist/js']);
});

gulp.task('watch', function() {
    var server = livereload();

    gulp.watch('js/*.js', ['scripts']);
    gulp.watch('css/scss/*.scss', ['compass'], function(file) {
        server.changed(file.path);
    });
});

gulp.task('default', ['clean'], function() {
    gulp.start('compass', 'scripts', 'watch');
});
