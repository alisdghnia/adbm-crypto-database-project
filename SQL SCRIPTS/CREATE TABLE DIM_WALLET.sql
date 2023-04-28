create table DIM_WALLET
(
    WALLET_ID   NUMBER not null
        constraint "DIM_WALLET_pk"
            primary key,
    WALLET_GUID VARCHAR2(50)
)
/

