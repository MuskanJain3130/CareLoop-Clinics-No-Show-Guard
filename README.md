# CareLoop Clinics — No-Show Guard

Public GitHub Repository: https://github.com/MuskanJain3130/CareLoop-Clinics-No-Show-Guard

## Project Overview

CareLoop Clinics operates eight outpatient clinics across six Indian cities. This project analyses appointment data to understand no-show patterns, identify appointments at higher risk of being missed, and convert call-centre notes into structured reasons that can support better follow-up decisions.

## Four-Part Summary

- **Part 1 – Data Cleaning:** Cleaned 1,020 raw appointment records into 990 usable records, with 20 duplicate rows removed and missing or invalid values handled.
- **Part 2 – SQL Analysis:** Analysed 990 appointments across 8 clinics. Gomti Nagar Care Point in Lucknow had the highest overall no-show rate at 33.3% (30 out of 90 appointments).
- **Part 3 – Machine Learning:** Selected Logistic Regression with a test ROC-AUC of 0.789 and a decision threshold of 0.35; it flagged 49 appointments for follow-up.
- **Part 4 – GenAI Analysis:** Analysed 10 call-centre notes, successfully processing 9 non-blank notes and skipping 1 blank note; the results were structured and cross-tabulated against reminder status.

## Business Recommendation

CareLoop should begin by strengthening its follow-up process for appointments with longer booking lead times, as the no-show rate increased to 60.5% for appointments booked 31 or more days in advance, compared with 16.2% for appointments booked 1–7 days in advance. The clinic-level analysis also identifies Gomti Nagar Care Point as a priority for investigation, with a 33.3% no-show rate across 90 appointments. The Logistic Regression model can help the front desk identify higher-risk appointments the evening before the visit, flagging 49 appointments at the selected 0.35 threshold in the test set. The call-centre notes provide an additional starting point for understanding patient reasons: in the 10-note sample, both notes classified as `forgot_or_no_reminder` had no reminder recorded. CareLoop should therefore review reminder delivery, prioritise suitable high-risk appointments for calls, and investigate transport, scheduling and other barriers with patients. These findings should guide a pilot and further data collection rather than be treated as proof that reminders or any single factor cause no-shows.

## Model Selection

**Selected model: Logistic Regression**

Logistic Regression was selected because it achieved the highest 5-fold cross-validation ROC-AUC among the models compared:

- Logistic Regression: 0.774
- Decision Tree: 0.678
- Random Forest: 0.747
- Tuned Random Forest: 0.767

A threshold of **0.35** was selected using out-of-fold training predictions because it gave a better F1-score and higher recall than the default threshold of 0.5.

At the selected threshold, the final test-set results were:

| Metric | Result |
|---|---:|
| Test ROC-AUC | 0.789 |
| Precision | 0.571 |
| Recall | 0.571 |
| Appointments flagged | 49 |
| Selected threshold | 0.35 |

The threshold should ultimately be adjusted according to the number of follow-up calls the front desk can make and the cost of leaving appointment slots empty.

## Limitations

1. **Small GenAI sample:** Only the first 10 call-centre notes were analysed. This is an illustration and cannot establish the actual reasons for missed appointments across all clinics.
2. **Data leakage during cleaning:** Cleaning statistics such as medians, quartiles and outlier fences were calculated using all 990 rows before the train-test split. In a real deployment, these should be calculated using training data only.
3. **Random train-test split:** The split was random rather than past-to-future, and the same patient may appear in both training and test data. This may make the evaluation less representative of how the model performs on future appointments.

## Project Structure


CareLoop-Clinics-No-Show-Guard/
│
├── data/
│   ├── appointments.csv
│   ├── clinics.csv
│   └── followup_notes.csv
│
├── 01_ingest_clean.ipynb
├── rejected_rows.json
├── appointments_clean.csv
├── clinics_enriched.csv
├── load_data.sql
├── 02_queries.sql
├── 03_model.ipynb
├── test_risk_scores.csv
├── 04_genai.ipynb
├── notes_analysed.csv
└── README.md


## Tools and Technologies

- **Python:** CSV, JSON, Pandas, NumPy
- **Data Analysis:** Data cleaning, exploratory analysis and visualisation
- **SQL:** Joins, aggregations, CTEs, window functions and ranking
- **Machine Learning:** Scikit-learn, Logistic Regression, Decision Tree, Random Forest, cross-validation and threshold tuning
- **GenAI:** Gemini API, structured JSON output and Pydantic validation
- **Environment:** Google Colab

## Conclusion

This project brings together data cleaning, SQL analysis, machine learning and GenAI to support a more proactive approach to appointment management. It provides CareLoop Clinics with a way to identify potentially missed appointments, examine patterns across clinics and booking periods, and organise patient feedback for further action.
