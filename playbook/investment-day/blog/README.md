# Blog - Codigo Banana [![Stories in blog-post][badge-codigo-banana]][waffle-codigo-banana]

Para administrar el blog, se usara el waffle del repositorio del blog, y se debe seguir el siguiente flujo:

- Para empezar hay que crear un issue en la columna `ideas`, y asignarse a uno mismo a ese issue.
- Al empezar a escribir, crea un branch con el numero del issue y el nombre del post, el issue cambiara a la columna `drafts`. Escribelo usando markdown y agrega algunos tags que hagan referencia al contenido.
- Cuando este listo para recibir feedback, haz un pull-request haciendo referencia que vas a cerrar el issue correspondiente al tema. Se movera a la columna `in review`. Este es el momento para compartir el link al pull request para que los demas puedan verlo y comentar.
- Haz los cambios necesario en el branch de acuerdo al feedback recibido. Cuando este listo para ser publicado haz `squash` de los commits y pasa el issue a la columna `queued`.
- Ahi quedara en la cola para se mergeado y publicado. 

[waffle-codigo-banana]: http://waffle.io/platanus/blog
[badge-codigo-banana]: https://badge.waffle.io/platanus/blog.svg?label=blog-post&title=blog-post

