-- Is there an association between rates of opioid prescriptions and overdose deaths by county?
-- 1. opioid prescription - prescription & drug name
-- 2. overdose deaths -  overdose deaths
-- 3. county - fips_county
-- 4. opioid flag - drug

WITH opioid_prescription AS(
	SELECT f.county,
	COUNT(p.drug_name) AS prescription_count
FROM prescription p
LEFT JOIN drug d
ON d.drug_name = p.drug_name
LEFT JOIN prescriber
ON prescriber.npi = p.npi
LEFT JOIN zip_fips z
ON z.zip = prescriber.nppes_provider_zip5
LEFT JOIN fips_county f
ON f.state = prescriber.nppes_provider_state
AND f.fipscounty = z.fipscounty 
WHERE d.opioid_drug_flag = 'Y'
AND f.state = 'TN'
GROUP BY f.county
),
od AS(
SELECT f.county,
	SUM(o.overdose_deaths) AS total_overdose_deaths
FROM overdose_deaths o
LEFT JOIN fips_county f
ON f.fipscounty::INT = o.fipscounty
WHERE f.state = 'TN'
GROUP BY f.county
)

SELECT opioid_prescription.county,
	opioid_prescription.prescription_count,
	od.total_overdose_deaths,
	(od.total_overdose_deaths*100)/NULLIF(opioid_prescription.prescription_count,0) AS percentage_of_opioid_death
FROM opioid_prescription
LEFT JOIN od
ON od.county = opioid_prescription.county
ORDER BY percentage_of_opioid_death DESC;
	--opioid_prescription.prescription_count DESC;

--Ans: No, there is not an association between rates of opioid prescriptions and overdose deaths by county.