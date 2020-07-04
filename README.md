# Buscador de palabras

Busca rapidamente una serie de cadenas en un texto usando un trie.
Cada cadena por buscar se almacena en un trie con datos asociados,
los cuales serán retornados cuando la palabra se encuentre en el texto.

## Inicialización:
> buscador = BuscadorPalabras.new

## Agregar nuevas cadenas por buscar con datos asociados:
> buscador.agregar('texto', ['escrito'])
> buscador.agregar('buscador', ['ubicacion palabras', 'recopilación palabras'])

## Analizar un texto buscando las cadenas:
El método `analizar` recibe el texto por analizar y el entero
`tam_contexto`, que corresponde a la cantidad de palabras de
contexto a retornar antes y después de cada ocurrencia de cada
cadena encontrada.

Por ejemplo con las cadenas 'texto' y 'buscador' agregadas
como se presentó, el siguiente código:
~~~
texto = 'esto es un texto, y se va a analizar en el buscador'
tam_contexto = 5
buscador.analizar(texto, tam_contexto )
~~~
retornará este Hash --reorganizado para entenderlo mejor:
~~~~
{
    "texto" => {
        :palabra=>"texto",
        :contexto=>{
            :pre=>["esto", "es", "un"],
            :pos=>["y", "se", "va", "a", "analizar"]
        },
        :relaciones=>[
            ["escrito"]
        ]
    },
    "buscador" => {
        :palabra=>"buscador",
        :contexto=>{
            :pre=>["va", "a", "analizar", "en", "el"],
            :pos=>[]
        },
        :relaciones=>[
            ["ubicacion palabras", "recopilacion palabras"]
        ]
    }
}
~~~~
