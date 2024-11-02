CREATE TABLE kimia_farma.analysis_table AS
SELECT 
    ft.transaction_id,
    ft.date,
    ft.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating AS rating_cabang,
    ft.customer_name,
    ft.product_id,
    p.product_name,
    ft.price AS actual_price,
    ft.discount_percentage,
    
    -- Perhitungan persentase_gross_laba berdasarkan ketentuan harga
    CASE 
        WHEN ft.price <= 50000 THEN 0.10
        WHEN ft.price > 50000 AND ft.price <= 100000 THEN 0.15
        WHEN ft.price > 100000 AND ft.price <= 300000 THEN 0.20
        WHEN ft.price > 300000 AND ft.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS persentase_gross_laba,
    
    -- Perhitungan nett_sales sebagai harga setelah diskon
    (ft.price * (1 - ft.discount_percentage)) AS nett_sales,
    
    -- Perhitungan nett_profit sebagai laba bersih
    ((ft.price * (1 - ft.discount_percentage)) *
        CASE 
            WHEN ft.price <= 50000 THEN 0.10
            WHEN ft.price > 50000 AND ft.price <= 100000 THEN 0.15
            WHEN ft.price > 100000 AND ft.price <= 300000 THEN 0.20
            WHEN ft.price > 300000 AND ft.price <= 500000 THEN 0.25
            ELSE 0.30
        END
    ) AS nett_profit,
    ft.rating AS rating_transaksi

FROM 
    kimia_farma.kf_final_transaction AS ft
    JOIN kimia_farma.kf_product AS p ON ft.product_id = p.product_id
    JOIN kimia_farma.kf_kantor_cabang AS kc ON ft.branch_id = kc.branch_id;
