FROM nginx:latest

# Hapus semua konfigurasi default di conf.d
RUN rm -rf /etc/nginx/conf.d/*

# Menyalin default.conf kita ke lokasi yang biasa di-include
COPY default.conf /etc/nginx/conf.d/default.conf

COPY default.conf /etc/nginx/nginx.conf

EXPOSE 80