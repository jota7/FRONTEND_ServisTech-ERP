# Usamos Nginx directamente
FROM nginx:alpine

# Borramos la config por defecto
RUN rm /etc/nginx/conf.d/default.conf

# Copiamos TU configuración de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# COPIAMOS LA CARPETA DIST QUE CREASTE EN TU PC
# Asegúrate de que la carpeta 'dist' exista en tu raíz
COPY dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]