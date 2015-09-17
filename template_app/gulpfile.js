var gulp =require('gulp'),
    typescript = require('gulp-typescript'),
    watch = require('gulp-watch'),
    sass = require('gulp-sass'),
    minifyCSS = require('gulp-minify-css'),
	concatCSS = require('gulp-concat-css'),
    Server = require('karma').Server,
    path = {
		scss: 'static/scss/**/*.scss',
		distCSS: 'static/css/',
	},
    buildCss = function (env) {
		var content = gulp.src(path.scss)
			.pipe(sass())
			.pipe(concatCSS('style.css'))
			.pipe(minifyCSS());
		return content.pipe(gulp.dest(path.distCSS));
	};


gulp.task('watch', function() {
  gulp.watch(path.scss, ['build-css']);
});

gulp.task('build-css', function(){
	return buildCss('development')
});


gulp.task('typescript', function(){
  gulp.src([
      "./typings/**/*.ts",'static/typescript/**/*.ts'
  ])
    .pipe(typescript({
        "emitDecoratorMetadata": true,
        "experimentalDecorators": true,
        "target": "es5",
        "module": "amd",
        "declarationFiles": false,
        "removeComments": true,
        "noLib": false,
        "typescript": require('typescript')
      }))
    .pipe(gulp.dest('static/js/'))
});



gulp.task('copy-lib', function (done) {
  gulp.src(['bower_components/angular/angular.js',
    'bower_components/angular-ui-router/release/angular-ui-router.js',
    'bower_components/requirejs/require.js',
    'bower_components/jquery/dist/jquery.js',
  ])
      .pipe(gulp.dest('static/js/lib/'));
});

gulp.task('test', function (done) {
  new Server({
    configFile: __dirname + '/karma.conf.js',
    singleRun: true
  }, done).start();
});