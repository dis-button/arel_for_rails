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
```
# usefull comands
### containers bash:
```bash
docker exec -it arel_for_rails_rails_7_1 /bin/bash
```
### rails console:
```bash
docker-compose exec arel_for_rails_rails_7_1 rails c
```

