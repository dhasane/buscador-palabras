
require 'set'
require_relative 'arbol_trie.rb'

# Diccionario para la busqueda de palabras y su contexto
class Diccionario
  def initialize
    @trie = ArbolTrie.new
  end

  # se ingresa una palabra al arbol
  def agregar(palabra, relacion)
    return if palabra.nil?

    @trie.agregar(palabra, relacion)
  end

  # con fines de poder comprobar que se haya guardado correctamente
  def reconstruir_palabras
    palabras = []
    @trie.reconstruir_palabras_nodo('', palabras)
    palabras
  end

  def trie
    @trie
  end

  # busca una palabra, retorna true en caso de encontrarla
  # false de lo contrario
  def buscar(palabra)
    return if palabra.nil?

    @trie.buscar(palabra)
  end

  # imprime los nodos del arbol
  def prt
    puts 'letras entre || representan el final de una palabra'
    @trie.prt(0)
  end

  # Busca todas las palabras de un texto en un trie y retorna las ocurrencias y los significados de cada palabra encontrada.
  # parametros
  # resultado
  # mapa donde cada registro palabra => contenido
  # siendo contenido
  #   {contexto => c, relaciones => r}
  #   donde c es una lista con tantos elementos como ocurrencias haya de palabra en texto.
  #   Cada elemento (correspondiente a una ocurrencia) es un mapa de la forma {pre=> a , pos=> d}
  #   donde a son máximo 'tam_contexto' palabras anteriores
  #   a la ocurrencia de la palabra en texto y d son máximo 'tam_contexto' palaras después de la ocurrencia.
  #   r es el conjunto de relaciones de la palabra en el trie.
  #   relaciones => palabras relacionadas a la palabra encontrada en el trie
  # }
  def analizar(relato, tam_contexto)
    resultado = {}
    relato.gsub(',', '').split('.').each do |contexto|
      next if contexto.nil?

      palabras = contexto.split(' ')
      palabras.each_index do |i|
        respuesta = @trie.buscar_contexto(palabras, i, 0, '')
        next if respuesta.empty?

        palabra = respuesta[:pal].to_s
        contexto = ver_contexto(tam_contexto, palabras, respuesta[:pal].to_s, i)
        if resultado[palabra].nil?
          resultado[palabra] = {
            palabra: palabra,
            contexto: [contexto],
            relaciones: respuesta[:rel]
          }
        else
          resultado[palabra][:contexto] += [contexto]
        end
      end
    end
    resultado
  end

  private

  # siendo contexto, una lista de palabras, frase lo que se tendra en cuenta y
  # entorno la cantidad de palabras alrededor de frase
  def ver_contexto(tam_contexto, contexto, frase, posicion)
    tam = frase.split(' ').size
    pre = contexto[[posicion - tam_contexto, 0].max..posicion - 1]
    pos = contexto[
      posicion + tam..
      [posicion + tam_contexto + tam - 1, contexto.size].min
    ]
    { pre: pre, pos: pos }
  end
end
