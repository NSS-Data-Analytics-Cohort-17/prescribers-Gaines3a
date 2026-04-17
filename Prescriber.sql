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
SELECT
FROM
JOIN
GROUP BY
ORDER BY
LIMIT