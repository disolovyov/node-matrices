fs       = require 'fs'
glob     = require 'glob'
matrices = require './src/matrices'
path     = require 'path'
stitch   = require 'stitch'
uglify   = require 'uglify-js'
{exec}   = require 'child_process'

# Run the specified function if a given executable is installed,
# or print a notice.
ifInstalled = (executable, fn) ->
  exec 'which ' + executable, (err) ->
    return fn() unless err
    console.log "This task needs `#{executable}' to be installed and in PATH."

# Try to execute a shell command or fail with an error.
tryExec = (cmd) ->
  proc = exec cmd, (err) ->
    throw err if err
  proc.stdout.on 'data', (data) ->
    process.stdout.write data.toString()

# Safely make a directory with default permissions.
makeDir = (dir) ->
  fs.mkdirSync dir, 0755 unless path.existsSync dir

# Source header for built files.
header = """
/**
 * Node.js matrices #{matrices.VERSION} (browser bundle)
 *
 * Copyright (c) 2010-2011 Dimitry Solovyov
 * Released under the MIT license
 */

"""

# Source footer for built files.
footer = "this.matrices = require('matrices');"

# Compile all CoffeeScript sources.
build = (watch) ->
  ifInstalled 'coffee', ->
    tryExec "rm -rf lib && coffee -cb#{if watch then 'w' else ''} -o lib src"

# Compile all CoffeeScript sources for the browser.
buildBrowser = ->
  stitch
    .createPackage
      paths: [__dirname + '/src']
    .compile (err, src) ->
      throw err if err
      makeDir 'build'
      makeDir 'build/' + matrices.VERSION
      dir = fs.realpathSync 'build/' + matrices.VERSION
      fs.writeFileSync dir + '/pablo.js', header + src + footer
      fs.writeFileSync dir + '/pablo.min.js', header + uglify(src + footer)
      tryExec "rm -f build/edge && ln -s #{dir}/ build/edge"

# Build task for Node.
task 'build', 'Compile CoffeeScript source for Node.', ->
  build()

# Build task for browsers.
task 'build:browser', 'Compile CoffeeScript source for browsers.', ->
  buildBrowser()

# Build task for both Node and browsers.
task 'build:all', 'Compile CoffeeScript source for Node and browsers.', ->
  build()
  buildBrowser()

# Dev task for Node and browsers.
task 'dev', 'Build everything once, then watch for changes.', ->
  build true
  for file in glob.globSync 'src/**/*.coffee'
    fs.watchFile file, {persistent: true, interval: 500}, (curr, prev) ->
      if curr.mtime isnt prev.mtime
        buildBrowser()

# Generate documentation files using Docco.
task 'docs', 'Generate documentation files.', ->
  ifInstalled 'docco', ->
    tryExec 'docco src/*.coffee src/matrices/*.coffee'

# Remove build and lib directories to allow for a clean build
# or just tidy things up.
task 'clean', 'Take care of the compilation aftermath.', ->
  tryExec 'rm -rf {build,lib}'

# Remove docs directory, if this is ever needed.
task 'clean:docs', 'Clean the generated documentation files.', ->
  tryExec 'rm -rf docs'

# Remove build, docs, and lib directories altogether.
task 'clean:all', 'Clean both the build file and the docs.', ->
  tryExec 'rm -rf {build,docs,lib}'
