FROM node:16-alpine as builder
WORKDIR /app
COPY . .
RUN npm install && npm run build


# FROM nginxproxy/nginx-proxy
FROM nginx:1.23.1-alpine
COPY --from=builder /app/build /usr/share/nginx/html
# COPY ./nginx.tmpl /app/nginx.tmpl
COPY ./nginx.conf  /etc/nginx/conf.d/default.conf
EXPOSE 80 8080

# FROM nginx:1.23.1-alpine
# COPY ./nginx.conf  /etc/nginx/conf.d/default.conf
# COPY --from=builder /app/build /usr/share/nginx/html
