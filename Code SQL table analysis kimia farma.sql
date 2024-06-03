/*Make the new table with different name table */
CREATE TABLE kimia_farma.final_kimia_farma AS
/*SELECT for retrieves column from many database tables*/
SELECT
    tr.transaction_id,
    tr.date,
    tr.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating AS rating_cabang, /*change the column name rating to rating_cabang*/
    tr.customer_name,
    tr.product_id,
    pr.product_name,
    pr.price AS actual_price, /*change the column name price to actual_price*/
    tr.discount_percentage,
    /*expression goes through conditions according to the price grouped into a discount*/
    CASE
        WHEN pr.price <= 50000  THEN pr.price * 0.10
        WHEN pr.price <= 100000 THEN pr.price * 0.15
        WHEN pr.price <= 300000 THEN pr.price * 0.20
        WHEN pr.price <= 500000 THEN pr.price * 0.25
        ELSE pr.price * 0.30
    END AS persentase_gross_laba,
    (pr.price * (1 - tr.discount_percentage / 100)) AS nett_sales, /*change the column name to nett_sales*/
    (pr.price * (1 - tr.discount_percentage / 100)) * 
    /*expression goes through conditions according to the price grouped into a discount*/
    (CASE
        WHEN pr.price <= 50000  THEN 0.10
        WHEN pr.price <= 100000 THEN 0.15
        WHEN pr.price <= 300000 THEN 0.20
        WHEN pr.price <= 500000 THEN 0.25
        ELSE 0.30
    END) AS nett_profit,/*change the column name to nett_profit*/
    tr.rating AS rating_transaksi /*change the column name to rating_transaksi*/
FROM
    kimia_farma.kf_final_transaction tr
INNER JOIN /*combining rows that have matching values*/
    kimia_farma.kf_kantor_cabang kc
ON
    tr.branch_id = kc.branch_id
INNER JOIN/*combining rows that have matching values*/
    kimia_farma.kf_product pr
ON
    tr.product_id = pr.product_id;