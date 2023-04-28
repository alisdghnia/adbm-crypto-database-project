create table DIM_TEAM
(
    TEAM_ID   NUMBER not null
        constraint "DIM_TEAM_pk"
            primary key,
    TICKER_ID NUMBER
        constraint "DIM_TEAM_DIM_TICKER_ID_fk"
            references DIM_TICKER
)
/

