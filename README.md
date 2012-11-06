Guard::MochaNode
==================

This is a fork of the Great work from [Dave Nolan](https://github.com/textgoeshere)
with his gem [Guard::JasmineNode](https://github.com/guard/guard-jasmine-node).
Only modified to work with mocha


MochaNode guard automatically & intelligently executes mocha node specs when files are modified.


* Tested against Node 0.8.14, mocha 1.6.0

Requirements
------------

* [Node](http://nodejs.org/)
* Mocha
* [Ruby](http://ruby-lang.org) and rubygems

Install
-------

Install the gem:

    $ gem install guard-mocha-node

Add guard definition to your Guardfile by running this command:

    $ guard init mocha-node

Usage
-----

    $ guard

This will watch your project and execute your specs when files
change. It's worth checking out [the docs](https://github.com/guard/guard#readme).

Options
-------

* `:all_on_start     # default => true`

Run all the specs as soon as Guard is started.

* `:all_after_pass   # default => true`

When files are modified and the specs covering the modified files
pass, run all the specs automatically.

* `:keep_failed      # default => true`

When files are modified, run failing specs as well as specs covering
the modified files.

* `:notify           # default => true`

Display growl/libnotify notifications.

* `:coffeescript     # default => true`

Load coffeescript and all execution of .coffee files.

* `:reporter         # default => "spec"`

To select a mocha reporter

* `:color            # default => true`

Enable or disable the mocha color output

* `:recursive        # default => true`

Enable or disable the recursive directory mocha option

* `:paths_for_all_specs  # default => ['spec']`

Paths for run all specs

* `:mocha_bin`

Specify the path to the jasmine-node binary that will execute your specs.

The default `:mocha_bin` in the Guardfile assumes:

* you are running guard from the root of the project
* you installed mocha using npm
* you installed mocha locally to node_modules

If you delete the option completely from the Guardfile, it assumes the
mocha binary is already in your `$PATH`.

So if you have installed jasmine-node globally using e.g. `npm install
-g mocha`, remove the `:mocha_bin` option from the Guardfile.

Guardfile
---------

Please read the [guard docs](https://github.com/guard/guard#readme) for
more information about the Guardfile DSL.

It's powerful stuff.


TODO
----

* write a JsonFormatter for jasmine-node so we have finer-grained
  control over rendering output
* write an RSpec-style progress formatter (aka lots of green dots)
* patch Guard to locate CamelCased modules correctly

Testing
-------

    $ rake

Author
------

[Roberto Huelga Díaz](https://github.com/kanzeon)
