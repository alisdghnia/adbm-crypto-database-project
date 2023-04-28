create table WALLET_TICKER
(
    WALLET_ID NUMBER
        constraint "WALLET_TICKER_WALLET_ID_fk"
            references DIM_WALLET,
    TICKER_ID NUMBER
        constraint "WALLET_TICKER_ID_fk"
            references DIM_TICKER
)
/

