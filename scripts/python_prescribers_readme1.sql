-- # Which Tennessee counties had a disproportionately high number of opioid prescriptions?
-- # 1. zip -- zipfips 
-- # 2. county -- fipscounty 
-- # 3. drug flag -- drug table
-- # 4. count of prescription-- prescription
-- # 5. state -- prescriber

SELECT * 
FROM prescriber 
LIMIT 1;

SELECT * 
FROM prescription
LIMIT 1;

SELECT * 
FROM drug
LIMIT 1;

SELECT * 
FROM fips_county 
LIMIT 1;

SELECT * 
FROM CBSA
LIMIT 1;

SELECT * 
FROM zip_fips
LIMIT 1;

SELECT --p.drug_name, 
	f.county,
	-- d.opioid_drug_flag,
	--  f.state,
	COUNT(p.drug_name) AS prescription_count
	FROM drug d
LEFT JOIN prescription p
ON p.drug_name = d.drug_name
LEFT JOIN prescriber
ON prescriber.npi = p.npi
LEFT JOIN zip_fips z
ON z.zip = prescriber.nppes_provider_zip5
LEFT JOIN fips_county f
ON f.state = prescriber.nppes_provider_state
AND f.fipscounty = z.fipscounty 
WHERE d.opioid_drug_flag = 'Y'
AND f.state = 'TN'
GROUP BY --p.drug_name,
--	d.opioid_drug_flag,
--	f.state,
	f.county
ORDER BY prescription_count DESC;
