# LetsArel
letsarel is an example project demonstrate arel capabilities in rails 3
please take time to familiarlize with the schema
![fileurls](file:///Users/subbarao/experiments/letsarel/doc/models.png)
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
