{Lisp} = require \./lisp.js

l = new Lisp


console.log l.eval [\label, \second, [\quote, [\lambda, [\x],   [\car, [\cdr, \x]]]]]
