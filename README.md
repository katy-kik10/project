# User Retention Analysis (Cohort Analysis) using SQL & Google Sheets

## Project Objective
The goal of this project is to analyze user loyalty and behavior by calculating Retention Rate through Cohort Analysis. The study focuses on comparing the retention patterns between Promo Users (acquired via marketing campaigns) and Organic Users to evaluate acquisition quality and product stickiness.

## Dataset Used
The analysis is based on two relational tables (schema project):

cohort_users_raw: contains user profiles, signup sources, and registration timestamps.  
cohort_events_raw: logs user activities post-registration.  

Challenge: Contains NULL values, spare spaces. Stored in inconsistent date formats with mixed delimiters and varying year lengths. 

## Key Questions
* How does the Retention Rate change over the first 6 months of the user lifecycle?
* Is there a significant difference in retention between users who joined via a promo code versus organic users?
* Which cohorts (by month of registration) show the highest stability in engagement?

## Process
### 1. Data Cleaning & Transformation (SQL)

1. **Date Standardization**: Handled inconsistent date formats (e.g., DD.MM.YYYY, D/M/YY, DD-MM-YYYY) using:
   - TRIM to remove spare spaces;
   - REPLACE to unify date separators;
   - SPLIT_PART to separate the date from the timestamp;
   - LENGHT to define short date formats;
   - TO_DATE to convert cleaned strings into a uniform date format.  

2. **Data Filtering**: Excluded test_event types and records with NULL timestamps or user IDs to ensure data integrity. 

4. **Cohort Logic**:
   - Identified the Cohort Month for each user based on their registration date.
   - Calculated the Month Offset by finding the difference between the event month and the signup month.
    
4. **Aggregation**: Grouped data by promo_signup_flag, cohort_month, and month_offset to count unique users.


### 2. Visualization & Analysis (Google Sheets)
   
1. **Pivot Tables**: Constructed a "Triangle" Cohort Table showing the absolute number of active users.

2. **Retention Matrix**: Created a secondary table calculating Retention Rate.

3. **Interactive Dashboard**: Implemented Slicers for promo_signup_flag to allow dynamic switching between Organic and Promo segments.

4. **Conditional Formatting**: Applied a color gradient to the retention matrix to visually identify "churn points."

## Insights
**Initial Drop-off**: Most cohorts experience the steepest decline in Month 1, which is typical for digital products, but the rate of stabilization varies by source.

**Segment Performance**: Organic users generally demonstrate a higher "long-tail" retention compared to Promo users, who often churn quickly after the initial incentive period.

**Seasonality**: Cohorts joined in early 2025 (e.g., January) showed different engagement levels compared to later cohorts, suggesting changes in acquisition quality or product updates.

## Conclusion
The analysis reveals that while Promo campaigns are effective for rapid user acquisition, Organic users provide higher lifetime value (LTV) due to superior retention. 

To optimize marketing spend, it is recommended to refine the targeting of promo campaigns to attract users whose behavior more closely mirrors the organic segment. 

The established Google Sheets dashboard now serves as a scalable tool for monitoring these KPIs monthly.
