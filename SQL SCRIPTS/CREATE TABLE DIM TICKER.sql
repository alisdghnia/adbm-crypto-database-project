create table DIM_TICKER
(
    TICKER_ID     NUMBER not null
        constraint "DIM_TICKER_pk"
            primary key,
    TICKER_SYMBOL VARCHAR2(6),
    NAME          VARCHAR2(25),
    DESCRIPTION   VARCHAR2(50),
    RANK          NUMBER
)
/

create index "DIM_TICKER_TICKER_SYMBOL_index"
    on DIM_TICKER (TICKER_SYMBOL)
/

