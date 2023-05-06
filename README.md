# adbm-crypto-database-project

Cryptocurrency Database

A Relational Database (with the possibility of adding a non-relational database as well) on cryptocurrency data that allows for understanding the cryptocurrency market data on a deeper level. The ER Diagram below shows a more detailed description of the database and the content:

![Database ER diagram - Cryptocurrency](https://user-images.githubusercontent.com/101132853/230144423-a5f32e26-71fb-4578-91f1-eda8a7fd3441.png)


The project will be completed in 4 phases:

Phase 0: Discuss the project and what the database will look like, what kinds of data it will contain, what would be the purpose of the database, etc.
Deadline: 03/20/2023							Finished: 03/20/2023

Phase 1: Collecting and cleaning the data, which requires scraping, statistical analysis, and manually collecting the data.
Deadline: 04/02/2023								Finished: 

Phase 2: Create the relational database regarding the ER Diagram above (or any updated version after Phase 1).
Deadline: 04/08/2023								Finished: 

Phase 3: Create an interactive website for the database using CSS and HTML.
Deadline: 04/23/2023								Finished: 

All members will be contributing to all phases of the project.

Group Members:
1.	Ali Sadeghinia
2.	Brooke Harris
3.	Sai Pramod Kantheti
4.	Sai Vinay Thattukolla

![MicrosoftTeams-image](https://user-images.githubusercontent.com/101132853/233867837-aab09af8-5ec1-48e1-83a4-9875885f342b.png)




UPDATED ER DIAGRAM:


![Final ER Diagram](https://user-images.githubusercontent.com/101132853/235190443-ecd39deb-e06f-4e14-babe-04d984c2ec19.png)













<a name="_jkirgjxeb5c9"></a><a name="_yvtrnbr3xd09"></a><a name="_6cjeiusmop1q"></a><a name="_y6q7le94kuky"></a><a name="_u7ktz28kcwmi"></a><a name="_eop5photql89"></a>**Final Project - Cryptocurrency Database Project**

<a name="_9h79iyy4sbaa"></a>Advanced Database Management

<a name="_c2bx7gmn3lx6"></a>Group Members: Ali Sadeghinia, Brooke Harris, Sai Pramod Kantheti, Sai Vinay Thattukolla


# <a name="_pnewftydb1vs"></a>**Executive Summary**
The topic of our database for the final project is cryptocurrencies. The information in the database includes the top 100 cryptocurrencies and their market information, a top cryptocurrency holder list for the principal shareholders of the top cryptocurrencies, their wallet information, and whitepapers related to cryptocurrencies. 

This report covers database design, query writing, performance tuning, and data visualization. 


|**Topic Area**|**Description**|**Points**|
| :- | :- | :- |
|Database Design|Overview of database design, integrity constraints, ER diagram, high-level overview diagram, data generation, and implementation-level issues|25|
|Query Writing|SQL queries and experiments in the database|30|
|Performance Tuning|Indexing strategies and experiments; discussion of caching implementations |20|
|Other Topics|Data visualization with Power BI|25|

# <a name="_sb5cbqvt6222"></a>
# <a name="_tdlq94t4ykxi"></a>**Part 1: Database Design**
The following is the ER diagram for the cryptocurrency database. 

**The following tables are dimension tables:**

1. DIM\_WALLET
1. DIM\_EXCHANGE
1. DIM\_TEAM
1. DIM\_TICKER
1. DIM\_WHITEPAPER
1. DIM\_TEAM\_MEMBER

**The following tables are fact tables:** 

1. RICH\_LIST
1. EXCHANGE\_WALLET
1. WALLET\_TICKER
1. EXCHANGE\_DATA
1. MARKET\_DATA

There is also one view that includes the calculated values of kurtosis and skewness: **VW\_CRYPTO\_KURT\_SKEW**. 

The main table of the database would be **DIM\_TICKER** which is integral to the entire database. This table gives us the name and descriptions of all cryptocurrencies used in the database. **TICKER\_ID** is a foreign key in many tables, including **WALLET\_TICKER**, **EXCHANGE\_DATA**, **DIM\_TEAM**, **DIM\_WHITEPAPER**, and **MARKET\_DATA**.  


A high-level diagram of the database is shown below. Team Members and Exchange Wallets are considered weak entities since they would not exist without their parent tables. Kurtosis and skewness are derived attributes and calculated within the database view, **VW\_CRYPTO\_KURT\_SKEW**. Market Data is considered an attribute of cryptocurrency. 



## <a name="_egyoa4qt7a"></a>Section 1.1: Data Dictionary
The data dictionary manually created would look like a table similar to ours below:


|**COLUMN\_NAME**|**DATA\_TYPE**|**NULLABLE**|**CONSTRAINT**|**DESCRIPTION**|
| :- | :- | :- | :- | :- |
|**TICKER\_ID**|NUMBER(22,0)|NO|PK|Generated unique IDs for each Ticker/cryptocurrency|
|**TICKER\_SYMBOL**|VARCHAR2(6 BYTE)|YES|Not Null|Scraped with MARKET\_DATA and is a unique str|
|**NAME**|VARCHAR2(25 BYTE)|YES|Not Null|Cryptocurrency Name that is a unique str|
|**DESCRIPTION**|VARCHAR2(50 BYTE)|YES|Not Null|Column to add extra information about the cryptocurrency and the data if needed|
|**RANK**|NUMBER(22,0)|YES|Not Null|Cryptocurrencies’ rankings based on their market cap at the time (can be changed without affecting other tables and variables)|

However, some queries can be executed to give you a data dictionary for any table in the database. As an example, we are going to use the same table as above, which is **DIM\_TICKER**:

SELECT column\_name,

`       `data\_type,

`       `data\_length,

`       `nullable

FROM   user\_tab\_columns

WHERE  table\_name = 'DIM\_TICKER'; 



To also see what the constraints used within this table, we can run the following query:

SELECT cols.table\_name,

`       `cols.column\_name,

`       `cols.data\_type,

`       `cons.constraint\_name,

`       `cons.constraint\_type

FROM   all\_tab\_columns cols

`       `INNER JOIN all\_cons\_columns col\_cons

`               `ON cols.owner = col\_cons.owner

`                  `AND cols.table\_name = col\_cons.table\_name

`                  `AND cols.column\_name = col\_cons.column\_name

`       `INNER JOIN all\_constraints cons

`               `ON col\_cons.owner = cons.owner

`                  `AND col\_cons.constraint\_name = cons.constraint\_name

WHERE  cols.owner = 'SQL901'

`       `AND cols.table\_name = 'DIM\_TICKER'; 



However, these could also be executed manually with the IDE of use and the features they provided.
## <a name="_cjmg8yclquan"></a>Section 1.2: Data Integrity
The **DIM\_TICKER** table is one of the tables integral to the database. The primary key and non-nullable value is **TICKER\_ID**. This is a sequenced primary key that starts at 10001. The **TICKER\_SYMBOL** are essentially the “stock market” tickers for each cryptocurrency - such as Bitcoin is BTC, BinanceCoin is BNB, and Dogecoin is DOGE. These will only consist of a few letters; the longest in our database is five letters (such as MATIC). 


|**COLUMN\_NAME**|**DATA\_TYPE**|**NULLABLE**|**COLUMN\_ID**|
| :- | :- | :- | :- |
|**TICKER\_ID**|NUMBER(38,0)|NO|1|
|**TICKER\_SYMBOL**|VARCHAR2(6 BYTE)|YES|2|
|**NAME**|VARCHAR2(25 BYTE)|YES|3|
|**DESCRIPTION**|VARCHAR2(50 BYTE)|YES|4|
|**RANK**|NUMBER(38,0)|YES|5|

Integrity constraints can be used to improve the accuracy and security of our database. The first one that can be implemented is a unique public key constraint in the **DIM\_WALLET** table. **WALLET\_GUID** should be set to a unique public key constraint since every user will have a unique key that is used for their wallets so that people can transfer cryptocurrency in and out of the wallet. 

ALTER TABLE dim\_wallet

`  `ADD CONSTRAINT uq\_wallet\_guid UNIQUE(wallet\_guid); 

Another integrity constraint would be applied to **HOLDINGS\_CRYPTO** in the **RICH\_LIST** table. This should always be a non-negative number, as a wallet should never be negative. 

ALTER TABLE rich\_list

`  `ADD CONSTRAINT chk\_holdings\_crypto\_nonnegative CHECK (holdings\_crypto >= 0); 

This should also be applied to the **TOKEN\_BALANCE** in the **EXCHANGE\_DATA** table. 

ALTER TABLE exchange\_data

`  `ADD CONSTRAINT chk\_token\_balance\_nonnegative CHECK (token\_balance >= 0); 

Non-negative constraints should also be placed on **FILESIZE** and **WORDCOUNT** within the **DIM\_WHITEPAPER** table. 

ALTER TABLE dim\_whitepaper ADD CONSTRAINT chk\_filesize\_nonnegative CHECK (filesize >= 0),

`            `add CONSTRAINT chk\_wordcount\_nonnegative CHECK (wordcount >= 0);
## <a name="_lvu7wkcfwr98"></a>Section 1.3: Data Generation and Loading
The data for this database was gathered from multiple different sources. However, the majority of the data was scraped from [CoinCarp](https://www.coincarp.com/). We used four different methods to acquire the data:

1. To scrape the market data, we used the following R script: 

<https://github.com/alisdghnia/adbm-crypto-database-project/blob/main/ADBMS%20data.R>

1. We used a scraping application to scrape the rest of the data, such as **RICH\_LIST** and **EXCHANGE** data.
1. For the **WHITEPAPER** data, we used Python scripts to scrape the documents and extract the information, such as **WORD\_COUNT**, **FILE\_SIZE**, **READABILITY SCORES**, etc. We also used a variety of libraries in Python (<https://github.com/alisdghnia/Crypto-Whitepaper-Research>).
1. Lastly, due to time constraints, we looked up some of the data online, such as **TEAMS** and manually entered them into our tables using Microsoft Excel (as an expansion to this project, we encourage other groups to find ways to collect more data on this side as we currently have less than 20 rows of data recorded for the **TEAM\_MEMBERS**)

Once the data were scraped from the websites, we used Python to clean the datasets, prepare them for the database (splitting datasets into multiple datasets to abide by the normalization rules), and lastly, generate IDs for each of the important variables that would become our primary and foreign keys.



The approach we used to prepare the data was to create the **DIM\_TICKER** table first, then continue with each branch separately to create the rest of the tables. While you can access the different Jupyter Notebooks used to prepare all the tables on the GitHub repository provided, the preparation of the **DIM\_TICKER** can be found in the link below:

<https://github.com/alisdghnia/adbm-crypto-database-project/blob/main/DIM_TICKER.ipynb>



Once the tables were created, we used the DataGrip application to create the database based on our ER Diagram. For the ER Diagram, we went through multiple iterations of updating and resolving issues with the normalization of the database. The first draft that we came up with at the beginning of the semester can be found below:


Our final updated ER Diagram can be found below:



The queries that were generated through DataGrip for the tables and their constraints can be found on the GitHub repo, but as an example, the following query is what was used for the DIM\_TICKER table:

CREATE TABLE dim\_ticker

`  `(

`     `ticker\_id     *NUMBER* NOT NULL CONSTRAINT "DIM\_TICKER\_pk" PRIMARY KEY,

`     `ticker\_symbol *VARCHAR2*(6),

`     `NAME          *VARCHAR2*(25),

`     `description   *VARCHAR2*(50),

`     `rank          *NUMBER*

`  `) 
### <a name="_pq8559erlqw9"></a>Sneak Peak
We also knew beforehand that **TICKER\_SYMBOL** would most likely be common in the queries that might be run to extract information; therefore, we decided to make that an **INDEX** using the following query:

CREATE INDEX "DIM\_TICKER\_TICKER\_SYMBOL\_index"

`  `ON dim\_ticker (ticker\_symbol) 
## <a name="_l8j0ti201sr6"></a>Section 1.4: Physical Database Design
The aspect of the database that takes up the most space is the whitepapers. In our “test” database, there are no whitepapers saved, but there are a few ways that this can be accomplished. We can use URLs within the database to link out, but we would have to be concerned with both the length of the data in that column and if the links end up expiring or going bad (unless they are hosted somewhere that is not reliant upon other websites). Stemming off of that idea is to store copies of them within a server and link to them that way. The column would then store less data, but the other issue would be the actual space to host the whitepapers. 
# <a name="_u1lilgsvfs"></a>
# <a name="_b0kouvms1t3h"></a>**Part 2: Query Writing**
1. What is Bitcoin’s market cap?

SELECT market\_cap\_usd,

`       `NAME,

`       `ticker\_symbol

FROM   market\_data

`       `INNER JOIN dim\_ticker DT

`               `ON market\_data.ticker\_id = DT.ticker\_id

WHERE  DT.NAME = 'Bitcoin' 



Alternatively, we can use the **LOG** Function to get the base 10 log of the market cap value to make the value more readable.

SELECT *Log*(10, market\_cap\_usd),

`       `NAME,

`       `ticker\_symbol

FROM   market\_data

`       `INNER JOIN dim\_ticker DT

`               `ON market\_data.ticker\_id = DT.ticker\_id

WHERE  DT.NAME = 'Bitcoin' 



Additionally, to make the result of this query even more readable, we can use the **ROUND** Function to limit the number of decimals shown in the results are limited to 2 with the following query:

SELECT *Round*(*Log*(10, market\_cap\_usd), 2),

`       `NAME,

`       `ticker\_symbol

FROM   market\_data

`       `INNER JOIN dim\_ticker DT

`               `ON market\_data.ticker\_id = DT.ticker\_id

WHERE  DT.NAME = 'Bitcoin' 



Only one decimal is shown in the table above because the rounded values of the numbers behind the first decimal are rounded to 10. Therefore, the results came out with 11.6, which is basically 11.60. Lastly, we can also change the column name by adding a name after the corresponding column in the **SELECT** part of the query:

SELECT NAME,

`       `ticker\_symbol,

`       `*Round*(*Log*(10, market\_cap\_usd), 2) MarketCap\_log10

FROM   market\_data

`       `INNER JOIN dim\_ticker DT

`               `ON market\_data.ticker\_id = DT.ticker\_id

WHERE  DT.NAME = 'Bitcoin'; 



1. To conduct my due diligence, research the top holders of the cryptocurrencies to make sure there are no ‘Whales’ that could negatively impact my investment and show me the wallet GUIDs of the top 10 holders for each of the cryptocurrencies (based on the amount they are holding and the percentage of the total amount available).

SELECT \*

FROM   (SELECT wallet\_guid,

`               `NAME,

`               `ticker\_symbol,

`               `holdings\_percent,

`               `**Row\_number**()

`                 `OVER (

`                   `partition BY DT.ticker\_symbol

`                   `ORDER BY RL.holdings\_percent DESC) AS rn

`        `FROM   rich\_list RL

`               `INNER JOIN dim\_wallet DW

`                       `ON DW.wallet\_id = RL.wallet\_id

`               `INNER JOIN wallet\_ticker WT

`                       `ON DW.wallet\_id = WT.wallet\_id

`               `INNER JOIN dim\_ticker DT

`                       `ON WT.ticker\_id = DT.ticker\_id)

WHERE  rn <= 10

ORDER  BY ticker\_symbol,

`          `holdings\_percent DESC 



1. To dive deeper into my research on these cryptocurrency top-holders, I would like to know some statistical facts about the top 100 holders of each cryptocurrency. Can you create a calculated function and use it to create a VIEWS table so that it can automatically update these values?

In this case, we will use **VIEWS** to calculate Kurtosis and Skewness for each cryptocurrency. This way, the values will be automatically updated every time the **RICH\_LIST** table is updated.

**FOR KURTOSIS & SKEWNESS CALCULATIONS USING THEIR RESPECTIVE FORMULAS:**

WITH avg\_table

`     `AS (SELECT wt.ticker\_id,

`                `*Avg*(rl.holdings\_percent) AS Holding\_Percent\_Avg

`         `FROM   rich\_list rl

`                `INNER JOIN wallet\_ticker wt

`                        `ON rl.wallet\_id = wt.wallet\_id

`         `GROUP  BY wt.ticker\_id),

`     `temp

`     `AS (SELECT at1.ticker\_id,

`                `wt.wallet\_id,

`                `holding\_percent\_avg

`         `FROM   avg\_table at1

`                `INNER JOIN wallet\_ticker wt

`                        `ON at1.ticker\_id = wt.ticker\_id),

`     `kurtosis\_calc

`     `AS (SELECT ticker\_id,

`                `( *Sum*(*Power*(( holdings\_percent - holding\_percent\_avg ), 4)) ) /

`                `( (

`                `*Count*(rl2.wallet\_id) - 1 ) \*

`                `*Power*(Stddev(holdings\_percent), 4) ) Kurtosis

`         `FROM   temp t

`                `INNER JOIN rich\_list rl2

`                        `ON t.wallet\_id = rl2.wallet\_id

`         `GROUP  BY ticker\_id),

`     `skewness\_calc

`     `AS (SELECT ticker\_id,

`                `( *Sum*(*Power*(( holdings\_percent - holding\_percent\_avg ), 3)) ) /

`                `( (

`                `*Count*(rl2.wallet\_id) - 1 ) \*

`                `*Power*(Stddev(holdings\_percent), 3) ) Skewness

`         `FROM   temp t

`                `INNER JOIN rich\_list rl2

`                        `ON t.wallet\_id = rl2.wallet\_id

`         `GROUP  BY ticker\_id)

SELECT dt.rank,

`       `dt.ticker\_id,

`       `dt.NAME,

`       `dt.ticker\_symbol,

`       `kurtosis,

`       `skewness

FROM   kurtosis\_calc kc

`       `INNER JOIN dim\_ticker dt

`               `ON kc.ticker\_id = dt.ticker\_id

`       `INNER JOIN skewness\_calc sc

`               `ON sc.ticker\_id = dt.ticker\_id

ORDER  BY rank** 

The query that shows us these values from the **VIEWS** table is as follows:

SELECT rank,

`       `NAME,

`       `ticker\_symbol,

`       `*Round*(kurtosis, 2),

`       `*Round*(skewness, 2)

FROM   vw\_crypto\_kurt\_skew 



1. I was going through the tables and noticed there are only 13 rows of data in the **EXCHANGE\_WALLET** table. What do these rows represent, and would you be able to add more rows of data to this table?

This table shows the **WALLET\_IDs** that each of the cryptocurrency exchanges owns. Since collecting this data from the web required more effort than time would allow us to present our database, we manually entered these rows into the table.

After looking up the **WALLET\_GUIDs** that belong to some of the **EXCHANGES**, we found two that belong to one of the **EXCHANGES** and are a part of the **RICH\_LIST** table for the XRP Cryptocurrency. On the web, we found a **WALLET\_GUID** that belongs to **BINANCE**. So we used the query below to search for that **WALLET\_GUID** in our database:

SELECT DW.wallet\_id,

`       `NAME

FROM   dim\_wallet DW

`       `INNER JOIN wallet\_ticker WT

`               `ON DW.wallet\_id = WT.wallet\_id

`       `INNER JOIN dim\_ticker DT

`               `ON WT.ticker\_id = DT.ticker\_id

WHERE  wallet\_guid = 'rs8ZPbYqgecRcDzQpJYAMhSxSi5htsjnza'; 

Then we looked up the BINANCE **EXCHANGE\_ID** from our **EXCHANGE\_DATA** and **DIM\_EXCHANGE** tables:

SELECT DISTINCT( DE.exchange\_id ),

`               `exchange\_name

FROM   exchange\_data

`       `INNER JOIN dim\_exchange DE

`               `ON exchange\_data.exchange\_id = DE.exchange\_id

WHERE  exchange\_name = 'Binance'; 

Then finally, we can insert the new rows into our **EXCHANGE\_WALLET** table:

INSERT INTO exchange\_wallet

`            `(exchange\_id,

`             `wallet\_id)

VALUES      (1,

`             `100476);

SELECT \*

FROM   exchange\_wallet; 



Now it can be seen that the number of rows has increased from 13 to 15 by manually inserting the new rows of data. (In this case, we did not use the **COMMIT** Function because we will be demonstrating that in the next question)

Although we agree that this method might be inefficient in populating this table of the database, we encourage others to expand on this part of the database and find a way to scrape and insert this data directly from the web or scrape and insert a bulk dataset with all the correct IDs attached.

The hard part with this specific problem is ensuring that the existing **WALLET\_GUIDs** and **WALLET\_IDs** belonging to these **EXCHANGES** are not duplicated. Since these **EXCHANGES** own many **WALLETS** (**WALLET\_GUIDs**), upon entering and updating the database, the tables, **DIM\_EXCHANGE**, **EXCHANGE\_DATA**, and **EXCHANGE\_WALLET** should all show correct and matching records of the data.

1. Lastly, I would like to see ten cryptocurrencies’ market caps, which have the highest readability scores for their whitepapers.

First, we will run the following query and see what we can find with the ten highest **READABILITY\_FRE** scores:

SELECT \*

FROM   dim\_whitepaper

ORDER  BY readability\_fre desc

FETCH first 10 ROWS only; 



We look closely at the column **READABILITY\_FRE** and notice that the data does not make sense. These values are not in the range they should be for how Flesch Reading Ease values are defined (they should be in the 0 - 100 range).

With further investigation, we find that the mapping to the CSV file that was imported in the database and for this table specifically was wrong, and the current **READABILITY\_FRE** column is mapped to the **WORD\_COUNT** column. There are also other issues with the mapping of this table as well.

Therefore, we decide to **DELETE** the rows of this table and commit so that we can import the CSV file again and make sure the mapping for the columns is correct this time:

DELETE FROM dim\_whitepaper;

COMMIT; 

Without using the **COMMIT** Function, the table will not update itself in the database and delete all the rows. We need to ensure that whenever we want something to take place in the database tables when we are writing queries to **INSERT**, **DELETE**, or **UPDATE**, we use the **COMMIT** Function to ensure that the tables in the database are also updated.

After importing the document with the correct mapping, we ran the following query to get the top 10 cryptocurrencies with the highest Flesch Reading Ease **READABILITY\_FRE** score:

SELECT name,

`       `ticker\_symbol,

`       `readability\_fre,

`       `**Log**(10, market\_cap\_usd)

FROM   dim\_whitepaper

`       `INNER JOIN dim\_ticker DT

`               `ON dim\_whitepaper.ticker\_id = DT.ticker\_id

`       `INNER JOIN market\_data MD

`               `ON DT.ticker\_id = MD.ticker\_id

ORDER  BY readability\_fre desc

FETCH first 10 ROWS only; 



The dataset used for this table seems to have a wrong value for the top row of the results. In cases where there are errors like this, we could either find a proper way to recalculate that value and update it in the table or entirely delete that row.

In this case, supposedly, the newly calculated value for the **READABILITY\_FRE** for the cryptocurrency Polygon comes to 45.22. Therefore, to update the value in that row, we use the following query where **WHITEPAPER\_ID** is the ID for the Polygon cryptocurrency:

UPDATE dim\_whitepaper

SET    readability\_fre = 45.22

WHERE  whitepaper\_id = 10000006;

COMMIT; 

Once we run the above queries to update the value, we run the previous query one more time to see if the changes happened and how they changed our results:

SELECT name,

`       `ticker\_symbol,

`       `readability\_fre,

`       `**Log**(10, market\_cap\_usd)

FROM   dim\_whitepaper

`       `INNER JOIN dim\_ticker DT

`               `ON dim\_whitepaper.ticker\_id = DT.ticker\_id

`       `INNER JOIN market\_data MD

`               `ON DT.ticker\_id = MD.ticker\_id

ORDER  BY readability\_fre desc

FETCH first 10 ROWS only; 



# <a name="_doz260kg7j23"></a>
# <a name="_iule4ci8wt8d"></a>**Part 3: Performance Tuning**
## <a name="_m8zngh9946h9"></a>Section 3.1: Compare Indexes
### <a name="_palsjtlp6068"></a>(1) Purpose of the experiment:
One experiment completed on the database was comparing two different indexes on the **DIM\_TICKER** table. **DIM\_TICKER\_pk** used **TICKER\_ID** as the index column, and **DIM\_TICKER\_TICKER\_SYMBOL\_index** uses **TICKER\_SYMBOL** as the column to index. The purpose was to see which of the two indexes was quicker and more effective at querying the database.
### <a name="_hmbhcrqstd0p"></a>(2) Steps followed in this experiment:
1. Two indexes were created on different columns in the **DIM\_TICKER** table. 
1. Multiple queries were run with both indexes to compare run times and costs.
1. Conclude which index was more effective based on the experiments.
### <a name="_yf7s6uw1heoi"></a>(3) Key Results:
The experiment starts with a simple select query. 

SELECT */\*+ INDEX(dim\_ticker DIM\_TICKER\_pk) \*/* \*

FROM   sql901.dim\_ticker;




SELECT */\*+ INDEX(dim\_ticker DIM\_TICKER\_TICKER\_SYMBOL\_index) \*/* \*

FROM   sql901.dim\_ticker; 




So far, the index based on **TICKER\_ID** is slightly more effective, with fewer bytes received from the client and less time to complete the query. 

SELECT */\*+ INDEX(dim\_ticker DIM\_TICKER\_pk) \*/* \*

FROM   sql901.dim\_ticker

WHERE  rank >= 5

`       `AND rank <= 70;




SELECT */\*+ INDEX(dim\_ticker DIM\_TICKER\_TICKER\_SYMBOL\_index) \*/* \*

FROM   sql901.dim\_ticker

WHERE  rank >= 5

`       `AND rank <= 70; 




For this step of the experiment, the index based on **TICKER\_ID** used less data but was slower. The index based on **TICKER\_SYMBOL** was faster but used more data. 

SELECT */\*+ INDEX(dim\_ticker DIM\_TICKER\_pk) \*/* \*

FROM   sql901.dim\_ticker

WHERE  dim\_ticker.NAME LIKE 'B%';




SELECT */\*+ INDEX(dim\_ticker DIM\_TICKER\_TICKER\_SYMBOL\_index) \*/* \*

FROM   sql901.dim\_ticker

WHERE  dim\_ticker.NAME LIKE 'B%';





This time, both queries sent the client the same amount of bytes via SQL (1-byte difference). The **TICKER-ID**-based index had slightly lower bytes received amount and was faster. 

SELECT */\*+ INDEX(dim\_ticker DIM\_TICKER\_pk) \*/* \*

FROM   sql901.dim\_ticker

WHERE  dim\_ticker.NAME LIKE 'B%'

ORDER  BY dim\_ticker.NAME DESC;




SELECT */\*+ INDEX(dim\_ticker DIM\_TICKER\_TICKER\_SYMBOL\_index) \*/* \*

FROM   sql901.dim\_ticker

WHERE  dim\_ticker.NAME LIKE 'B%'

ORDER  BY dim\_ticker.NAME DESC; 




When adding an **ORDER BY** phrase to the SQL statements, the **TICKER\_SYMBOL**-based index is faster in all steps. The data for both was about the same, however. 

### <a name="_mhwzil4upgnp"></a>(4) Discussion of the results:
Based on the experiments above, the better index of the two for both data sent/received and for speed is the **TICKER\_ID**-based index. This is only sometimes the case, but for most of the operations above, this was the best Index for this table. 
## <a name="_8pyz52x1qx6r"></a>Section 3.2: Caching
One technique for performance tuning that can make the database perform better would be caching techniques. The most relevant caching techniques would be query result caching, data caching and metadata caching. 

Metadata caching could be used to cache the column names and data types in memory to reduce the need to query the database. The cache for the metadata could be set for at least a month, as the column names and types should not change much at all. This would be great for a web interface where users searched for various data and could easily see what was searchable. 

Another method that could be used would be data caching. The most valuable tables to cache the data would be **DIM\_TICKER**, **DIM\_EXCHANGE** and **DIM\_WHITEPAPER**. Tables like these would not have many things changing frequently, and caching the metadata would speed up the database. Cache expiration for the tables should be set for at least one day but could probably be safely implemented for a week (except for the **DIM\_TICKER** table). The **DIM\_TICKER** table could not be cached for that long because of the rank column. The only two stable coins would be Ethereum and Bitcoin. 

Query Result Caching would be another performance-tuning measure that could be done to the database. These would be great to implement for frequently queried results. A good one would be the market cap of Bitcoin. 

SELECT market\_cap\_usd,

`       `NAME,

`       `ticker\_symbol

FROM   market\_data

`       `INNER JOIN dim\_ticker DT

`               `ON market\_data.ticker\_id = DT.ticker\_id

WHERE  DT.NAME = 'Bitcoin' 
# <a name="_vyackvmku68n"></a>
# <a name="_e1fkcs4imjsj"></a>**Part 4: Data Visualization**
Power BI was used to create some visualizations of the data from the database. This dashboard's data was limited to only include the top 5 cryptocurrencies since the cost of crypto coins varies significantly compared to Bitcoin and Ethereum. The first visualization compares the market dominance as a percentage of the top five cryptocurrencies. The visualization clearly shows that Bitcoin is the most popular cryptocurrency - over two times the popularity and market dominance of the second-place cryptocurrency, Ethereum. The other top three are all sub-10 %. 



The second visualization created with Power BI compares the one-day high and the one-day low in USD of the top five cryptocurrencies. This visualization shows how volatile each of the top five cryptocurrencies can be in just one day.

Bitcoin has the highest cost in USD as well as the most volatility. In one day, the price fluctuates at almost $500. Ethereum fluctuated on a much smaller scale of around $48, BinanceCoin was $6.85, Tether was the least volatile at $0.01, and USDCoin was $0.05.



The last two visualizations were based on the database view of kurtosis and skewness. The OKB cryptocurrency has the highest kurtosis and skewness, followed by Dogecoin. Both data points can help users better understand the risk and potential return of investing in a cryptocurrency. For skewness, the higher the positive skewness, the potentially higher risk the investment would be. This would imply that only a few crypto coin sales resulted in high yields. Skewness can imply a similar thing with high-risk investments. A higher skew value may imply that the returns are concentrated on just a few values or sales and that there is little variation between them. This would be a high risk for an investor as there would be low investment diversification. The interactive report will be shown in the video presentation. The file to view the Power BI interactive dashboard can also be downloaded from GitHub (found in the Appendix). 





# <a name="_p8rp5mmresd2"></a>
# <a name="_bu3w2m29ote5"></a>Appendix
All files for this database project can be viewed on GitHub. This includes the following: 

- Power BI files
- Python data files
- CSV files for tables
- ERD diagram files and iterations
- High-level diagram of the database and Visio design file
- README file
- SQL scripts that were used to create the database
- PowerPoint slide deck 

<https://github.com/alisdghnia/adbm-crypto-database-project> 

YouTube link to the presentation: <https://youtu.be/wgGBSO4blrw> 

