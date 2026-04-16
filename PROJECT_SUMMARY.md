# Project Summary

## One-line summary
Built a healthcare analytics project to identify high-risk 30-day readmission segments using encounter-level hospital data.

---

## Business Problem
Hospitals need to understand which patient and encounter groups are more likely to be readmitted within 30 days in order to improve discharge planning and reduce costs.

---

## Approach
- Defined a 30-day readmission KPI from encounter data  
- Engineered segmentation features (prior utilization, length of stay, medication count, diagnosis count)  
- Calculated readmission rates across segments  
- Filtered out small groups (n < 500) to ensure reliability  
- Ranked the highest-risk segments  

---

## Key Findings
- Prior utilization was the strongest driver of readmission risk  
- Discharge disposition showed significant variation in outcomes  
- Longer hospital stays were associated with higher readmission risk  
- Age contributed to risk but was weaker than utilization and encounter-level factors  

---

## Business Value
The analysis supports:
- prioritizing follow-up for high-risk patients  
- improving discharge planning  
- targeting care coordination efforts  

---

## Tools
Python (pandas), SQL, Excel, matplotlib, Jupyter Notebook

---

## What this demonstrates
- KPI definition and reporting  
- feature engineering for business segmentation  
- translating data into actionable insights  
- ability to work across SQL and Python  
