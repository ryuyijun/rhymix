#!/bin/bash

# 변수 설정
RHYMIX_VERSION="2.1.20"
RHYMIX_URL="https://rhymix.org/files/attach/releases/rhymix-${RHYMIX_VERSION}.zip"
INSTALL_DIR="/var/www/"
DB_NAME="rhymix_db"
DB_USER="rhymix_user"
DB_PASS="securepassword"

# 필수 패키지 설치
apt update
apt install -y nginx mysql-server php8.3-fpm php8.3-mysql php8.3-xml php8.3-mbstring php8.3-zip php8.3-gd php8.3-curl wget unzip

# Rhymix 다운로드 및 압축 해제
wget $RHYMIX_URL -O rhymix.zip
mkdir -p $INSTALL_DIR
unzip rhymix.zip -d $INSTALL_DIR
rm rhymix.zip

# 디렉토리 권한 설정
chown -R www-data:www-data $INSTALL_DIR
chmod -R 755 $INSTALL_DIR

# MySQL 데이터베이스 및 사용자 생성
mysql -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Nginx 설정
wget https://raw.githubusercontent.com/ryuyijun/rhymix/refs/heads/main/rhymix.conf -O /etc/nginx/sites-available/rhymix

# Nginx 설정 활성화 및 기본 설정 파일 제거
ln -s /etc/nginx/sites-available/rhymix /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# PHP 8.3 FPM 및 Nginx 재시작
systemctl restart php8.3-fpm
systemctl restart nginx

echo "Rhymix CMS 설치가 완료되었습니다"
