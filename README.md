# multiple rails/arel versions
Since arel is in rails, it has become even more "private" API with possibility of breaking changes - lets see how it goes.


# Generation
```bash
docker-compose run --no-deps rails_6 rails new . --force --database=postgresql --skip-javascript --skip-test
```
