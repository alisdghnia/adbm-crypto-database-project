create view VW_CRYPTO_KURT_SKEW as
WITH avg_table AS (SELECT wt.TICKER_ID, AVG(rl.HOLDINGS_PERCENT_UPDATED) AS Holding_Percent_Avg
                   FROM RICH_LIST rl
                            INNER JOIN WALLET_TICKER wt
                                       ON rl.WALLET_ID = wt.WALLET_ID
                   GROUP BY wt.TICKER_ID)
   , temp AS (SELECT at1.TICKER_ID, wt.WALLET_ID, Holding_Percent_Avg
              FROM avg_table at1
                       INNER JOIN WALLET_TICKER wt
                                  ON at1.TICKER_ID = wt.TICKER_ID)
   , kurtosis_calc AS (SELECT TICKER_ID,
                              (SUM(POWER((HOLDINGS_PERCENT_UPDATED - Holding_Percent_Avg), 4))) /
                              ((COUNT(rl2.WALLET_ID) - 1) * POWER(stddev(HOLDINGS_PERCENT_UPDATED), 4)) Kurtosis
                       FROM temp t
                                INNER JOIN RICH_LIST rl2
                                           ON t.WALLET_ID = rl2.WALLET_ID
                       GROUP BY TICKER_ID)
   , skewness_calc AS (SELECT TICKER_ID,
                              (SUM(POWER((HOLDINGS_PERCENT_UPDATED - Holding_Percent_Avg), 3))) /
                              ((COUNT(rl2.WALLET_ID) - 1) * POWER(stddev(HOLDINGS_PERCENT_UPDATED), 3)) Skewness
                       FROM temp t
                                INNER JOIN RICH_LIST rl2
                                           ON t.WALLET_ID = rl2.WALLET_ID
                       GROUP BY TICKER_ID)
SELECT dt.RANK, dt.TICKER_ID, dt.NAME, dt.TICKER_SYMBOL, Kurtosis, Skewness
FROM kurtosis_calc kc
         INNER JOIN DIM_TICKER dt
                    ON kc.TICKER_ID = dt.TICKER_ID
         INNER JOIN skewness_calc sc ON sc.TICKER_ID = dt.TICKER_ID
ORDER BY Rank
/

