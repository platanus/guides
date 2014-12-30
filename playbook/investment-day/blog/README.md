# Blog - Codigo Banana

Para administrar el blog, se usara el board **blog** en trello y se debe seguir el siguiente flujo:

#### Ideas

Para empezar hay que crear una tarjeta (card) en la columna **Ideas**, y asignarse a uno mismo.

> Dicen por ahi que es bueno darse el tiempo para pensar muy bien el titulo del post, de esta manera uno se enfoca bien en el scope del tema del cual quiere hablar.

#### Empezar a escribir un borrador

Al empezar a escribir, mueve la tarjeta del post a la columna **Drafts**. La idea es que todos sepamos que ya te decidiste a empezar a estribir este post. Crea el draft, commitealo en un nuevo branch y has push al branch.

En la linea de comando puedes hacer

```shell
$ jekyll draft <titulo>
$ git checkout -b <branch-titulo>
$ git commit -a -m "adds the <titulo> draft"
$ git push origin <branch-titulo>
```

Escribelo usando markdown y agrega algunos tags que hagan referencia al contenido. Tambien agregar tu usuario de github como author.

#### Un poco de feedback

Cuando estes listo para recibir feedback, mueve la tarjeta a la columna **Needs Review**. Este es el momento para compartir el link al markdown en el branch verlo y comentar. Puedes compartirlo por mail y por hipchat si quieres.

#### Ultimos detalles

Haz los cambios necesario en el branch de acuerdo al feedback recibido. Cuando este listo para ser publicado haz `squash` de los commits y pasa el tarjeta a la columna **Queued**. Ahi quedara en la cola para se mergeado y publicado.

Para mas informacion ve el [Readme](https://github.com/platanus/blog/blob/master/README.MD) del blog
