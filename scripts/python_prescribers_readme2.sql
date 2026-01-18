-- Who are the top opioid prescibers for the state of Tennessee?
-- 1. prescribers name-- prescribers join prescription on npi
-- 2. opioid flag -- drug
-- 3. drug name - drug
-- 4. drug name - prescription join drug



SELECT CONCAT(prescriber.nppes_provider_first_name, ' ', prescriber.nppes_provider_last_org_name)
	AS Provider_Name,
	--drug.drug_name,
	SUM(prescription.total_claim_count) AS precription_count
FROM prescriber
LEFT JOIN prescription 
ON prescription.npi = prescriber.npi
LEFT JOIN drug
ON drug.drug_name = prescription.drug_name
WHERE drug.opioid_drug_flag = 'Y'
AND nppes_provider_state = 'TN'
GROUP BY Provider_Name
	--drug.drug_name
ORDER BY precription_count DESC
LIMIT 10;
