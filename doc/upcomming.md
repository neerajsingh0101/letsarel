# Left Outer Join ActiveRecord

includes on scope eager loads the given associations

````
Person.by_name("brad").includes(:movies)
SELECT "people".* FROM "people" 
WHERE (("people"."first_name" LIKE '%brad%' OR "people"."last_name" LIKE '%brad%'))
SELECT "collaborations".* FROM "collaborations" 
WHERE "collaborations"."person_id" IN (289834744)
SELECT "movies".* FROM "movies" WHERE "movies"."id" IN (552238307)
````

but if any of the eager loaded association is used in the query join
used in the query changed from inner join to left outer join

````
Person.by_name("brad").includes(:movies).merge(Movie.drama)
SELECT "people"."id" AS t0_r0, "people"."first_name" AS t0_r1, 
"people"."last_name" AS t0_r2, "people"."created_at" AS t0_r3, 
"people"."updated_at" AS t0_r4, "movies"."id" AS t1_r0, 
"movies"."title" AS t1_r1, "movies"."budget" AS t1_r2, 
"movies"."revenue" AS t1_r3, "movies"."released_on" AS t1_r4, 
"movies"."genre" AS t1_r5, "movies"."distributor_id" AS t1_r6, 
"movies"."created_at" AS t1_r7, "movies"."updated_at" AS t1_r8 
FROM "people" LEFT OUTER JOIN 
"collaborations" ON "collaborations"."person_id" = "people"."id" 
LEFT OUTER JOIN "movies" ON "movies"."id" = "collaborations"."movie_id" 
WHERE "movies"."genre" = 'drama' 
AND (("people"."first_name" LIKE '%brad%' OR "people"."last_name" LIKE '%brad%'))
````
