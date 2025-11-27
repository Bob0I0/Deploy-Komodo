# /etc/komodo/repos/Repo/nginx/Dockerfile
FROM nginx:latest

# Hapus konfigurasi default Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Salin file konfigurasi yang sudah benar dari host ke dalam image
# Asumsi default.conf berada di samping Dockerfile ini (yaitu di ./nginx/)
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80