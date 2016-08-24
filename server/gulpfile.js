var gulp = require('gulp')
var stylus = require('gulp-stylus')
var nib = require('nib')

process.on("uncaughtException", function(err) {
  console.log(err)
})

gulp.task('stylus', function() {
  var stylusOptions = {
        use: [nib()],
        "import" : ["nib"]
    }
  gulp.src(["./static/dev/css/**/*.styl"])
    .pipe(stylus(stylusOptions))
    .pipe(gulp.dest('./static/build/css'))
})


gulp.task('watch', function() {
  gulp.watch(["./static/dev/css/**/*.styl"], ['stylus'])
})

gulp.task('default', ['stylus', 'watch'])