# LetsArel
letsarel is an example project demonstrate arel capabilities in rails 3
please take time to familiarlize with the schema

![schema](https://github.com/megpha/letsarel/raw/master/doc/models.png)

## Usage
````r  
  rake db:setup
````  
## ActiveRecord Techniques in 3.2

### merge

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
