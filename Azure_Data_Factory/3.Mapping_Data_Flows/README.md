
# Azure Data Factory - Copy Activity vs Data Flow Transformations

## 📌 Overview
This README explains the difference between:
- **Copy Activity (Pipeline)**  
- **Mapping Data Flow (Transformations)**  

We use the example of copying **JSON files** from the **Raw container** to the **Cleansed container** and converting them into **CSV format**.

---

## 🚀 1. Copy Activity (Simple Pipeline)

- **Purpose:** Move data from Source → Destination.  
- **Supported Features:**
  - File format conversion (e.g., JSON → CSV, Parquet → Delta).
  - Simple schema mapping.
- **Best For:** Quick data movement without complex logic.

### Example Flow:
1. **Get Metadata Activity** → List JSON files in Raw container.  
2. **ForEach Activity** → Iterate over file list.  
3. **Copy Activity** → Copy each JSON file to Cleansed container in CSV format.  

👉 **What happens?**  
- File is copied as-is, only the format changes from `.json` → `.csv`.

---

## 🔧 2. Mapping Data Flow (Transformations)

- **Purpose:** Perform **complex ETL transformations**.  
- **Runs On:** Azure-managed **Spark clusters**.  
- **Supported Features:**
  - Filter rows
  - Derived columns (calculate new fields)
  - Joins (combine data from multiple sources)
  - Aggregations
  - Conditional split
  - Data cleansing (remove nulls, rename, reformat)

### Example Flow:
1. **Data Flow Source:** Read JSON files from Raw container.  
2. **Transformations:**  
   - Filter out empty records.  
   - Convert date fields into standard format.  
   - Join with Product lookup table.  
   - Keep only records with `Status = "Completed"`.  
3. **Data Flow Sink:** Write final output as CSV in Cleansed container.  

👉 **What happens?**  
- Data is cleaned, filtered, joined, and reshaped before being stored in CSV.

---

## Key Differences between Copy Activity and Data Flows Transformations

| Feature | **Copy Activity** | **Data Flow Transformations** |
|---------|------------------|-------------------------------|
| **Purpose** | Simple copy, schema & format conversion | Full ETL (Extract, Transform, Load) |
| **Transformations** | Limited (column mapping, file format conversion) | Advanced (Filter, Join, Aggregate, Derived Columns, etc.) |
| **Performance** | Lightweight, faster (no Spark cluster) | Heavier, runs on Spark cluster |
| **Use Case** | Just move/convert data | Clean, filter, join, enrich, aggregate |

---

## When to Use

- Use **Copy Activity** if:  
  - You only need to move data between containers/tables.  
  - You just need format conversion (e.g., JSON → CSV).  

- Use **Data Flow Transformations** if:  
  - You need to clean/filter/enrich data.  
  - You need to join with other sources.  
  - You need advanced ETL logic before saving.  

---

## Example Scenarios

- **Copy Activity Only:**  
  Copy `orders.json` → `orders.csv` in Cleansed container.

- **Data Flow Transformations:**  
  - Load `orders.json`.  
  - Remove records with missing `OrderID`.  
  - Join with `products.csv`.  
  - Keep only last 30 days data.  
  - Save output as `orders_transformed.csv` in Cleansed container.


Use case of Mappings Data Flows

![alt text](usecase.png)

Excercise - Load / Read the csv file as it is.
---

- Create data set for source as below and choose .csv file also.

![alt text](dataset-source.png)

- Turn on the Data flow debug which will start spark cluster behind this.

![alt text](start-cluster.png)

- Under the Data Review , Refresh page.

![alt text](refresh.png)




