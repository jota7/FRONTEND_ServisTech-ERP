# Etapa 1: Construcción
FROM node:20-alpine AS builder
WORKDIR /app

# 1. Limpiamos cualquier rastro anterior y copiamos solo lo necesario
COPY package.json package-lock.json ./

# 2. Instalamos con permisos de superusuario dentro del contenedor
RUN npm install --legacy-peer-deps

# 3. Copiamos el código
COPY . .

# 4. PUENTEO DE PERMISOS: Forzamos el bit de ejecución a nivel de sistema
RUN chmod +x ./node_modules/.bin/vite

# 5. Ejecución directa del binario (Sin usar sh si es posible)
RUN ./node_modules/.bin/vite build

# Etapa 2: Producción con Nginx
FROM nginx:alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]