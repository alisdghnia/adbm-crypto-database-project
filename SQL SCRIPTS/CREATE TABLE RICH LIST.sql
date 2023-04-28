create table RICH_LIST
(
    WALLET_ID                 NUMBER
        constraint "RICH_LIST_WALLET_ID_fk"
            references DIM_WALLET,
    HOLDINGS_CRYPTO           NUMBER,
    HOLDINGS_PERCENT_UPDATED  FLOAT,
    HOLDINGS_SEVEN_DAY_CHANGE NUMBER
)
/

