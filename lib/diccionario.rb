
require_relative 'arbol_trie.rb'

# Diccionario para la busqueda de palabras y su contexto.
# para la busqueda de palabras se utiliza un trie, dado
# que este permite un rapido funcionamiento a la hora de
# buscar dentro de este.
# Esta clase se utiliza para el control de varias tareas
# externas al trie, como lo es la busqueda del contexto y
# en relacion al analisis de un texto.
class Diccionario
  # se inicializa el trie
  def initialize
    @trie = ArbolTrie.new
  end

  # se ingresa una palabra al diccionario
  # Parametros
  # el primer parametro es la palabra y el segundo parametro es una lista de
  # palabras relacionadas a la primera
  # un ejemplo de esto podria ser : ('escarabajo', ['carro','volkswagen'])
  def agregar(palabra, relacion)
    return if palabra.nil?

    @trie.agregar(palabra, relacion)
  end

  # reconstruye las palabras a partir de las palabras guardadas en el trie
  # Retorno:
  # lista de cadenas
  def reconstruir_palabras
    palabras = []
    @trie.reconstruir_palabras_nodo('', palabras)
    palabras
  end

  # retorna el trie
  def trie
    @trie
  end

  # busca una palabra,
  # Parametros
  # recibe como parametro la palabra que se va a buscar
  # Retorno:
  # true en caso de encontrar la palabra, false de lo contrario
  def buscar(palabra)
    return if palabra.nil?

    @trie.buscar(palabra)
  end

  # imprime los nodos del arbol
  def prt
    puts 'letras entre || representan el final de una palabra'
    @trie.prt(0)
  end

  # Busca todas las palabras de un texto en el trie, retorna las ocurrencias y las
  # relaciones de cada palabra encontrada.
  # Parametros:
  # analizar acepta dos parametros de entrada, siendo el primero el texto a analizar
  # y el segundo la cantidad de palabras alrededor de cada una de las ocurrencias a tener
  # en cuenta para el contexto
  # Retorno:
  # retorna un mapa donde la llave es la palabra encontrada y el contenido es:
  #   {contexto => c, relaciones => r}
  #   donde c es una lista con tantos elementos como ocurrencias haya de palabra en texto.
  #   Cada elemento (correspondiente a una ocurrencia) es un mapa de la forma {pre=> a , pos=> d}
  #   donde a son maximo 'tam_contexto' palabras anteriores
  #   a la ocurrencia de la palabra en texto y d son maximo 'tam_contexto' palaras despues de la ocurrencia.
  #   r es el conjunto de relaciones de la palabra en el trie.
  def analizar(texto, tam_contexto)
    resultado = {}
    texto.gsub(',', '').split('.').each do |contexto|
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
