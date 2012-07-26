
[Arel]( https://github.com/rails/arel) is awesome. Here we are going to discuss some of the neat fetures we came across.

To discuss various queries we are going to use bunch of models like `Movie`, `Person`, `Production house` etc. We have created a github repo called [letsarel](http://github.com/bigbinary/letsarel) . Follow the given steps to setup the app so that you can play with query in console.

## Setup local environment

```
git clone git://github.com/bigbinary/letsarel.git
cd letsarel
rake db:setup
```

Now that you are all setup lets get started with lets arel.

Production house `DC Comics` has produced a number of movies. I want to know the names of all actors for `superhero` genre movies belonging to production house `DC Comics`.

So the requirement is

* Get names of actors
* production house == 'DC Comics'
* movie genre == 'superhero'

## First attempt

Here is how I would write the query at first attempt:

```
# query
Person.joins(collaborations: { movie: { productions: :production_house}} ).
  where(collaborations: { role: 'actor' }, movies: {genre: 'superhero' }, production_houses: {name: 'DC Comics'})

# generated sql
SELECT "people".* FROM "people"
INNER JOIN "collaborations" ON "collaborations"."person_id" = "people"."id"
INNER JOIN "movies" ON "movies"."id" = "collaborations"."movie_id"
WHERE "collaborations"."role" = 'actor' AND "movies"."genre" = 'superhero'

# result
[#<Person id: 57213424, first_name: "Christopher", last_name: "Reeve", created_at: "2012-07-25 06:27:23", updated_at: "2012-07-25 06:27:23">]
```

## Using merge

But we are not making use of scopes already defined. Here is another
version that makes use of scopes already defined.

```
Person.
joins(collaborations: { movie: { productions: :production_house } }).
merge(Movie.superhero).
merge(ProductionHouse.dccomics).
merge(Collaboration.as_actor)

# generated sql
SELECT "people".* FROM "people"
INNER JOIN "collaborations" ON "collaborations"."person_id" = "people"."id"
INNER JOIN "movies" ON "movies"."id" = "collaborations"."movie_id"
INNER JOIN "productions" ON "productions"."movie_id" = "movies"."id"
INNER JOIN "production_houses" ON "production_houses"."id" = "productions"."production_house_id"
WHERE "movies"."genre" = 'superhero'
AND "production_houses"."name" = 'DC Comics'
AND "collaborations"."role" = 'actor'

# result
[#<Person id: 57213424, first_name: "Christopher", last_name: "Reeve", created_at: "2012-07-25 06:27:23", updated_at: "2012-07-25 06:27:23">]
```
## Using except

So `merge` is awesome. However if will fail in a few cases. For examples
let's say that I have following scope

```
class Movie < ActiveRecord::Base
  scope :dccomics, lambda { joins(:production_houses).merge(ProductionHouse.dccomics) }
end
```

Now following query will fail.

```
Person.
joins(movies: :production_houses).
merge(Movie.dccomics)

# failure
ActiveRecord::ConfigurationError: Association named 'production_houses' was not found; perhaps you misspelled it?
```

To understand why the query failed you need to understand what method
`joins_values` does.

```
Person.joins(movies: :production_houses).merge(Movie.dccomics).joins_values
=> [{:movies=>:production_houses}, :production_houses]
```

To get rid of extra `:production_houses` you need to use `except`.

```
Person.joins(movies: :production_houses).merge(Movie.dccomics.except(:joins)).joins_values
=> [{:movies=>:production_houses}]
```

So now the final working query will be

```
Person.joins(movies: :production_houses).merge(Movie.dccomics.except(:joins))

# generated sql
SELECT "people".* FROM "people"
INNER JOIN "collaborations" ON "collaborations"."person_id" = "people"."id"
INNER JOIN "movies" ON "movies"."id" = "collaborations"."movie_id"
INNER JOIN "productions" ON "productions"."movie_id" = "movies"."id"
INNER JOIN "production_houses" ON "production_houses"."id" = "productions"."production_house_id"
WHERE "production_houses"."name" = 'DC Comics'
```
