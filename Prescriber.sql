--Q 1. A

SELECT npi, SUM(total_claim_count) AS total_claims
FROM prescription
GROUP BY npi
ORDER BY total_claims DESC
LIMIT 1;

--Q 1. B
SELECT 
    prescriber.npi,
    prescriber.nppes_provider_first_name,
    prescriber.nppes_provider_last_org_name,
    prescriber.specialty_description,
    SUM(prescription.total_claim_count) AS total_claims
 FROM prescription
JOIN prescriber ON prescription.npi = prescriber.npi
GROUP BY 
    prescriber.npi,
    prescriber.nppes_provider_first_name,
    prescriber.nppes_provider_last_org_name,
    prescriber.specialty_description
ORDER BY total_claims DESC
LIMIT 1;

-- Q 2. A
SELECT prescriber.specialty_description, SUM(prescription.total_claim_count) AS total_claims
FROM prescriber 
JOIN prescription ON prescriber.npi = prescription.npi
GROUP BY prescriber.specialty_description
ORDER BY total_claims DESC
LIMIT 1;

--Q 2. B
SELECT prescriber.specialty_description, SUM(prescription.total_claim_count) AS total_claims
FROM prescriber 
JOIN prescription ON prescriber.npi = prescription.npi
JOIN drug ON prescription.drug_name = drug.drug_name
WHERE drug.opioid_drug_flag = 'Y'
GROUP BY prescriber.specialty_description
ORDER BY total_claims DESC
LIMIT 1;

--Q 2. C
SELECT DISTINCT prescriber.specialty_description
FROM prescriber
LEFT JOIN prescription ON prescriber.npi = prescription.npi
WHERE prescription.npi IS NULL;


--Q 2. D Bonus (Holding off)


--Q 3. A
SELECT drug.generic_name, SUM(total_drug_cost) AS total_drug_cost
FROM drug
JOIN prescription ON drug.drug_name = prescription.drug_name
GROUP BY drug.generic_name
ORDER BY total_drug_cost DESC
LIMIT 1;

--Q 3. B 
SELECT drug.generic_name, ROUND(SUM(prescription.total_drug_cost) / SUM(prescription.total_day_supply),2) AS cost_per_day
FROM drug
JOIN prescription ON drug.drug_name = prescription.drug_name
GROUP BY drug.generic_name
ORDER BY cost_per_day DESC;


--Q 4. A
SELECT drug_name,
CASE
    WHEN opioid_drug_flag = 'Y'  THEN 'opioid'
	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	ELSE 'neither'
	END AS drug_type
FROM drug;


--Q 4. B
SELECT 
CASE
    WHEN opioid_drug_flag = 'Y'  THEN 'opioid'
	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	ELSE 'neither'
	END AS drug_type,
	SUM(prescription.total_drug_cost)::MONEY
FROM drug
JOIN prescription ON drug.drug_name = prescription.drug_name
GROUP BY drug_type;

--Q 5. A
SElECT COUNT (DISTINCT cbsa) AS number_cbsas
FROM cbsa
JOIN fips_county ON cbsa.fipscounty = fips_county.fipscounty
WHERE state = 'TN';

--Q 5. B
SELECT cbsa.cbsaname, population.population
FROM cbsa
JOIN population ON cbsa.fipscounty = population.fipscounty
ORDER BY population.population DESC 
LIMIT 1;

SELECT cbsa.cbsaname, population.population
FROM cbsa
JOIN population ON cbsa.fipscounty = population.fipscounty
ORDER BY population.population ASC 
LIMIT 1;

--Q 5. C
SELECT fips_county.county, population.population
FROM fips_county
JOIN population ON fips_county.fipscounty = population.fipscounty
LEFT JOIN cbsa ON fips_county.fipscounty = cbsa.fipscounty
WHERE cbsa.fipscounty IS NULL
ORDER BY population.population DESC
LIMIT 1;


--Q 6. A
SELECT drug_name, total_claim_count
FROM prescription
WHERE total_claim_count >= 3000;

--Q 6. B
SELECT drug.drug_name, prescription.total_claim_count, drug.opioid_drug_flag
FROM prescription
JOIN drug ON prescription.drug_name = drug.drug_name
WHERE total_claim_count >= 3000;

--Q 6. C
SELECT drug.drug_name, prescription.total_claim_count,
drug.opioid_drug_flag, prescriber.nppes_provider_first_name, prescriber.nppes_provider_last_org_name 
FROM prescription
JOIN drug ON prescription.drug_name = drug.drug_name
JOIN prescriber ON prescription.npi = prescriber.npi
WHERE prescription.total_claim_count >= 3000;

--Q 7. A
SELECT prescriber.npi, drug.drug_name
FROM prescriber
CROSS JOIN drug
WHERE prescriber.specialty_description = 'Pain Management' AND prescriber.nppes_provider_city = 'NASHVILLE'
AND drug.opioid_drug_flag = 'Y';

Q 7. B
SELECT prescriber.npi, drug.drug_name, prescription.total_claim_count
FROM prescriber
CROSS JOIN drug
LEFT JOIN prescription ON prescriber.npi = prescription.npi AND drug.drug_name = prescription.drug_name
WHERE prescriber.specialty_description = 'Pain Management' AND prescriber.nppes_provider_city = 'NASHVILLE'
AND drug.opioid_drug_flag = 'Y';

--Q 7. C
SELECT prescriber.npi, drug.drug_name, 
COALESCE (prescription.total_claim_count, 0)
FROM prescriber
CROSS JOIN drug
LEFT JOIN prescription ON prescriber.npi = prescription.npi AND drug.drug_name = prescription.drug_name
WHERE prescriber.specialty_description = 'Pain Management' AND prescriber.nppes_provider_city = 'NASHVILLE'
AND drug.opioid_drug_flag = 'Y'
ORDER BY total_claim_count DESC;