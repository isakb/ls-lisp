class Lisp
  (ext = {}) ->
    @env = ext <<< do
      label: ([name, val])            -> @env[name] = eval(val, @env)
      car:   ([x, ...xs])             -> x
      cdr:   ([x, ...xs])             -> xs
      cons:  ([e, cell])              -> [e] ++ cell
      eq:    ([l, r], ctx)            -> eval(l, ctx) is eval(r, ctx)
      'if':  ([cond, thn, els], ctx)  -> if @eval(cond, ctx) then @eval(thn, ctx) else @eval(els, ctx)
      atom:  ([sexpr])                -> typeof! sexpr in ['String', 'Number']
      quote: ([sexpr, ...rest])       -> sexpr

  apply: (fn, args, ctx = @env) ->
    f = ctx[fn]
    p f
    if typeof! f is 'Function'
      f(args, ctx)
    else
      p f
      #@eval(f[2], ctx <<< hsh(flat1(zip(f[1], args))))
      @eval(f[2], ctx <<< hsh(zip(f[1], args)))

  eval: ([fn, ...args]:sexpr, ctx = @env) ~>
    p sexpr, ctx.atom([sexpr])
    return ctx[sexpr] ? sexpr  if ctx.atom([sexpr], ctx)

    args .= map (a) -> @eval(a, ctx)  if fn not in ['quote', 'if']
    @apply(fn, args, ctx)


# Shallow flattened array
flat1 = (.reduce (xs, x) -> xs ++ if Array.isArray(x) then x else [x])

zip = (...xs) -> xs[0].map (_, i) -> xs.map (x) -> x[i]

hsh = (ary) ->
  ary.reduce ((obj, [k, v]) -> obj[k] = v), {}


module.exports = {Lisp}

p = console.log
