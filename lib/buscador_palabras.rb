# coding: utf-8

require_relative 'arbol_trie.rb'

# buscador para la busqueda de palabras y su contexto.
# para la busqueda de palabras se utiliza un trie, dado
# que este permite un rapido funcionamiento a la hora de
# buscar dentro de este.
# Esta clase se utiliza para el control de varias tareas
# externas al trie, como lo es la busqueda del contexto y
# en relacion al analisis de un texto.
class BuscadorPalabras
  # se inicializa el trie
  def initialize
    @trie = ArbolTrie.new
  end

  # Se ingresa una palabra al buscador
  #
  # Parametros:
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

  # busca una palabra
  #
  # Parametros:
  # recibe como parametro la palabra que se va a buscar
  # Retorno:
  # true en caso de encontrar la palabra, false de lo contrario
  def buscar(palabra)
    return if palabra.nil?

    @trie.buscar(palabra)
  end

  # imprime los nodos del arbol
  def imprimir_trie
    puts 'letras entre || representan el final de una palabra'
    @trie.prt(0)
  end

  # Busca todas las palabras de un texto en el trie, retorna las ocurrencias y las
  # relaciones de cada palabra encontrada.
  # Parametros:
  # analizar acepta dos parametros de entrada, siendo el primero el texto a analizar
  # y el segundo la cantidad de palabras alrededor de cada una de las ocurrencias a tener
  # en cuenta para el contexto a retornar
  # Retorno:
  # retorna un mapa donde la llave es la palabra encontrada y el contenido es:
  #   {contexto => c, relaciones => r}
  #   donde c es una lista con tantos elementos como ocurrencias haya de
  #   palabra en texto.
  #   Cada elemento (correspondiente a una ocurrencia) es un mapa de la forma
  #     {pre=> a , pos=> d}
  #   donde a son maximo <tt>tam_contexto</tt> palabras anteriores
  #   a la ocurrencia de la palabra en texto y d son maximo
  #   <tt>tam_contexto</tt> palaras despues de la ocurrencia.
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
        contexto = ver_contexto_de_frase(tam_contexto, palabras, respuesta[:pal].to_s, i)
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

  # Retorna las palabras alrededores de una frase ubicada en una lista de
  # palabras.
  #
  # Siendo <tt>lista_palabras</tt> una lista de palabras,
  # <tt>frase</tt> es una o varias palabras que están en la posición
  # <tt>posicion</tt> de <tt>lista_paalabras</tt>
  # y <tt>tam_contexto</tt> la cantidad de palabras de contexto
  # antes y después de la frase.
  #
  # Por ejemplo:
  # tam_contexto: 5
  # lista_palabras: ["esto", "es", "una", "frase", "de", "ejemplo"]
  # frase: "una frase"
  # posicion: 2
  # Con estos parametros el resultado sera:
  # { pre: ["esto", "es"], pos: ["de", "ejemplo"] }
  def ver_contexto_de_frase(tam_contexto, lista_palabras, frase, posicion)
    tam = frase.split(' ').size
    pre = lista_palabras[[posicion - tam_contexto, 0].max..posicion - 1]
    pos = lista_palabras[
      posicion + tam..
      [posicion + tam_contexto + tam - 1, lista_palabras.size].min
    ]
    { pre: pre, pos: pos }
  end
end
