
## Entendiendo las push notifications

Una guía conceptual para entender cómo funcionan.

<img src="https://camo.githubusercontent.com/ef139a676dbb0677d091b6b17e1bb12ca6960c6a/687474703a2f2f706c6174616e2e75732f67726176617461725f776974685f746578742e706e67" style="width: 250px; border:0; background: transparent;"/>

---

## Las Notificaciones

- Las notificaciones de los teléfonos no son necesariamente "notificaciones push".
- Las aplicaciones pueden crear "notificaciones locales" en los teléfonos, sin necesidad de un servidor push, y ambas se ven igual para el usuario.

---

## Resulta útil separar las cosas.

1. **mensajes push:** sistema de comunicación cliente-servidor con la gracia de evitar que cada app haga polling por separado.
2. **notificaciones:** llamado de atención cuando nuestra app tiene algo que decir, sin importar si la app está corriendo o no.

---

## Hablemos primero de las notificaciones

### UI Android

- Las notificaciones se muestran como un ícono en el "area de notificación" y los detalles se ven en el "notification drawer".
- Una notificación requiere al menos: small icon, title y text
- Las notificaciones se pueden ver en la pantalla bloqueada recién desde Android 5.0

---

### UI Android
- Desde Android 4.1, una notificación puede tener botones que ejecutan distintas "Activities" en la app.
- Dato rosa: También se puede iniciar una "Activity" de la app cuando el usuario **elimina una notificación**.
- Se puede definir una prioridad para la notificación, que afecta el orden en que se muestran y si se usa el led para avisar que hay algo pendiente.

---

### UI Android

- Además hay 14 categorías de notificación, como PROMO, EVENT, CALL, ERROR, etc. que ayudan al OS a decidir cómo mostrarlas.
- Al programar la aplicación somos responsables de juntar múltiples notificaciones en un resumen.

<img src="http://developer.android.com/images/android-5.0/notifications/Summarise_Do.png" style="width: 250px; background: white;"/>

---

### UI Android
- La aplicación puede modificar las notificaciones después de haberlas creado (por ejemplo, para aumentar el número de mensajes que indica)
- La aplicación puede eliminar las notificaciones después de haberlas creado (por ejemplo, cuando empieza la app puede llamar a cancelAll() )
- Las notificaciones pueden estar asociadas a personas de los contactos y Android puede usar eso para agrupar notificaciones.

---

## iOS

En iOS se confunden un poco los conceptos de notificación y mensaje push: Hablan de "notificación local" y "notificación remota".

---

### UI iOS

- Las notificaciones normalmente se muestran como un recuadro en la parte superior de la pantalla, que desaparece en algunos segundos.
- La notificación normal puede tener 2 botones.
- También existen las notificaciones "alert" que son más parecidas a un diálogo alert típico, pero con hasta 4 botones.

---

### UI iOS
- Las aplicaciones iOS pueden tener un "badge" que es un numerito en rojo junto al ícono de la app.
- El badge es responsabilidad de la app, y puede cambiarse desde una notificación remota o una local.

---

### En Apple, las notificaciones pueden "llegar" en 3 momentos
- La app está en el front: La aplicación recibe una llamada desde el OS, el OS no muestra nada.
- La app está apagada: Se llama a la aplicación con la información de la notificación disponible y una vez que empieza, el OS vuelve a avisarle de la notificación.
- La app está en el background: El OS muestra la notificación y se la pasa a la app "mientras sea posible". Si no es posible, espera a que esté en el front y se la pasa.

---

### Notificaciones Remotas: APNS

Apple ofrece "Apple Push Notification Server", en versión sandbox y producción, que permite enviar mensajes push (notificaciones remotas) a los dispositivos.
Las aplicaciones tienen que registrarse en este servidor para poder recibir sus mensajes.

---

### Registro en APNS Paso a Paso

1. La app le dice al sistema operativo iOS: "Yo recibo mensajes push"
2. iOS le dice al APNS "Pásale un device-token a esta app"
3. APNS le entrega el device-token a la app
4. La app le entrega el device-token al "Provider" (nuestro backend)

---

### El device-token es una especie de número telefónico.
- El device-token cambia luego de una actualización de iOS, cada 2 años y ante un reseteo del equipo.
- Una aplicación debiera registrarse cada vez que empieza, y volver a darle el device-token actual al Provider.
- Si el teléfono está apagado, APNS guarda 1 y solo 1 notificación por app, por un "tiempo limitado" (se rumorea 28 días).

---

## Google Cloud Messaging
- Además de lo mismo que APNS, GCM hizo un wrapper para iOS así que su API envía mensajes tanto a iOS como a Android.
- La idea de Google es permitir una comunicación de dos vías, usando XMPP para la vuelta.

---

## Registro en GCM de Google
- En mayo de 2015 se deprecó la llamada a register() así que hay que tener ojo con los plugins
- Google creó una librería llamada "Intance ID" que devuelve un ID que identifica una app en un dispositivo, tanto para Android como para iOS.
- La librería se conecta a un servicio online para pedir los IDs, llamado "Instance ID Service"
- El "Instance ID Service" periódicamente (ej. cada 6 meses) hace llamados a los dispositivos para refrescar los tokens, así que hay que tener ojo y poner los llamados a nuestro servidor para guardar los nuevos tokens.

---

## Qué pasa si un usuario desinstala nuestra app en Android?
- El servidor GCM manda igual el mensaje al teléfono
- El cliente GCM del teléfono se da cuenta que no hay app y le responde eso al servidor.
- La siguiente vez que intentamos enviar un mensaje, el servidor GCM contesta NotRegistered

---

### Registro para un iPhone en GCM

1. La app le dice al sistema operativo iOS: "Yo recibo notificaciones push"
2. iOS le dice al APNS "Pásale un device-token a esta app"
3. APNS le entrega el device-token a la app
**3.5. En el caso de usar GCM, hay un paso adicional, que es pasarle el device-token a GCM para que lo traduzca a un token de GCM.
4. La app le entrega el device-token al "Provider" (nuestro backend)

---

### Conexión desde el Provider hacia el Push Notification Server
#### Cada servidor push usa su sistema de autenticación:
- En Apple se usa un certificado y una private key
- En Google se usa una api-key

Amazon SNS resuelve la problemática de almacenar estos y ofrece un wrapper para que usemos solo las keys de autenticación de Amazon, las mismas que usamos con S3, SES, etc.

---

## CONTINUARÁ...

- Cómo se conecta todo esto con los plugins de cordova?
- Qué no se puede hacer con los plugins actuales?
- Caso la app se prende o no en el mensaje push. ¿Cuán garantizado está esto? ¿Corre el JS?
- ¿Hay algún estandar sobre dónde poner las lógicas de la representación de las notificaciones? Server vs App..
- + DIAGRAMAS!!
