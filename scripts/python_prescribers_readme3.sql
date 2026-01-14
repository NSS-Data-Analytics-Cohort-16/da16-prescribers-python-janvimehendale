-- What did the trend in overdose deaths due to opioids look like in Tennessee from 2015 to 2018?
-- 1. count of overdose death - overdose_deaths
-- 2. year = 2015 to 2018 - overdose_deaths
-- 3. state = TN - fipscounty
-- 4. fipscounty - overdose_deaths and fipscounty
-- 5. county name - fipscounty

SELECT o.year,
	SUM(o.overdose_deaths) AS Total_overdose_deaths
	--f.county
FROM overdose_deaths o
LEFT JOIN fips_county f
ON f.fipscounty::INT = o.fipscounty
WHERE year BETWEEN 2015 AND 2018
AND f.state = 'TN' -- same results without JOIN, however adding JOIN to make sure it is just for TN
GROUP BY o.year
		--f.county
ORDER BY o.year;

--Answer : Overdose deaths due to opioids kept increasing every year.