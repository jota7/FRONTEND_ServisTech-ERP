# Etapa 1: Construcción
FROM node:20-alpine AS builder
WORKDIR /app

# Instalamos dependencias
COPY package*.json ./
RUN npm install --legacy-peer-deps

# Copiamos el resto del código
COPY . .

# --- EL FIX DE PERMISOS ---
# Forzamos permisos de ejecución a los binarios de node_modules
RUN chmod -R +x node_modules/.bin

# Ahora sí ejecutamos el build
RUN npm run build

# Etapa 2: Servidor Nginx (Producción)
FROM nginx:alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]