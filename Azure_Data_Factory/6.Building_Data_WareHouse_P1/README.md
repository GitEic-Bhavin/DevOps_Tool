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

Building staging tables and data warehouse tables in Azure SQL DB.
---

The tabels in the staging layer are prefixed with schema stage.

We will load the processed file from cleansed container into staging layer in Azure SQL DB.

We will also build the tables for data warehouse

![alt text](dbobject.png)

1. Establish connection to Azure SQL DB via Azure Data Studio and run script `stage.CreateStageScehmaAndTables.Table.sql`. **Build Staging tables into Azure SQL DB**
  - It will create stage tables 
  - securtiy > schemas > stage tables is created

  ![alt text](stagedb.png)

**2. Build data warehouse tables**

  - 2.1 New query > create dimension and facts tables for our data warehouse.
  - Use script `dbo.CreateDimensionsAndFactTables.sql`

  ![alt text](tabledw.png)

Build ADF Pipeline to copy master data files from raw conatiner to cleansed container
---

- Create new pipeline and Add activity Copy for copy master data from raw container to cleansed container

- Create source dataset > Gen2 > CSV

- We will copy all *.csv files using wildcard filepath

- Source > Wildcard FilePath > raw/MasterData and *.csv

- Check the box **Recursively**

![alt text](source.png)

- Add sink settings for File Path as Cleansed > masterdata.

![alt text](sink.png)

**NOTE** - At this time we want to copy the mastertdata CSV file from raw container to cleansed container as CSV file. So, we dont required **Copy Behavior** to transform CSV to txt or txt to CSV.

**Keep Copy Behavior as None**

- Keep File Extensions as *.csv

- The file extension used to name the output files. 

![alt text](fileex.png)

- Run pipeline and view it

- You can see here that all *.csv is copied from raw to cleansed contaier as it is.

![alt text](rccopy.png)

Copy ProductData > 3 *.csv files from Raw container to cleansed container
---

- Create new pipeline for ProductData

- Add source and dataset Binary to copy as binary

- Give File Path as raw / ProductData / *.csv

![alt text](pdsource.png)

- Keep Copy Behavior as None in Sink

![alt text](pdsink.png)

- Run pipeline and varify to cleansed > productdata containers.

![alt text](cpbinarypd.png)

We will learn about Loading files from cleansed containers into the staging tables in Azure SQL DB.
---

`We will loading data using single source datasets and single sink datasets`
`To do this we will use ForEach and metadata activity`

We don't required the metadata activity , we already have a created tabled in sql db for that.

![alt text](metadatasd.png)

- Create dataset for source in New folder 07-Excercise for cleansed container.
- Choose Gen2 and CSV
- Keep blank or leave the file path for container, folder name and file name
- Bcz, we want to configure name of container folder and file name and Delimiter at run time

![alt text](lsource.png)

- Create Parameters Foldername, Filename and Delimiter

![alt text](paramsource.png)

- Assign this parameter into our dataset

![alt text](assingparmds.png)

- Create new dataset for Data warehouse in the SQL DB.

- Choose Azure SQL DB in the dataset
- Create new connections for sql db
- Check the box for Edit manually for we can add dynamically the tablename
- For that we have to create parameter

![alt text](dssqldb.png)

- Create Parameter named `TableName` for sqldb table
- Add this parameter as dynamically as below

![alt text](addparamsqltable.png)

- Here, `stage` is schema

Create metadata pipeline to load the files from cleansed container into the staging tables in sql db.
---

- create new pipeline `pl_LoadStaging_MasterAndProduct` in new folder 08-Excercise

- created dataset for that , we will choose `sql_stage_dynamic` dataset.
- use query > query > Run this query

```sql
select * from dbo.ADF_Metadata where FolderName in ('masterdata', 'productdata')
```

- We already created paremeter `TableName` - It will copy all csv files for `MasterData` and `ProductData` and created a new tables for each files of this 2 folders.

- Thats for we created **TableName** Parameter to handle it dynamically.

- If we doesn't create Parameter we have to create multiple datasets for each files.

📂 cleansed/masterdata/

  currency.csv → load into dimCurrency

  territory.csv → load into dimTerritory

📂 cleansed/productdata/

  products.csv → load into dimProduct

  categories.csv → load into dimCategory

Dataset = "SQLTableDataset"

Parameter = TableName

Behind the scene the query will be like this

```sql
Query in dataset = SELECT * FROM @{dataset().TableName}
```
![alt text](sqlds.png)

- Keep _notSet as value of Parameter TableName and click on Preview

![alt text](Previewsd.png)

**Keep TableName values as _notSet**

1. Dataset parameter has TableName = _notSet (default value)

When you click Preview, ADF does not always substitute that _notSet into SQL.

Instead, ADF says:

“No real value was passed, so I’ll just fetch the first 100 rows using the dataset’s connection (without really using the TableName parameter).”

So it doesn’t run but it will bypass
```sql
SELECT * FROM [_notSet];
```
2. Why does this happen?

ADF pipeline datasets are parameterized, but in preview mode, ADF often ignores unresolved parameters (like _notSet) and just shows sample rows.

_notSet is just a placeholder to keep the dataset valid until you pass a real value at runtime.

Think of it as:

Runtime → TableName must have a real value (like sqltable1).

Design-time preview → ADF says, “I don’t have the actual value yet, so I’ll just try to show something without failing.”

Use ForEach Activity
---

- create ForEach and Go to Settings > items > add dynamically > Choose Get Metadata (Output of Metadata Activity as input) 

- wirte .value

```bash
@activity('Get Metadata').output.value
```

- Add Copy data Activity into this ForEach activity.

- Choose data set we created before, `abs_csv_cleansed_stage_dynamic`

- It will ask to give values of paramters `FolderName`, `FileName` and `Delimiter` by add dynamic.

![alt text](addparmsvalue.png)

- Lets do this for WildCards File Path for cleansed containers FolderName and FileName as  dynamically.

![alt text](adddynamicwc.png)

For Sink Create / Assign Dataset and Parameters
---

If we run this pipeline multiple times every times it will added the all tables data into sql table stage. either it is existing or not.

To prevent from re added the all data , the existing data in sql should be removed

use TRUNCATE TABLE "table_name"

```sql
TRUNCATE TABLE stage.@{item().TableName}
```

- Choose dataset for sql db is `sql_stage_dynamic` we already created for sink

- Give Paramter TableName value as add dynamic 

- **Pre-Copy Script** - To cleanup all talbes in sql db table named **stage** before loding new/existing data. bcz, if we not delete old data in sql and try to load new or updated data it will collaps or appended which can be a repeatadly data

- Use  this script to remove data before load into sql db.

- TRUNCATE TABLE "table_name" - will remove all data inot table named "stage" and @{itme.()} for each ForEach loops for every files in 2 folders `ProductData` and `MasterData`

```sql
TRUNCATE TABLE stage.@{item().TableName}
```

- Run this pipeline and review it.

- Varify that the stage table is updated ?

```sql
--- Varify the stage.currency is updated in sql table.

SELECT TOP (1000) [CurrencyCode], [CurrencyName]
FROM [stage].[Currency]
```

`OutPut`
![alt text](sqldbupdated.png)


**In this pipeline the source and dest schema is almost consistence. so we did not required the transformations of schema.**

Create Pipeline for copy salesdata from cleansed container to sql db staging. each files has diff schemas.
---

In this pipeline, all files have diff shcmas and each store's files will have new data for daily.
For that we required to delete TRUNCATE TABLE query from sink pre-copy script.

- Add Lookup Activity Before GetMetadata Activity to ensure all tables should cleans before loading

- Add dataset for that is sql_dynamic

- Choose query option for that activity and add below things
```sql
TRUNCATE TABLE stage.Arancione_Sales
TRUNCATE TABLE stage.Verde_Sales
TRUNCATE TABLE stage.Celeste_Sales
SELECT count(*) FROM stage.Arancione_Sales
```

- Give Parameter TableName value as _notSet

![alt text](truncate_lookup.png)

- Go to GetMetaData Activity and edit query in settings like below for only for salesdata folder

```sql
select * from dbo.ADF_Metadata where FolderName in ('salesdata')
```

- Preview data for salesdata folder

![alt text](pvsalesdata.png)

- Run this pipeline and see result

Before executed

![alt text](be.png)

After executed

![alt text](ae.png)

Combine data of 3 product table `stage.Arcoine_Product, stage.Verd_Product, stage.caleste_Product` into single table `stage.Product`

- use sql script for that is `usp_LoadStageProduct.sql`

- create new pipeline `pl_LoadStagin_Product` into 08-Excercise

- Add **Store Procedure** Activity and add beloe things

![alt text](storepr.png)

- Run pipeline and see result into state.Product table

![alt text](stagepresult.png)


Combine 3 diff sales table `stage.Arancione_Sales, stage.Celeste_Sales and stage.Verde_Sales` into single table named `stage.Sales`
---

- Run this script `usp_LoadStageSales.sql`

- table will created `dbo.usp_LoadStageSales` into Programability> Stored Procedures

- Use this table into pipeline of store procedure

![alt text](salespscript.png)

- Create new pipeline for store procedure as above we created

![alt text](salesstorepr.png)

- Run pipeline and see result

![alt text](sales-result.png)



