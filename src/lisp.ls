class exports.Lisp
  (ext = {}) ->
    @env = ext with do
      label:  ([name, val])           ~> @env[name] = @eval(val, @env)
      car:    ([xs])                  -> xs.0
      cdr:    ([xs])                  -> xs.slice(1)
      cons:   ([x, xs])               -> [x] ++ xs
      eq:     ([l, r], ctx)           ~> @eval(l, ctx) is @eval(r, ctx)
      'if':   ([cond, a, b], ctx)     ~> if @eval(cond, ctx) then @eval(a, ctx) else @eval(b, ctx)
      atom:   ([sexpr])               -> typeof! sexpr in [\String, \Number]
      quote:  ([sexpr, ...rest])      -> sexpr

  apply: (f, args, ctx = @env) ~>
    return f(args, ctx)  if typeof! f is \Function
    @eval(f[2], ctx with hsh(zip(f[1], args)))

  eval: ([fn, ...args]:sexpr, ctx = @env) ~>
    if ctx.atom([sexpr])
      ctx[sexpr] ? sexpr
    else if fn is \lambda
      (...params) ~> @apply(args[1], ctx <<< hsh(zip(args[0], params)))
    else
      args = [@eval(a, ctx) for a in args]  if fn not in <[ label if quote ]>
      @apply ctx[fn], args, ctx

zip = (...ary) -> ary[0].map (_, i) -> ary.map (x) -> x[i]
hsh = (ary) -> ary.reduce ((obj, [k, v]) -> obj[k] = v; obj), {}
