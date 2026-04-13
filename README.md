# 30-Day Readmission Risk Segmentation in US Hospitals

## Project Overview

This project analyzes 30-day hospital readmission risk using a large U.S. inpatient diabetes dataset. The goal was to identify which patient and encounter segments show higher readmission risk and translate those findings into operationally useful insights.

Rather than treating readmission as a modeling problem, this analysis focuses on **KPI construction, risk segmentation, and business interpretation**.

## Business Question

Which patient and encounter segments are associated with the highest 30-day readmission risk, and how can those findings support more targeted hospital follow-up?

## Why This Matters

Thirty-day readmission is a major healthcare performance metric because it affects:

- quality of care
- cost management
- discharge planning
- care coordination

This makes readmission analysis highly relevant for hospital operations, population health, and healthcare analytics roles.

## Dataset

Source: UCI Machine Learning Repository  
Dataset: Diabetes 130-US hospitals for years 1999–2008

The dataset contains over 100,000 inpatient diabetic encounters from 130 U.S. hospitals.

Files used:
- `diabetic_data.csv`
- `IDS_mapping.csv`

## Tools Used

- Python
- pandas
- matplotlib
- Google Colab / Jupyter Notebook

## Analytical Approach

The project was built in five steps:

1. Review and clean encounter-level hospital data  
2. Define the 30-day readmission KPI using the provided readmission label  
3. Engineer business-friendly segmentation features  
4. Compare readmission rates across operational segments  
5. Rank the highest-risk groups and convert findings into recommendations  

## Key Features Engineered

- age band
- prior utilization bucket
- time-in-hospital bucket
- medication count bucket
- diagnosis count bucket
- diagnosis group
- medical specialty group

## Key Findings

- **Prior utilization was the strongest risk signal**  
  Patients with 6+ prior visits had materially higher 30-day readmission rates than lower-utilization groups.

- **Discharge disposition showed strong variation in readmission risk**  
  Some post-discharge pathways were associated with significantly elevated rates.

- **Longer hospital stays were associated with higher readmission risk**  
  This likely reflects increased patient complexity and post-discharge care needs.

- **Age contributed to risk, but was weaker than utilization and discharge-related variables**  
  Age is useful as a segmentation layer, but not the strongest standalone driver.

## Business Recommendations

- Prioritize discharge follow-up for high-utilization patients
- Review discharge planning for higher-risk discharge disposition groups
- Use readmission-risk segmentation to support care coordination workflows
- Combine utilization history, stay length, and discharge information in intervention design

## Visuals

### Readmission Rate by Age Group
![Readmission by Age Group](images/readmission_by_age_group.png)

### Readmission Rate by Time in Hospital
![Readmission by Stay Length](images/readmission_by_stay_bucket.png)

### Readmission Rate by Prior Utilization
![Readmission by Prior Utilization](images/readmission_by_prior_utilization.png)

### Top 10 High-Risk Patient Segments
![Top 10 High-Risk Segments](images/top10_high_risk_segments_improved.png)

## Project Structure

```text
healthcare-readmission-risk-segmentation/
│
├── notebooks/
│   └── readmission_risk_segmentation.ipynb
├── images/
│   ├── readmission_by_age_group.png
│   ├── readmission_by_stay_bucket.png
│   ├── readmission_by_prior_utilization.png
│   └── top10_high_risk_segments_improved.png
├── data/
│   └── data_source.txt
└── README.md

# Project Summary

## One-line summary
Built a healthcare analytics project to identify high-risk 30-day readmission segments using encounter-level hospital data.

## Problem
Hospitals need to understand which patient and encounter groups are more likely to be readmitted within 30 days.

## Approach
Defined a 30-day readmission KPI, engineered operational risk features, compared readmission rates across segments, and ranked the highest-risk groups using a minimum encounter threshold.

## Result
Identified prior utilization, discharge disposition, and longer hospital stays as the strongest readmission risk indicators.

## Business Value
Supports more targeted discharge planning, follow-up outreach, and care coordination.
