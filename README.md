# multiple rails/arel versions
Since arel is in rails, it has become even more "private" API with possibility of breaking changes - lets see how it goes.
Article with conclusions from this repo [Does my old Arel queries work in Rails 7](https://dis-button.github.io/does_arel_work_in_rails_7)

# Running
Attention - since db folders are shared, please genereate migrations in rails 6 app (lowest version).

# Generation
### generate app
```bash
docker-compose run --no-deps rails_6 rails new . --force --database=postgresql --api --skip-test
docker-compose run --no-deps rails_7 rails new . --force --database=postgresql --api --skip-test
# rails 8?
```
### generate db structure
```bash
docker exec -it arel_for_rails-rails_6-1 rails db:create db:migrate db:seed
```
# usefull comands
lounch the environment first
### containers bash:
```bash
docker exec -it arel_for_rails-rails_6-1 /bin/bash
docker exec -it arel_for_rails-rails_7-1 /bin/bash
```
### test
```bash
docker exec -it arel_for_rails-rails_6-1 bundle exec rails spec
docker exec -it arel_for_rails-rails_7-1 bundle exec rails spec
```

### rubocop
```bash
docker exec -it arel_for_rails-rails_6-1 bundle exec rubocop
docker exec -it arel_for_rails-rails_7-1 bundle exec rubocop
```
