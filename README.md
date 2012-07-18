# LetsArel
letsarel is an example project demonstrate arel capabilities in rails 3
please take time to familiarlize with the schema

![schema](https://github.com/megpha/letsarel/raw/master/doc/models.png)

## Usage
````r  
  rake db:setup
````  
## ActiveRecord Techniques in 3.2

## merge

When you join different tables in active record query 
you will be able to use any scopes defined on any join table
for example longest join we can do in the above model


````  
  Person.joins(collaborations: { movies: { productions: :production_houses } })
````  

lets say i want to know all actors for superhero movies dccomics produced

#### query

````  
  Person.
    joins(collaborations: { movie: { productions: :production_house } }).
    merge(Movie.superhero).
    merge(ProductionHouse.dccomics).
    merge(Collaboration.as_actor)
```` 

#### sql
```` 
  SELECT "people".* FROM "people" 
  INNER JOIN "collaborations" ON "collaborations"."person_id" = "people"."id" 
  INNER JOIN "movies" ON "movies"."id" = "collaborations"."movie_id" 
  INNER JOIN "productions" ON "productions"."movie_id" = "movies"."id" 
  INNER JOIN "production_houses" ON "production_houses"."id" = "productions"."production_house_id" 
  WHERE "movies"."genre" = 'superhero' 
  AND "production_houses"."name" = 'DC Comics' 
  AND "collaborations"."role" = 'actor'
```` 
you can use when you include associations

#### query

````  
Person.
  includes(collaborations: { movie: { productions: :production_house } }).
  merge(Movie.superhero).
  merge(ProductionHouse.dccomics).
  merge(Collaboration.as_actor)
```` 

#### sql
```` 
SELECT "people"."id" AS t0_r0, "people"."first_name" AS t0_r1, "people"."last_name" AS t0_r2,
"people"."created_at" AS t0_r3, "people"."updated_at" AS t0_r4, "collaborations"."id" AS t1_r0,
"collaborations"."movie_id" AS t1_r1, "collaborations"."person_id" AS t1_r2, 
"collaborations"."role" AS t1_r3, "collaborations"."paid" AS t1_r4, 
"collaborations"."created_at" AS t1_r5, "collaborations"."updated_at" AS t1_r6, 
"movies"."id" AS t2_r0, "movies"."title" AS t2_r1, "movies"."budget" AS t2_r2, 
"movies"."revenue" AS t2_r3, "movies"."released_on" AS t2_r4, "movies"."genre" AS t2_r5, 
"movies"."distributor_id" AS t2_r6, "movies"."created_at" AS t2_r7, 
"movies"."updated_at" AS t2_r8, "productions"."id" AS t3_r0, "productions"."movie_id" AS t3_r1,
"productions"."production_house_id" AS t3_r2, "productions"."created_at" AS t3_r3, 
"productions"."updated_at" AS t3_r4, "production_houses"."id" AS t4_r0, 
"production_houses"."name" AS t4_r1, "production_houses"."created_at" AS t4_r2, 
"production_houses"."updated_at" AS t4_r3 FROM "people" 
LEFT OUTER JOIN "collaborations" ON "collaborations"."person_id" = "people"."id" 
LEFT OUTER JOIN "movies" ON "movies"."id" = "collaborations"."movie_id" 
LEFT OUTER JOIN "productions" ON "productions"."movie_id" = "movies"."id" 
LEFT OUTER JOIN "production_houses" ON "production_houses"."id" = "productions"."production_house_id" 
WHERE "movies"."genre" = 'superhero' AND 
"production_houses"."name" = 'DC Comics' AND 
"collaborations"."role" = 'actor'
```` 

but includes uses left outer join joins uses inner join we will discuss
this distiction in later cases.


## except

imagine a case where the merging scope has also happen to have joins
```` 
class Movie < ActiveRecord::Base
  .......
  scope :dccomics, lambda { joins(:production_houses).merge(ProductionHouse.dccomics) }
  ....
end
```` 

#### query

```` 
Person.
  joins(movies: :production_houses).
  merge(Movie.dccomics)
```` 

#### fails with below error
```` 
Person.joins(movies: :production_houses).merge(Movie.dccomics).to_a
ActiveRecord::ConfigurationError: Association named 'production_houses' was not found; perhaps you misspelled it?
from /Users/subbarao/.rbenv/versions/1.9.3-p0/lib/ruby/gems/1.9.1/gems/activerecord-3.2.6/lib/active_record/associations/join_dependency.rb:112:in `build'
```` 
#### why?
merge method combines the joins of the merge and assigns it to the
current scope

```` 
Person.joins(movies: :production_houses).merge(Movie.dccomics).joins_values
=> [{:movies=>:production_houses}, :production_houses]
```` 

but you can not directly join from person to production_houses, you can
only do it through movies which the join is doing.
so production_houses join in the merged scope is wrong.
we need to merge scope without join.

thats where the except method on scope helps

#### fix

```` 
Person.joins(movies: :production_houses).merge(Movie.dccomics.except(:joins)).joins_values
=> [{:movies=>:production_houses}]
```` 

now the combined join looks good for the scope.
#### query
```` 
Person.joins(movies: :production_houses).merge(Movie.dccomics.except(:joins))
```` 
#### sql

```` 
SELECT "people".* FROM "people" 
INNER JOIN "collaborations" ON "collaborations"."person_id" = "people"."id" 
INNER JOIN "movies" ON "movies"."id" = "collaborations"."movie_id" 
INNER JOIN "productions" ON "productions"."movie_id" = "movies"."id" 
INNER JOIN "production_houses" ON "production_houses"."id" = "productions"."production_house_id" 
WHERE "production_houses"."name" = 'DC Comics'
```` 

## only
this is opposite of except method

#### query
```` 
Person.joins(movies: :production_houses).merge(Movie.dccomics.only(:where))
```` 
```` 
SELECT "people".* FROM "people" 
INNER JOIN "collaborations" ON "collaborations"."person_id" = "people"."id" 
INNER JOIN "movies" ON "movies"."id" = "collaborations"."movie_id" 
INNER JOIN "productions" ON "productions"."movie_id" = "movies"."id" 
INNER JOIN "production_houses" ON "production_houses"."id" = "productions"."production_house_id"
WHERE "production_houses"."name" = 'DC Comics'
```` 
