cons = require('consolidate')



module.exports = class Document

  constructor: (store) ->
    @store = store



  render: =>
    methods = @store.methods
    methods = Object.values(methods)
    methods.sort((method1, method2) -> method1.name.localeCompare(method2.name))
    methods = methods.map (method) ->
      method = Object.assign({}, method)
      method.paramsString = method.params.map (param) ->
        if(param.subs)
          subnames = param.subs.map (sub) -> sub.name
          return '{' + subnames.join(', ') + '}'
        else
          return param.name
      method.paramsString = method.paramsString.join(', ')
      return method

    gets = @store.gets
    gets = Object.values(gets)
    gets.sort((get1, get2) -> get1.path.localeCompare(get2.path))
    gets = gets.map (get) ->
      get = Object.assign({}, get)
      queryString = get.query.map((query) -> '{'+query.name+'}').join('&')
      if(queryString)
        get.queryString = '?' + queryString
      return get

    return cons.mustache(__dirname + '/template.html', {methods, gets})