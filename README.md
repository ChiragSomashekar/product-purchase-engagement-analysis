# Product Analytics: Time to Conversion Behavior

## Goal
Understand how long it takes users to complete a purchase after first arriving on the website on a given day, and identify behavioral patterns that influence decision speed.

## Business context
The Product Manager wanted to understand **purchase decision speed** on the e-commerce platform: 

- How long does it take a typical user to complete a purchase after first visiting the site?
- Where do users hesitate in the purchase journey?
- Are delays driven by browsing behavior, checkout friction, or outlier sessions?

This analysis helps evaluate **funnel efficiency**, identify **friction points**, and inform **product and checkout optimizations**.

## Data
- **Source:** `project-477112.raw_events` (event-level website tracking)
- **Time period:** Nov 2020 - Jan 2021
- **Constraints:**
  - No persistent session identifiers.
  - Inconsistent tracking for some funnel events (e.g. `add_to_cart`)
  - Analysis limited to **same-day behavior** (first visit → first purchase)

## Methodology
### 1. Time-to-purchase modeling (SQL)
- Identified each user's **first visit of the day** (`session_start`)
- Identified each user's **first purchase on the same day**
- Calculated **minutes to purchase** as the difference between the two timestamps
- Aggregated results **daily**, using:
  - **Average** (captures overall load and long sessions)
  - **Median** (reduces the impact of outliers)

### 2. Funnel progression (event-based)
- Modeled funnel steps using **user-level event flags**
  - `view_item`
  - `begin_checkout`
  - `add_payment_info`
  - `purchase`
- Each user counted **once per step**
- `add_to_cart` excluded due to missing or inconsistent tracking
- Conversion rates calculated **across the full period** (not session-based)

### 3. Visualization
- Results visualized using **Tableau**

## Key findings
- **Most shoppers decide quickly**
  - ~65% of purchases occur within **30 minutes**
  - Median time to purchase remains stable at **~15-17 minutes**
- **Browsing does not equal intent**
  - Only **~15% of users who view products begin checkout**
  - Sharpest drop occurs **after browsing**
- **Checkout is the main hesitation point**
  - Longest delay occurs between **cart and checkout**
  - Once payment info is added, completion rates are high
- **Averages fluctuate, medians remain stable**
  - Long sessions inflate averages
  - Median behavior shows consistent user intent

## Insights & recommendations
- **Focus on pre-checkout friction**
  - The biggest opportunity lies before checkout, not during payment
- **Support fast decision-makers**
  - Many users arrive with intent, reduce steps to purchase.
- **Reduce hesitation signals**
  - Surface shipping costs, delivery timelines and trust signals earlier
- **Test product page improvements**
  - Run A/B tests on product pages and checkout entry points
  - Measure impact on time-to-purchase and conversion speed

### Limitations
- Missing or inconsistent tracking for some funnel events limits precision
- Lack of session identifiers prevents deeper browsing-depth analysis
- Same-day analysis does not capture long consideration cycles
- Results are **directional**, not causal

## Deliverables
- **Slides:** Executive presentation with visual analysis [slides](`slides`)
- **SQL:** Queries used for time-to-purchase and funnel modeling [sql](`sql`)
