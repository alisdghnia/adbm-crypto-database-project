create table DIM_EXCHANGE
(
    EXCHANGE_ID   NUMBER not null
        constraint "DIM_EXCHANGE_pk"
            primary key,
    EXCHANGE_NAME VARCHAR2(50)
)
/

