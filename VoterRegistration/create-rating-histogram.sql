DROP TABLE IF EXISTS voter_reg.rating_histogram CASCADE;
CREATE TABLE voter_reg.rating_histogram AS
  SELECT rating, COUNT(rating) AS number
  FROM voter_reg.addresses
  GROUP BY rating
  ORDER BY rating;
\copy (select * from voter_reg.rating_histogram) to 'rating_histogram.csv' (format csv, header);
