create table DIM_WHITEPAPER
(
    WHITEPAPER_ID   NUMBER not null
        constraint "DIM_WHITEPAPER_pk"
            primary key,
    TITLE           VARCHAR2(50),
    RELEASE_DATE    DATE,
    WORD_COUNT      NUMBER,
    FILE_SIZE       FLOAT,
    READABILITY_FRE FLOAT,
    HAS_ABSTRACT    NUMBER,
    HAS_SUMMARY     NUMBER,
    HAS_REFERENCES  NUMBER,
    TICKER_ID       NUMBER
        constraint "DIM_WHITEPAPER_fk_TICKER_ID"
            references DIM_TICKER,
    READABILITY_NDC FLOAT
)
/

