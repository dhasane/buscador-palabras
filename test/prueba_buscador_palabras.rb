#!/usr/bin/env ruby
# coding: utf-8

require 'minitest/autorun'
require_relative '../lib/buscador-palabras'

class PruebaBuscadorPalabras < Minitest::Test
  def test_vacio
    bp = BuscadorPalabras.new
    assert_equal(
      bp.analizar('esto es un texto', 0),
      {}
    )
  end

  def test_una_ocurrencia_sin_contexto
    bp = BuscadorPalabras.new
    bp.agregar('palabra', [])
    assert_equal(
      bp.analizar('esto es un texto y hay una palabra que se busca', 0),
      { 'palabra' =>
        {
          palabra: 'palabra',
          contexto: [{ pre: [], pos: [] }],
          relaciones: [[]]
        } }
    )
  end

  def test_una_ocurrencia_con_contexto
    bp = BuscadorPalabras.new
    bp.agregar('palabra', [])
    assert_equal(
      bp.analizar('esto es un texto y hay una palabra que se busca', 5),
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
    bp = BuscadorPalabras.new
    bp.agregar('palabra', [])

    resultado =
      bp.analizar(
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

  def test_contener_todas_las_palabras_guardadas
    # sacado de:
    # https://stackoverflow.com/questions/88311/how-to-generate-a-random-string-in-ruby
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    o << '-' << '}' << ']' << '{' << '[' << ',' << '.'

    # ya que en el diccionario no se guardaran repetidos
    palabras = Set.new
    bp = BuscadorPalabras.new

    # se generan 500 palabras aleatorias de 50 caracteres cada una y se guardan
    # en ambos un BuscadorPalabras y un Set
    500.times do
      string = (0...50).map { o[rand(o.length)] }.join

      palabras.add(string)
      bp.agregar(string, [])
    end

    palabras_reconstruidas = bp.reconstruir_palabras

    assert(
      palabras_reconstruidas.sort == palabras.to_a.sort,
      'palabras no encontradas'
    )
  end
end
