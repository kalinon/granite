docker run --name mysql -d \
  -e MYSQL_ROOT_PASSWORD=password \
  -e MYSQL_DATABASE=granite_db \
  -e MYSQL_USER=granite \
  -e MYSQL_PASSWORD=password \
  -p 3306:3306 \
  mysql:5.7

docker run --name psql -d \
  -e POSTGRES_USER=granite \
  -e POSTGRES_PASSWORD=password \
  -e POSTGRES_DB=granite_db \
  -p 5432:5432 \
  postgres:10.4
