assert    = require \assert
{Lisp}    = require \../src/lisp

# Avoid the LiveScript magic `it` arg when used inside a function body.
test = it

describe 'Lisp#eval', ->

  l = new Lisp

  describe 'eq', ->

    test 'works', ->

      assert.equal do
        l.eval [\eq, [\quote, \hello], [\quote 1] ]
        false

      assert.equal do
        l.eval [\eq, [\quote, 1], [\quote 1] ]
        true

      assert.equal do
        l.eval [\eq, [\quote, ''], [\quote ''] ]
        true

      assert.equal do
        l.eval [\eq, [\quote, 'hello'], [\quote 'hello'] ]
        true


  describe 'label', ->

    before ->
      l.eval [\label, \a, 42]

    test 'works', ->

      assert.equal do
        l.eval \a
        42

      assert.equal do
        l.eval [\eq, 42, \a]
        true


  describe 'more stuff', ->

    test 'works', ->

      assert.deepEqual do
        l.eval [\quote, [1, 2]]
        [1, 2]

      assert.equal do
        l.eval [\car, [\quote, [1, 2]]]
        1

      assert.deepEqual do
        l.eval [\cdr, [\quote, [1, 2]]]
        [2]

      assert.deepEqual do
        l.eval [\cons, 1, [\quote, [2,3]]]
        [1, 2, 3]

      assert.equal do
        l.eval [\if, [\eq, 1, 2], 42, 43]
        43

      assert.equal do
        l.eval [\atom, [\quote, [1,2]]]
        false

      assert.equal do
        typeof l.eval [\lambda, [\x], [\car, [\cdr, \x]]]
        'function'

      l.eval [\label, \second, [\quote, [\lambda, [\x], [\car, [\cdr, \x]]]]]

      assert.equal do
        l.eval [\second, [\quote, [1, 2, 3]]]
        2
