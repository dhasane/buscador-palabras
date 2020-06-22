# coding: utf-8

# Autor inicial: Daniel Hamilton Smith
# Adopta aportes de Vladimir Támara Patiño <vtamara@pasosdeJesus.org>:    https://github.com/dhasane/analisis-palabras/commit/3055a69fad020f180a1beb6cb33a19d7a3138eb6

require 'set'

# arbolito de palabras ~
class ArbolTrie
  def initialize
    @hijos = {}
    @relacion = Set.new
    # Definicion:
    # Un nodo es hoja de un arbol si y solo si
    #   @hijos == {}
    #
    # Representacion:
    # Cuando @hijos no es vacio, cada llave corresponde al primer caracter
    #   de una cadena representada y su valor al resto de la cadena
    #
    # Un nodo es final de una cadena representada en el trie si y solo si
    #     @relacion no es vacia (i.e !@relacion.empty? )
    #
    # Excepto en el trie vacio, las hojas deben tener @relacion no vacia
  end

  # Retorna el Hash de hijos
  def hijos
    @hijos
  end

  # Retorna el Set de relaciones
  def relacion
    @relacion
  end

  # Verificar que un árbol esté bien formado
  def verificar_consistencia(cadena_revisada = '')
    if @hijos.empty?
      return true
    end

    @hijos.each do |letra, subarbol|
      if letra.length != 1
        puts "** letra deberia ser un caracter tras #{cadena_revisada}"
        return false
      end
      if subarbol.class != ArbolTrie
        puts "** subarbol deberia ser ArbolTrie tras #{cadena_revisada}"
        return false
      end
      if  subarbol.hijos == {} && subarbol.relacion.count == 0
        puts "** hay una hoja con relacion vacia tras #{cadena_revisada}"
        return false
      end
      return subarbol.verificar_consistencia(cadena_revisada + letra)
    end
  end

  # Agrega al trie una cadena y un elemento al conjunto asociado a la cadena
  # Si la cadena ya existe añade el elemento al conjunto asociado
  #
  #
  # Agrega una letra al nivel actual en caso de no existir, y a ese nodo le
  # envia la cadena menos la primera letra, para continuar el proceso hasta la
  # cadena estar vacia
  # Note que se pueden agregar cadenas con espacios (i.e varias palabras)
  def agregar(cadena, relacion)
    # si se llegó a última letra se agrega relacion
    if cadena.empty?
      @relacion.add(relacion)
    else
      # se crea el nuevo nodo con la siguiente letra
      @hijos[cadena[0]] = ArbolTrie.new if @hijos[cadena[0]].nil?
      # va al siguiente nodo
      @hijos[cadena[0]].agregar(cadena[1..-1], relacion)
    end
  end

  # busca la primera letra de la cadena en los nodos del siguiente nivel
  # y envia la cadena menos la primera letra a este siguiente nivel
  def buscar(cadena)
    if cadena.empty?
      # es la ultima letra de esta palabra el final de una palabra?
      !@relacion.empty?
    elsif !@hijos[cadena[0]].nil?
      @hijos[cadena[0]].buscar(cadena[1..-1])
    else
      false
    end
  end

  # esta funcion tiene en cuenta el contexto de una palabra, para
  # poder encontrar cadenas de varias palabras que esten dentro del
  # diccionario en el texto
  # contexto es la lista de todas las palabras de un texto
  # numero palabra es la palabra que se esta buscando dentro del contexto
  # iter es la posicion en la palabra (la letra)
  # palabra es el resultado total que ha sido encontrado
  def buscar_contexto(contexto, numero_palabra, iter, palabra)
    if contexto.nil? ||
       numero_palabra >= contexto.length ||
       iter > contexto[numero_palabra].length
      {}
    elsif iter == contexto[numero_palabra].length
      if !@relacion.empty?
        { pal: palabra + contexto[numero_palabra], rel: @relacion.to_a }

      # que se encuentre espacio entre los posibles hijos del nodo actual
      # y que haya una palabra siguiente en el contexto
      elsif !@hijos[' '].nil? && numero_palabra + 1 < contexto.size
        # palabra actual mas la siguiente
        palabra += contexto[numero_palabra] + ' '
        @hijos[' '].buscar_contexto(contexto, numero_palabra + 1, 0, palabra)

      else
        {}
      end

    elsif !@hijos[contexto[numero_palabra][iter]].nil?
      @hijos[contexto[numero_palabra][iter]]
        .buscar_contexto(contexto, numero_palabra, iter + 1, palabra)

    else
      {}
    end
  end

  # agrega el nodo a la palabra, en caso de ser hoja, se agrega a las palabras
  # encontradas dentro del arbol
  def reconstruir_palabras_nodo(palabra, palabras)
    palabras << palabra unless @relacion.empty?
    @hijos.each do |letra, valor|
      valor.reconstruir_palabras_nodo(palabra + letra, palabras)
    end
  end

  # imprime el nodo, indentado dependiendo su profundidad,
  # con respecto a la raiz
  def imp_aux(profundidad)
    @hijos.each do |letra, value|
      puts profundidad.to_s + "\t" + '-' * profundidad + '|' + letra.to_s + '|'
      value.imp_aux(profundidad + 1)
    end
  end

  # imprime los nodos del arbol
  def imp
    puts 'letras entre || representan el final de una palabra'
    profundidad = 0
    if @hoja
      puts profundidad.to_s + "\t" + '-' * profundidad + '|' + '|'
    end
    imp_aux(profundidad)
  end

  # imprime el nodo, indentado dependiendo su profundidad,
  # con respecto a la raiz
  def prt(profundidad)
    # bar = @leaf ? '|' : '' # representa final de palabras
    @hijos.each do |letra, value|
      puts profundidad.to_s + "\t" + '-' * profundidad +
           bar + letra.to_s + bar +
           @relacion.to_s
      value.prt(profundidad + 1)
    end
  end
end
