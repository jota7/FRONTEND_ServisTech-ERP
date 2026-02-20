# Etapa 1: Construcción
FROM node:20-alpine AS builder
WORKDIR /app

# Copiamos solo los archivos de configuración primero
COPY package.json package-lock.json ./

# Instalamos de forma limpia (esto asigna permisos correctos)
RUN npm ci --legacy-peer-deps

# Copiamos el resto del código
COPY . .

# Ejecutamos el build (usando npx para asegurar que encuentre el ejecutable)
RUN npx vite build

# Etapa 2: Producción con Nginx
FROM nginx:alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]