FROM node:16.18.0-alpine AS builder
ARG VUE_APP_API_URL=${VUE_APP_API_URL}
WORKDIR /usr/src/app
COPY . .
RUN npx browserslist@latest --update-db && \
    npm install -g npm@8.19.3 && \
    npm install && \
    VUE_APP_API_URL=${VUE_APP_API_URL} npm run build

FROM nginx:1.21.6-alpine
RUN rm -rf /usr/share/nginx/html
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html
COPY --from=builder /usr/src/app/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /usr/src/app/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
