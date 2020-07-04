# coding: utf-8
Gem::Specification.new do |s|
  s.name        = 'buscador_palabras'
  s.version     = '1.0.5'
  s.date        = '2020-05-13'
  s.summary     = 'Buscador de palabras en un texto'
  s.description = 'Busca rapidamente una serie de cadenas en un texto '\
    'usando un trie.  Cada cadena por buscar se almacena en un trie con '\
    'datos asociados, los cuales serán retornados cuando la palabra se '\
    'encuentre en el texto.',
  s.authors     = ['Daniel Hamilton-Smith Santa Cruz', 'Vladimir Támara Patiño']
  s.email       = ['D.hamiltonsmith@outlook.com', 'vtamara@pasosdeJesus.org']
  s.files       = ['lib/buscador_palabras.rb', 'lib/arbol_trie.rb']
  s.homepage    = 'https://github.com/dhasane/diccionario-palabras'
  s.license     = 'MIT'
end
