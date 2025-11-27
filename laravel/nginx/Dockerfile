FROM nginx:latest

RUN rm -rf /etc/nginx/conf.d/*

# Copy your custom server block configuration
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80