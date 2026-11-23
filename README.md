# Enterprise Sales, Pricing & Customer Intelligence Project
### Multi-Tier Commercial Analytics, Demand Elasticity & Customer Retention Analysis

[![Python 3.10+](https://img.shields.io/badge/Python-3.10+-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Power BI](https://img.shields.io/badge/Power_BI-Executive_Dashboard-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![Scikit-Learn](https://img.shields.io/badge/Scikit--Learn-Machine_Learning-F7931E?style=for-the-badge&logo=scikit-learn&logoColor=white)](https://scikit-learn.org/)
[![Pandas](https://img.shields.io/badge/Pandas-Data_Engineering-150458?style=for-the-badge&logo=pandas&logoColor=white)](https://pandas.pydata.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

---

## 📌 Executive Summary

This end-to-end data analytics project examines **60,919 B2B sales transactions** ($81.01M net invoiced revenue) across six operating years (2018–2024) for a multinational cycling manufacturer and wholesale distributor operating in **North America, Europe, and the Pacific**.

By marrying an **Executive Power BI Performance Dashboard** with in-depth **Python Machine Learning & Statistical Modeling** (`Final_Analysis.ipynb`), this repository uncovers critical commercial dynamics:
1. **$60.06M in Commercial Discount Concessions (42.57% Average Markdown)** with no statistically significant elasticity uplift in order sizes.
2. **The 2020–2021 Post-Pandemic Demand Cycle:** Revenue surged to an all-time peak of **$26.48M** in 2021 before entering a severe bullwhip-effect contraction in 2022–2023.
3. **High Account Diversification:** 633 active B2B dealers where the top 214 "Champion" accounts generate $65.16M (80.4%) of top-line revenue.

---

## 📊 Executive Power BI Dashboard

The front-facing operational cockpit delivers real-time visibility into revenue realization, discounting effectiveness, multi-year product trajectories, and regional market penetration.

![Pricing, Promotion & Demand Performance Dashboard](./dashboard_screenshot.png)

### Core Dashboard Modules & Key Visual Findings:

| # | Visual Module | Core Metrics & Analytical Finding |
|---|---------------|-----------------------------------|
| **1** | **Executive KPI Ribbon** | **$81.01M** Net Revenue • **214.52K** Units Sold • **60.92K** Order Lines • **$1.33K** Average Order Value • **42.6%** Weighted Discount Rate • **633** Active Accounts. |
| **2** | **Revenue by Business Segment** | **Bikes** generate **82.5%** ($66.83M) of total revenue, followed by **Components** (**14.6%** / $11.81M), **Clothing** (**2.2%** / $1.80M), and **Accessories** (**0.7%** / $0.58M). |
| **3** | **Discount Elasticity Paradox** | *Deeper Discounts Do Not Clearly Mean Bigger Orders.* Order lines with 40–45% discounts averaged **4.68 units**, whereas order lines with >50% discounts averaged only **3.73 units**, demonstrating trade discount leakage without proportional volume scale. |
| **4** | **Category & Year Heatmap Matrix** | **Road Bikes** ($27.19M total, peaking at $9.34M in 2021) and **Mountain Bikes** ($25.20M total, peaking at $8.29M in 2021) represent the enterprise's flagship volume drivers. |
| **5** | **Multi-Year Macro Cycle** | Annual revenue expanded from **$0.98M** (2018) &rarr; **$9.23M** (2019) &rarr; **$20.76M** (2020) &rarr; peaked at **$26.48M** (2021) before correcting to **$17.56M** (2022) and **$5.88M** (2023). |
| **6** | **Monthly Revenue Mountain Run-Rate** | Visualizes continuous month-by-month demand curve spanning June 2018 to February 2024, highlighting the historical high in **March 2021 ($2.43M monthly billings)**. |
| **7** | **Geographic Market Distribution** | Top 7 markets account for over 85% of volume: **US Southwest** ($18.60M), **Canada** ($14.46M), **US Northwest** ($12.52M), **US Central** ($7.93M), **US Southeast** ($7.91M), **US Northeast** ($6.96M), and **France** ($4.65M). |

---

## 🔬 Python Advanced Analytics & Machine Learning (`Final_Analysis.ipynb`)

Beyond executive visual reporting, the companion Jupyter Notebook performs rigorous statistical inspection, predictive modeling, and customer segmentation across 25 engineered features.

### 1. Data Cleaning & Feature Engineering
* Handled missing attributes (imputed unassigned product colors by category mode).
* Constructed row-level financial metrics: `gross_revenue`, `realized_revenue`, `discount_dollar_leakage`, `discount_pct`, and `days_since_last_order`.
* Structured continuous time-series dimensions for fiscal cohorts and quarterly rolling run-rates.

### 2. RFM Customer Segmentation & 80/20 Pareto Analysis
Customer accounts were classified based on **Recency, Frequency, and Monetary (RFM)** score distributions:
* **Champions (214 accounts / 33.8%):** Generate **$65.16M (80.4%)** of revenue with an average account value of $304.5K.
* **Loyal Accounts (115 accounts / 18.2%):** Generate **$11.60M (14.3%)** of revenue.
* **Potential & At-Risk (304 accounts / 48.0%):** Account for remaining long-tail revenue ($4.25M), representing re-engagement opportunities.

### 3. Annual Cohort Retention Analysis
* Tracks customer loyalty cohorts established in 2018 and 2019 across subsequent operating years.
* **Key Finding:** The 2018 founding dealer cohort maintained an extraordinary **>93% retention rate** through Year 5 (2023), proving exceptional wholesale dealer relationship stability before the post-pandemic industry contraction.

### 4. Unsupervised K-Means Clustering & Predictive Modeling
* **K-Means Clustering (k=4):** Segmented dealers by order cadence, margin sensitivity, and unit velocity into distinct buyer personas.
* **Churn Classifier:** Trained an ensemble classification model predicting wholesale accounts at risk of defection based on inter-order latency and ordering drop-off.
* **Order Quantity Regressor:** Evaluated feature importances influencing purchase volume, validating that list price tier and product category dictate volume significantly more than discount magnitude.

---

## 💡 Key Strategic Business Takeaways

```
┌────────────────────────────────────────────────────────────────────────────┐
│                    STRATEGIC RECOMMENDATIONS FOR LEADERSHIP               │
├────────────────────────────────────────────────────────────────────────────┤
│ 1. IMPLEMENT STRICT DISCOUNT GUARDRAILS                                   │
│    With $60.06M in trade concessions (42.57% avg markdown) failing to    │
│    yield larger orders (>50% discounts yield fewer units than 40-45%),     │
│    sales management must enforce tiered margin floors on halo bike SKUs.  │
│                                                                            │
│ 2. S&OP INVENTORY RE-ALIGNMENT                                            │
│    Post-2021 demand normalized from $26.48M to $5.88M in 2023. Production  │
│    schedules must move away from pandemic peak heuristics toward lead-time │
│    demand forecasting to eliminate working capital write-downs.            │
│                                                                            │
│ 3. PROTECT THE TOP 214 CHAMPION ACCOUNTS                                  │
│    Because 33.8% of customers deliver 80.4% of total enterprise billings,  │
│    a dedicated Key Account Management (KAM) retention incentive structure  │
│    is paramount to insulate revenue against competitor encroachment.       │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Technology Stack

* **Business Intelligence:** Microsoft Power BI Desktop, DAX (Time Intelligence, SPLY, Iterators, Custom Measure Tables).
* **Data Science & ML:** Python 3.10+, Jupyter Notebook, Scikit-learn, Pandas, NumPy, Matplotlib, Seaborn.
* **Data Modeling:** Kimball Star Schema (`Fact_Sales`, `Dim_Calendar`, `Dim_Product`, `Dim_Geography`, `Dim_Customer`).
* **Environment & Versioning:** Git, GitHub, VS Code.

---

## 📂 Repository Structure

```text
├── Final_Analysis.ipynb        # End-to-end Python notebook (EDA, RFM, Cohort, K-Means, ML)
├── dashboard_screenshot.png    # High-resolution screenshot of the Power BI Dashboard
└── README.md                   # Comprehensive project dossier & strategic documentation
```

---

## 🚀 How to Run the Analysis

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Dipali023/Final_Analysis.ipynb.git
   cd Final_Analysis.ipynb
   ```

2. **Set up virtual environment & dependencies:**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install pandas numpy scikit-learn matplotlib seaborn jupyter
   ```

3. **Launch the Notebook:**
   ```bash
   jupyter notebook Final_Analysis.ipynb
   ```

---

## 👤 Author & Contact
* **Analyst:** Dipali
* **GitHub:** [@Dipali023](https://github.com/Dipali023)
* **Focus Area:** Data Analysis, Business Intelligence, Commercial Analytics, Predictive Modeling
