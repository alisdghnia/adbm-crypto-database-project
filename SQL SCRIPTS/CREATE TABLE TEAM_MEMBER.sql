create table DIM_TEAM_MEMBER
(
    TEAM_MEMBER_ID NUMBER not null
        constraint "DIM_TEAM_MEMBER_pk"
            primary key,
    TEAM_ID        NUMBER
        constraint "DIM_TEAM_MEMBER_TEAM_ID_fk"
            references DIM_TEAM,
    MEMBER_NAME    VARCHAR2(50)
)
/

