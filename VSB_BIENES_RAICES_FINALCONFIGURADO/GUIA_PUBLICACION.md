# Vázquez Sánchez Bienes Raíces — guía de publicación

## Contenido
La página funciona localmente (para visualizar) con `python -m http.server 8000`. El panel en producción necesita Supabase: no conserva las credenciales locales antiguas y no debe usarse `server.py` en Netlify.

## 1. Crear base de datos y multimedia
1. Crea proyecto en https://supabase.com ; abre SQL Editor y ejecuta `supabase_schema.sql`.
2. Ve a Authentication > Users > Add user. Crea una dirección de correo del administrador y una contraseña robusta (no uses 2004).
3. Copia el UUID del nuevo usuario, reemplázalo en el `INSERT INTO public.admin_users` del final del SQL y ejecútalo.
4. En Project Settings > API copia Project URL y la clave **anon/public/publishable**, NUNCA la service_role o secret key. Colócalas en `assets/config.js`.
5. La política de acceso a registros y multimedia utiliza la lista `admin_users` y RLS. Deshabilita el registro público de usuarios si no se necesita.
6. Entra al panel con el correo y la contraseña creados en Supabase. **El usuario local anterior no funciona en producción.**
7. Importa `data/propiedades.json` desde el panel y pulsa Guardar. Las imágenes extraídas localmente se verán al publicar Netlify; las que subas después irán a Supabase Storage.

## 2. Publicar sin pagar hosting
1. Crea un repositorio privado en GitHub y sube el contenido de esta carpeta (no el ZIP como un solo archivo). No pongas claves secretas.
2. En https://app.netlify.com > Add new project > Import from Git selecciona el repositorio. Directorio de publicación: raíz `.` y sin comando de build. Netlify se actualiza en cada git push.
3. En Netlify > Domain management > Add domain usa `vsbienesraíces.com` (IDN, si no lo acepta, usa su forma punycode).
4. En Hostinger configura los DNS EXACTOS que Netlify indique, sin copiar valores genéricos. Activa HTTPS/SSL cuando resuelva correctamente.
5. Comprueba `https://vsbienesraíces.com/` y `https://vsbienesraíces.com/admin.html`.
6. Registra el dominio en Google Search Console y envía `/sitemap.xml`.

## 3. Cómo editar
- Precios, altas/bajas, orden, fotos y videos: desde `/admin.html` desde cualquier dispositivo, sin GitHub ni nuevo despliegue.
- Diseño general o código: modifica el repositorio y Netlify despliega automáticamente.
- Cambia la contraseña desde Supabase Authentication. No hay contraseña maestra incluida en el sitio.

## Límites y advertencias
- Netlify Free: uso condicionado a 300 créditos/mes; sitio puede pausarse al superar límites. Supabase Free: 500 MB DB, 1 GB Storage, transferencia limitada y proyectos pueden pausarse después de inactividad.
- Videos hasta 45 MB por archivo en esta interfaz. Para recorridos largos usa alojamiento externo compatible o un plan superior.
- Eliminar foto/video de una ficha elimina la referencia, NO el archivo de Storage: elimínalo también desde el dashboard de Supabase para recuperar espacio.
- La página pública tiene un catálogo de respaldo local si Supabase no está configurado. Si está configurado y la consulta falla, revisa navegador, RLS y URL; no dependas del respaldo como fuente final.
- El mapa de sitio actual cubre solo la página principal; para SEO avanzado hacen falta páginas individuales renderizadas para cada propiedad, títulos por inmueble y sitemap generado. Nadie puede garantizar primeros puestos.
- El archivo server.py es exclusivamente legado de la versión local y no debe desplegarse como backend en Netlify.
- Dominios con ñ usan IDN/punycode; valida siempre el nombre adquirido en Hostinger y la dirección de destino configurada.
- Antes de publicar haz una prueba completa de acceso, guardado, carga, edición, carga de archivos, HTTPS, DNS y permisos. No incluye conexión ya realizada a cuentas externas.
