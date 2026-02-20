# Etapa 1: Construcción
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build

# Etapa 2: Servidor Nginx (Producción)
FROM nginx:alpine
# Borramos la config vieja para que no dé problemas
RUN rm /etc/nginx/conf.d/default.conf
# Ponemos tu nueva configuración
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Pasamos los archivos de la app al servidor
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]