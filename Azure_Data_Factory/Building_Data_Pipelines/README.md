Primary components to build data factory projects are **Pipeline, activities and linked services, data sets, integrations, runtime and triggers**.

![alt text](comp.png)

**Activity** - Activities are individual steps inside a pipelines.
There are 3 types of activity

1. data movement - copy data from source to sinc/dest
2. data transformations - change data like filetering, aggregating, modifying the formate etc
3. data control - Provide logical control like doing specific action based on a conditions or performing an action for number of times.

We can control this pipeline using **Triggers**

![alt text](activity.png)

**Open Azure Data factory**

- Click on Pipeline and serch for `set variable` and drag and drop it.
- Go to Settings > Add variable name as variable1
- Give var value as `Hello ADF`

![alt text](setvarpipe.png)

**Debug** - Run this query pipeline and not save your changes.
**Triggers** - You can add triggers to run this pipeline. This will run only saved changes by Publish all.
**Publish all** - Will save your changes to data factory repository like gir repo. For data factory repository you have a repo in Azure DevOps or Git repo.
After that other users can see your new changes after publish. It is like git commit and push.

After Debug run pipeline you can see its result.

![alt text](debug.png)

After Publish all

![alt text](afterpublish.png)

**NOTE**

`1. Without Git integration`

- If you didn’t connect ADF to Git/Azure DevOps repo, then “Publish All” directly saves your pipelines, datasets, linked services, etc. to the live Data Factory service (adf_publish branch in backend storage).

**That means:**

  - The JSON of your pipeline is stored inside ADF’s managed repo (hidden in Azure).

  - You won’t see a Git branch, but ADF keeps the published JSON definitions in its internal storage (Azure blob under the hood).

  - Only the latest published version is available; you don’t have version history like Git.

`2. With Git integration (Azure Repos / GitHub)`

  - While editing, your changes are first saved as draft in Git branch.

  - “Publish All” takes the validated JSONs and writes them into a special branch called adf_publish.

  - The ADF runtime (triggers, scheduled runs, manual runs) only uses the adf_publish branch to execute pipelines.

## Basic Process in Data Ingest , Store/Process, Enrich Layer

- We have Data lake storage Gen2 to store the data from data sources.
- It have 4 contianers.

1. Landing container - Stores Zip files
2. Raw container - Unzipped file stores and file organized in folder by stores.
3. Cleansed container - Cleansed the raw data to ensure to Stores Unique data only and removed duplicates.

4. Curated container

  - Add business rules (e.g., Profit = Amount – Cost)
  - Group by Month, City, Product Category
  - Summarize → Total Sales per City per Month

![alt text](DataIngest-to-Enrich.png)

Create Pipeline for Copy data from source to Landing container
---

1. Create Data lake Gen2 Storage Account type by enable **Hierarchical Namespace** as below

![alt text](Createdatalake.png)

- Create container named landing and raw

- Connect Storage account via Azure storage explorer.
- Upload sampledata.zip file to landing contianer

![alt text](data-to-landing.png)

Create pipeline to copy zip fril from landing and unzip to raw container.
---

- Go to ADF and click on Ingest

![alt text](ingest.png)

- You want to copy one time by pipeline. so choose **Built-in copy task** and **Run once now**.

![alt text](copydatapipe.png)

- Choose Source as Data lake storage Gen2 account

- Create New connections where we can define Storage account cred.

![alt text](newconnections.png)

- Once Test is successful you can create new connections.

- Browse the zip file from landing containers.

![alt text](browsefileland.png)

- Select **Binary copy** will copy all files as it is.

- Select **ZipDeflate (.zip)** will ensure that .zip will be unzipped.

- UnCheck **Preserve zip file name as folder** will ensure that after unzip the folder name will not as zip folder.

- Go to Destinations and select destination as **Raw container**.

![alt text](destraw.png)

- Leave other setting as it is.

- Settings > Give your pipeline name.

![alt text](pipelinename.png)

- Review and create.

![alt text](review.png)

- Click on monitor for get information about pipelines.

![alt text](monitor.png)

- See details of pipeline by monitor

![alt text](detailmonitor.png)

- **Is data are unzipped to Raw Container ?**

- Go to Gen2 > container > raw container

![alt text](rawunzip.png)

Importing data using copy activity
---

- Create cleansed container
- Create salesdata folder in this cleansed container

- This pipeline will copy data from  raw container to cleansed container's salesdata folder

- Choose **Recursively** will ensure copy all folders.

![alt text](recursively.png)

- Give source path as raw > Arancione/.

![alt text](broseraw.png)

- Keep default all configuration and make sure Check the box for **First row as header** 

![alt text](firstrow.png)

- Go to Destinations > Browse for Cleansed > salesdata and leave other settings as it is.

![alt text](destcleansed.png)

- Go to Destinations Conf. and make sure Check the box for **Add header to file** which will formate the each files

![alt text](destconf.png)

- Go to settings and give pipeline name

![alt text](cleansedsettings.png)

- Review and finish and monitor details for same.

![alt text](cleanseddetail.png)

- Look into cleansed container

![alt text](datacleansed.png)

