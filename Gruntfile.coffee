module.exports = (grunt) ->


  grunt.initConfig
    version: grunt.file.readJSON('package.json').version
    browserBanner: """
      /*
       * PEG.js <%= version %>
       *
       * http://pegjs.majda.cz/
       *
       * Copyright (c) 2010-2012 David Majda
       * Licensed under the MIT license
       */
      var PEG = (function(undefined) {
        var modules = {
          define: function(name, factory) {
            var dir    = name.replace(/(^|\/)[^/]+$$/, "$$1"),
                module = { exports: {} };

            function require(path) {
              var name   = dir + path,
                  regexp = /[^\/]+\/\.\.\/|\.\//;

              /* Can't use /.../g because we can move backwards in the string. */
              while (regexp.test(name)) {
                name = name.replace(regexp, "");
              }

              return modules[name];
            }

            factory(module, require);
            this[name] = module.exports;
          }
        };

      """
    modulePrepend: """
	      modules.define(\"$$module\", function(module, require) {

      """
    moduleAppend: """
        });

      """

    dirs:
      src: 'src'
      lib: 'lib'
      bin: 'bin'
      browser: 'browser'
      spec: 'spec'
      benchmark: 'benchmark'

    files:
      parserSrc: '<%= dirs.src %>/parser.pegjs'
      parserOut: '<%= dirs.lib %>/parser.js'

      browserDev: '<%= dirs.browser %>/peg-<%= version %>.js'
      browserMin: '<%= dirs.browser %>/peg-<%= version %>.min.js'

    clean:
      browser: ['<%= files.browserDev %>', '<%= files.browserMin %>']

    concat:
      browser:
        src: [
          '<%= dirs.lib %>/utils.js'
          '<%= dirs.lib %>/grammar-error.js'
          '<%= dirs.lib %>/parser.js'
          '<%= dirs.lib %>/compiler/opcodes.js'
          '<%= dirs.lib %>/compiler/passes/generate-bytecode.js'
          '<%= dirs.lib %>/compiler/passes/generate-javascript.js'
          '<%= dirs.lib %>/compiler/passes/remove-proxy-rules.js'
          '<%= dirs.lib %>/compiler/passes/report-left-recursion.js'
          '<%= dirs.lib %>/compiler/passes/report-missing-rules.js'
          '<%= dirs.lib %>/compiler.js'
          '<%= dirs.lib %>/peg.js'
        ]
        dest: '<%= files.browserDev %>'
        options:
          banner: '<%= browserBanner %>'
          wrapper: [
            '<%= modulePrepend %>'
            '<%= moduleAppend %>'
          ]


  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-wrap'

  grunt.registerTask 'browser', ['clean:browser', 'concat:browser', 'uglify:browser']
  grunt.registerTask 'default', 'browser'