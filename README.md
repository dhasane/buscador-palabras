# Diccionario de palabras

## Inicialización:  
> dic = Diccionario.new

## Agregar nuevas palabras:  
> relacion = []
> dic.agregar('palabra', relacion)

## Buscar una palabra:  
> dic.buscar('palabra')

## Verificar un texto:  
tam_contexto es la cantidad de palabras que serán tomadas para el contexto de una palabra.  
para el caso de querer verificar la aparición de las palabras incluidas en el diccionario:  
~~~
texto = 'esto es un texto, y se va a verificar en el diccionario'
dic.agregar('texto', ['escrito'])
dic.agregar('diccionario', ['definicion de palabras', 'recopilacion palabras'])
tam_contexto = 5
dic.verificar_texto(texto, tam_contexto )
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
        :palabra=>"diccionario", 
        :contexto=>{
            :pre=>["va", "a", "verificar", "en", "el"], 
            :pos=>[]
        }, 
        :relaciones=>[
            ["definicion de palabras", "recopilacion palabras"]
        ]
    }
]
~~~~

## Verificar varios textos:
También se tiene la funcion `verificar` la cual sirve para verificar una lista de textos  
retorna una lista de hashes de la forma 
~~~~
[
    {
        :relato : siendo el texto analizado
        :posibilidades : el mismo hash resultante de verificar_texto 
    },
    {
        ...
    },
    .
    .
    .
]
~~~~
