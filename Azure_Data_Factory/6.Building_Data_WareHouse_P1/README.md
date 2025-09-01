We will learn about
---

1. Data process for How to bring data into data warehouse
2. Use one approch to build data ware house

Overview of Data Process
---

Data process involves three main steps **Extraction**, **Transformatin** and **Loading**

In building a data warehouse, source data from diff OLTP source systems is integrated into one or more **Staging Area**.

The data is then Scrubbed to address any data quality issue and further processed before being loaded into a data warehouse.

There are few variations in which the Extractions, Transformation and loading is handled.

The Two common approaches are
---

  1. Extract, Transformation and load - ETL and
  2. Extract, Load, Transformations - ELT

![alt text](approaches.png)

What is staging area ?

A **Staging Area** is a temporary storage location where raw data is collected before being transformed and moved into the final data warehouse tables.

**1. ETL**

- There are No Staging tables. Due to it is transform data before loading into db.
- So Transformations will done by ETL Tool such as Informatica, SSIS, Talend etc.
- Transform the data ETL Tool while hitting the source System.

**2. ELT - Better Approach**

- Use Staging Tables. Bcz, Data is loading into db before transformatinos.
- Data is extracted and loaded into a staging area and then it is transformed when it is loaded into the targeted system.
- Transformation is handled by the Target Database Engine.


In short

| Feature            | ETL (Transform before Load)          | ELT (Transform after Load)                 |
| ------------------ | ------------------------------------ | ------------------------------------------ |
| Transform Location | ETL Tool (ADF Data Flow, SSIS, etc.) | Inside Target DW (SQL, Synapse, Snowflake) |
| Staging Area       | Not required                         | Required (staging tables)                  |
| Best for           | Small/medium datasets, legacy DBs    | Large datasets, modern cloud DWs           |
| Speed              | Slower (extra movement)              | Faster (DW engine power)                   |


Overview of ELT Process
---


![alt text](EltProcess.png)

**Step 1** - We will extract the source data and load it without any Transformatinos into Azure Data lake storage Gen2. 

- Extract source files to Raw containers

**Stpe 2** - We will refine the data by cleansing and harmonizing it and loading into the cleansed container.

- In this step, we will also **load the data into Staging layer** in Azure SQL DB.

**Step 3** - We will leverage the target database engine to do some of transformations.

- We will build the dimenstions and facts to build the data warehouse.