# coding: utf-8

# Autor inicial: Daniel Hamilton Smith
# Adopta aportes de Vladimir Támara Patiño <vtamara@pasosdeJesus.org>:    https://github.com/dhasane/analisis-palabras/commit/3055a69fad020f180a1beb6cb33a19d7a3138eb6

require 'set'

# Árbol Trie 
#
# Es un árbol n-ario que permite almacenar varias cadenas para después
# buscarlas eficientemente.
#
# En esta implementación cada nodo es el intermedio entre las letras de las 
# palabras.
#
# Cada nodo consta de @hijos y @relaciones:
# @relaciones:: son datos asociados a la cadena que terminan en el nodo.
# @hijos:: es un Hash cuyas llaves son las primeras letras diferentes de
#          las cadenas que se almacenan en el nodo. Si un hijo tiene como
#          llave la letra 'A' su valor será el subárbol con el resto de 
#          letras de las cadenas que comienzan con 'A'
#
# Por ejemplo mirando sólo los Hash @hijos de cada nodo, las cadenas
# AMOR y ALEGRIA podrían almacenarse así:
# 
#   {'A' => {'L' => {'E' => {'G' => {'R' => {'I' => {'A' => {}}}}}}},
#           {'M' => {'O' => {'R' => {}}}}
# 
# Excepto en el trie vacio, las hojas del árbol deben tener @datos no
# vacíos
class ArbolTrie
  # Constructora del trie vacío
  def initialize
    @hijos = {}
    @relacion = Set.new
  end

  # Retorna el Hash de hijos
  def hijos
    @hijos
  end

  # Retorna el Set de datos
  def relacion
    @relacion
  end

  # Verifica que un árbol esté bien formado
  #
  # +cadena_revisada+ es cadena que ya se ha revisado, el nodo actual es hijo
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

  # Agrega al trie la +cadena+ con los datos asociados
  #
  # +cadena+ es la cadena que se agrega
  #
  # +relacion+ son los datos asociados a la cadena por agregar
  #
  # En el nivel actual si hace falta agrega como hijo la primera letra 
  # de +cadena+.
  # Entra en recursión al nodo de tal hijo con el resto de +cadena+ (desde
  # la segunda letra).
  #
  # Note que se pueden agregar cadenas con espacios (i.e varias palabras)
  def agregar(cadena, relacion)
    # Si se llegó a última letra se agrega relacion
    if cadena.empty?
      @relacion.add(relacion)
    else
      # Si hace falta se crea el nuevo nodo con la primera letra de cadena
      @hijos[cadena[0]] = ArbolTrie.new if @hijos[cadena[0]].nil?
      # Entra en recursión en el nodo hijo pasando la subcadena desde
      # la posición 2
      @hijos[cadena[0]].agregar(cadena[1..-1], relacion)
    end
  end

  # Determina si la +cadena+ dada está en el trie
  #
  # Busca la primera letra de la cadena entre los hijos del nodo actual,
  # si la encuentra entra en recursión en ese nodo pasando la subcadena
  # desde la segunda letra.
  def buscar(cadena)
    if cadena.empty?
      # La última letra corresponde con el final de una cadena almacenada?
      !@relacion.empty?
    elsif !@hijos[cadena[0]].nil?
      @hijos[cadena[0]].buscar(cadena[1..-1])
    else
      false
    end
  end

  # Determina si una sublista inicial de la lista de palabras +contexto+
  # está en el trie como una cadena
  #
  # +contexto+ es una lista de palabras por buscar
  # 
  # +numero_palabra+ es el índice  de la palabra de +contexto+ en la que va
  # 
  # +iter+ es el índice dentro de contexto[numero_palabra] en el que va
  # +cadena+ es la cadena que ya ha sido encontrada en el trie
  #
  # Retorna {} si no encuentra sublista inicial de +contexto+ en el trie o
  # una Hash de la forma:
  #   {pal: cadena_encontrada, rel: datos_asociados_a_la_cadena_encontrada}
  def buscar_contexto(contexto, numero_palabra, iter, cadena)
    if contexto.nil? ||
       numero_palabra >= contexto.length ||
       iter > contexto[numero_palabra].length
      {}
    elsif iter == contexto[numero_palabra].length
      if !@relacion.empty?
        { pal: cadena + contexto[numero_palabra], rel: @relacion.to_a }
      
      # que se encuentre espacio entre los posibles hijos del nodo actual
      # y que haya una palabra siguiente en el contexto
      elsif !@hijos[' '].nil? && numero_palabra + 1 < contexto.size
        # palabra actual mas la siguiente
        cadena += contexto[numero_palabra] + ' '
        @hijos[' '].buscar_contexto(contexto, numero_palabra + 1, 0, cadena)
      else
        {}
      end

    elsif !@hijos[contexto[numero_palabra][iter]].nil?
      @hijos[contexto[numero_palabra][iter]]
        .buscar_contexto(contexto, numero_palabra, iter + 1, cadena)

    else
      {}
    end
  end

  # Agrega a +palabras+ la lista de palabras almacenadas en el trie
  #
  # +palabra+ es prefijo que lleva
  # +palabras+ es lista donde se van agregando las alamacenadas en el trie
  def reconstruir_palabras_nodo(palabra, palabras)
    palabras << palabra unless @relacion.empty?
    @hijos.each do |letra, valor|
      valor.reconstruir_palabras_nodo(palabra + letra, palabras)
    end
  end

  # Imprime el trie indentado
  def imp
    puts 'letras entre || representan el final de una palabra'
    profundidad = 0
    if @hoja
      puts profundidad.to_s + "\t" + '-' * profundidad + '|' + '|'
    end
    imp_aux(profundidad)
  end

  protected

  # Imprime el trie indentado de acuerdo a la profundidad
  # con respecto a la raiz
  def imp_aux(profundidad)
    @hijos.each do |letra, value|
      puts profundidad.to_s + "\t" + '-' * profundidad + '|' + letra.to_s + '|'
      value.imp_aux(profundidad + 1)
    end
  end


end
