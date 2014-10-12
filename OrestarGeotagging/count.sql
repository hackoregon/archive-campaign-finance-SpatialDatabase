\t
\a
SELECT COUNT(zip) FROM raw_committee_transactions 
WHERE rating IS NULL 
AND addr_line1 IS NOT NULL
AND city IS NOT NULL
AND state IS NOT NULL
AND zip IS NOT NULL;
