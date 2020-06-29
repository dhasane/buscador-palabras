#!/usr/bin/env ruby
# coding: utf-8

require 'minitest/autorun'
require_relative '../lib/diccionario'

class PruebaDiccionario < Minitest::Test
  def setup
  end

  def test_vacio
    d = Diccionario.new
    assert_equal(d.analizar('esto es un texto', 0), {})
  end

  def test_una_ocurrencia_sin_contexto
    d = Diccionario.new
    d.agregar('palabra', [])
    assert_equal(
      d.analizar('esto es un texto y hay una palabra que se busca', 0),
      { 'palabra' =>
        {
          palabra: 'palabra',
          contexto: [{ pre: [], pos: [] }],
          relaciones: [[]]
        } }
    )
  end

  def test_una_ocurrencia_con_contexto
    d = Diccionario.new
    d.agregar('palabra', [])
    assert_equal(
      d.analizar('esto es un texto y hay una palabra que se busca', 5),
      { 'palabra' => { palabra: 'palabra',
                       contexto: [
                         {
                           pre: %w[un texto y hay una],
                           pos: %w[que se busca]
                         }
                       ],
                       relaciones: [[]] } }
    )
  end

  def test_varias_ocurrencias_con_contexto
    d = Diccionario.new
    d.agregar('palabra', [])

    resultado =
      d.analizar(
        'la palabra que se busca es palabra y adicionalmente se busca con contexto esta palabra',
        5
      )
    assert_equal(
      resultado,
      { 'palabra' => { palabra: 'palabra',
                       contexto: [
                         {
                           pre: %w[la],
                           pos: %w[que se busca es palabra]
                         },
                         {
                           pre: %w[palabra que se busca es],
                           pos: %w[y adicionalmente se busca con]
                         },
                         {
                           pre: %w[se busca con contexto esta],
                           pos: %w[]
                         }
                       ],
                       relaciones: [[]] } }
    )
  end

  # retorna true en caso de que ambos arreglos contengan los mismos elementos
  # complejidad de O(n*m), aunque m se va reduciendo
  def unordered_equal(arr1, arr2)
    arr1.each do |val|
      return false if arr2.delete(val).nil?
    end
    true
  end

  # retorna true en caso de que ambos arreglos contengan los mismos elementos
  # complejidad de O(n*m), aunque m se va reduciendo
  def unordered_diff(arr1, arr2)
    arr1.each do |val|
      arr2.delete(val).nil?
    end
    arr2
  end

  def test_contener_todas_las_palabras_guardadas
    # sacado de:
    # https://stackoverflow.com/questions/88311/how-to-generate-a-random-string-in-ruby
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten

    # ya que en el diccionario no se guardaran repetidos
    palabras = Set.new
    d = Diccionario.new

    # se generan 500 palabras aleatorias de 50 caracteres cada una y
    # se guardan en ambos un Diccionario y un Set
    (0..500).map do
      string = (0...50).map { o[rand(o.length)] }.join

      palabras << string
      d.agregar(string)
    end

    palabras_reconstruidas = d.reconstruir_palabras

    assert(
      unordered_equal(palabras_reconstruidas, palabras.to_a),
      'palabras no encontradas'
    )
  end
end
