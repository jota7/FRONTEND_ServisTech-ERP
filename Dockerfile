# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app

# Instalamos dependencias de sistema necesarias
RUN apk add --no-cache libc6-compat

# Copiamos archivos de dependencias
COPY package*.json ./

# Instalamos TODO incluyendo dependencias de desarrollo (Vite)
RUN npm install --legacy-peer-deps

# Copiamos el resto del código
COPY . .

# Forzamos permisos de ejecución
RUN chmod -R +x node_modules/.bin

# Compilamos la aplicación
RUN npm run build

# Stage 2: Servidor de Producción
FROM nginx:alpine AS production

# Copiamos los archivos compilados al servidor Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Copiamos la configuración de Nginx para que funcionen las rutas de React
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]