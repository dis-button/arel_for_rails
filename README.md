# multiple rails/arel versions
Since arel is in rails, it has become even more "private" API with possibility of breaking changes - lets see how it goes.

# Running
Attention - since db folders are shared, please genereate migrations in rails 6 app (lowest version).

# Generation
### generate app
```bash
docker-compose run --no-deps rails_6 rails new . --force --database=postgresql --api --skip-test
docker-compose run --no-deps rails_7 rails new . --force --database=postgresql --api --skip-test
```
### generate db structure
```bash
docker exec -it arel_for_rails_rails_6_1 rails g model user username
docker exec -it arel_for_rails_rails_6_1 rails g model article subject body:text
docker exec -it arel_for_rails_rails_6_1 rails g model comment content
docker exec -it arel_for_rails_rails_6_1 rails db:create db:migrate
```
# usefull comands
lounch the environment first
### containers bash:
```bash
docker exec -it arel_for_rails-rails_6-1 /bin/bash
```
### test
```bash
docker exec -it arel_for_rails-rails_6-1 bundle exec rails spec
docker exec -it arel_for_rails-rails_7-1 bundle exec rails spec
```

### test
```bash
docker exec -it arel_for_rails-rails_6-1 bundle exec rubocop
```
