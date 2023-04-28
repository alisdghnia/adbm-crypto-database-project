create table EXCHANGE_DATA
(
    EXCHANGE_ID        NUMBER
        constraint "EXCHANGE_DATA_EXCHANGE_ID_fk"
            references DIM_EXCHANGE,
    TICKER_ID          NUMBER
        constraint "EXCHANGE_DATA_DIM_TICKER_fk"
            references DIM_TICKER,
    TOKEN_BALANCE      NUMBER,
    EXCHANGE_VALUE_USD NUMBER,
    ONE_DAY_CHANGE     NUMBER,
    SEVEN_DAY_CHANGE   NUMBER,
    THIRTY_DAY_CHANGE  NUMBER
)
/

