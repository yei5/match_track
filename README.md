# match_track

Esta primera entrega implementa un flujo completo de autenticacion usando las pantallas de **login**, **register** y **profile**.

Al ejecutar el proyecto se debe crear un archivo .env que contenga las credenciales de acceso a supabase, para fines de la entrega se ponen dichas credenciales en este documento.

```bash
SUPABASE_URL=https://hxwhndtlhnkbxnjbrpud.supabase.co
SUPABASE_ANON_KEY=sb_publishable_CScb8w6Oxzp1Dweg5OkX9g_bJS9tylZ
```

El flujo de la aplicacion es el siguiente:

Al ejecutar flutter run despues de haber instalado las dependencias necesarias la aplicacion mostrara la pantalla de registro, registre un usuario nuevo o navegue hacia la pantalla de login para usar uno exitente. Si existe algun durante alguno de estos procesos, la aplicacion lo notificara y se quedara en dichas pantallas. Si el proceso es exitoso sera redirigido a la pantalla de profile donde podra ver un resumen de la sesion activa asi como alguna informacion de partidos y equipos situada alli como placeholder para ser implementada de forma real en una posterior entrega.
