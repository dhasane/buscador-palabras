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
    assert_equal(resultado['palabra'][:palabra], 'palabra')
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
end
