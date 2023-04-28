create table EXCHANGE_WALLET
(
    EXCHANGE_ID NUMBER
        constraint "EXCHANGE_WALLET_DIM_fk"
            references DIM_EXCHANGE,
    WALLET_ID   NUMBER
        constraint "EXCHANGE_WALLET_WALLET_ID_fk"
            references DIM_WALLET
)
/

