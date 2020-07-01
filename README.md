# Buscador de palabras

## Inicialización:  
> buscador = BuscadorPalabras.new

## Agregar nuevas palabras:  
> relacion = []
> buscador.agregar('palabra', relacion)

## Buscar una palabra:  
> buscador.buscar('palabra')

## Verificar un texto:  
tam_contexto es la cantidad de palabras que serán tomadas para el contexto de una palabra.  
para el caso de querer verificar la aparición de las palabras incluidas en el buscador:  
~~~
texto = 'esto es un texto, y se va a verificar en el buscador'
buscador.agregar('texto', ['escrito'])
buscador.agregar('buscador', ['ubicacion palabras', 'recopilacion palabras'])
tam_contexto = 5
buscador.verificar(texto, tam_contexto )
~~~

Esto retornará el siguiente hash (organizado para entenderlo mejor):  
~~~~
[
    {
        :palabra=>"texto", 
        :contexto=>{
            :pre=>["esto", "es", "un"], 
            :pos=>["y", "se", "va", "a", "verificar"]
        }, 
        :relaciones=>[
            ["escrito"]
        ]
    }, 
    {
        :palabra=>"buscador", 
        :contexto=>{
            :pre=>["va", "a", "verificar", "en", "el"], 
            :pos=>[]
        }, 
        :relaciones=>[
            ["ubicacion palabras", "recopilacion palabras"]
        ]
    }
]
~~~~
