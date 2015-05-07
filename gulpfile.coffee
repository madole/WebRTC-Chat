gulp = require 'gulp'
sass = require 'gulp-sass'
concat = require 'gulp-concat'
jshint = require 'gulp-jshint'
uglify = require 'gulp-uglify'
watch = require 'gulp-watch'
minifyCss = require 'gulp-minify-css'
rename = require 'gulp-rename'
concat =  require 'gulp-concat'
livereload = require 'gulp-livereload'
nodemon = require 'gulp-nodemon'

# config to hold the path files
paths =
  server: ['routes/**/*.js', 'app.js', 'config.js']
  client: ['./public/js/**/*.js', '!./public/js/**/*.min.js']

# Lint the javascript server files
gulp.task 'lintserver', ->
  gulp
    .src(paths.server)
    .pipe(jshint '.jshintrc')
    .pipe(jshint.reporter 'jshint-stylish')

# Lint the javascript client files
gulp.task 'lintclient', ->
  gulp
    .src(paths.client)
    .pipe(jshint '.jshintrc')
    .pipe(jshint.reporter 'jshint-stylish')

# Uglify the client/frontend javascript files
gulp.task 'uglify', ->
  gulp
    .src(paths.client)
    .pipe(uglify())
    .pipe(rename suffix: '.min')
    .pipe(gulp.dest './public/js')


gulp.task 'concatJs', ->
  gulp
    .src(['./public/vendor/jquery/dist/jquery.min.js', './public/vendor/bootstrap/dist/js/bootstrap.min.js', './public/js/main.min.js'])
    .pipe(concat 'app.min.js')
    .pipe(gulp.dest './public/js')

# Preprocess the sass files into css files
gulp.task 'sass', ->
  gulp
    .src('./public/sass/**/*.scss')
    .pipe(sass())
    .pipe(gulp.dest './public/css')

gulp.task 'css', ->
  gulp
    .src(['./public/css/**/*.css', '!./public/css/**/*.min.css'])
    .pipe(minifyCss())
    .pipe(rename suffix: '.min')
    .pipe(gulp.dest './public/css')

# Concat all the css files
gulp.task 'concatCss', ->
  gulp
    .src(['./public/vendor/bootstrap/dist/css/bootstrap.min.css', './public/css/styles.min.css'])
    .pipe(concat 'app.styles.min.css')
    .pipe(gulp.dest './public/css')

# Watch the various files and runs their respective tasks
gulp.task 'watch', ->
  gulp.watch paths.server, ['lintserver']
  gulp.watch paths.client, ['lintclient']
  gulp.watch paths.client, ['buildJs']
  gulp.watch './public/sass/**/*.scss', ['buildCss']
  gulp
    .src(['./views/**/*.jade', './public/css/**/*.min.css', './public/js/**/*.min.js'])
    .pipe(watch())
    .pipe(livereload())


gulp.task 'start', ->
  nodemon(
    script: 'app.js'
    ext: 'js html'
    env:
      'NODE_ENV': 'development'
  )



gulp.task 'lint', ['lintserver', 'lintclient']
gulp.task 'buildCss', ['sass', 'css', 'concatCss']
gulp.task 'buildJs', ['uglify', 'concatJs']
gulp.task 'default', ['lint', 'buildCss', 'buildJs', 'watch', 'start']
