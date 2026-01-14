-- Is there any association between a particular type of opioid and number of overdose deaths?
-- 1. drug name - drug & prescription
-- 2. opioid flag - drug
-- 3. overdose deaths - overdose_deaths
-- 4. fipscounty - overdose_deaths and zip_fips
-- 5. zip - zipfips & prescriber


--SELECT sum(overdose_deaths) 
--FROM overdose_deaths
--LIMIT 1;

WITH opioid_type AS(
	SELECT d.drug_name,
		d.generic_name,
		prescriber.nppes_provider_state AS states,
		z.fipscounty
	FROM drug d
LEFT JOIN prescription p
ON p.drug_name = d.drug_name
LEFT JOIN prescriber 
ON prescriber.npi = p.npi
LEFT JOIN zip_fips z
ON z.zip = prescriber.nppes_provider_zip5
WHERE opioid_drug_flag = 'Y'
GROUP BY d.drug_name,
	d.generic_name,
	z.fipscounty,
	prescriber.nppes_provider_state
),
odd AS (
	SELECT opioid_type.drug_name,
		opioid_type.generic_name,
		SUM(o.overdose_deaths) AS total_overdose_deaths
FROM opioid_type
--LEFT JOIN fips_county f
--ON f.fipscounty::INT = opioid_type.fipscounty::INT
--AND f.state = opioid_type.states
LEFT JOIN overdose_deaths o
ON o.fipscounty::INT = opioid_type.fipscounty::INT
GROUP BY opioid_type.drug_name,
	opioid_type.generic_name
)
SELECT * 
FROM odd
WHERE total_overdose_deaths IS NOT NULL
ORDER BY total_overdose_deaths DESC;