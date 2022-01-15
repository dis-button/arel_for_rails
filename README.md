# multiple rails/arel versions
Since arel is in rails, it has become even more "private" API with possibility of breaking changes - lets see how it goes.

Article with conclusions and explanations: [Does my old Arel queries work in Rails 7](https://martinskruze.com/does_arel_work_in_rails_7)

## Running
lounch the environment first with `docker-compose up`

### usefull comands
Warning - your contaider names can be different, you can check them with `docker ps`

#### generate db structure
```bash
docker exec -it arel_for_rails-rails_6-1 rails db:create db:migrate db:seed
```

#### containers bash:
```bash
docker exec -it arel_for_rails-rails_6-1 /bin/bash
docker exec -it arel_for_rails-rails_7-1 /bin/bash
```
#### test
```bash
docker exec -it arel_for_rails-rails_6-1 bundle exec rails spec
docker exec -it arel_for_rails-rails_7-1 bundle exec rails spec
```

#### rubocop
```bash
docker exec -it arel_for_rails-rails_6-1 bundle exec rubocop
docker exec -it arel_for_rails-rails_7-1 bundle exec rubocop
```
## Generation
Attention - if you want to add tables since db folders are shared, please genereate migrations in rails 6 app (or lowest version if you decide to add such).

### generate app
```bash
docker-compose run --no-deps rails_6 rails new . --force --database=postgresql --api --skip-test
docker-compose run --no-deps rails_7 rails new . --force --database=postgresql --api --skip-test
# rails 8?
```
