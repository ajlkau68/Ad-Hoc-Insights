-- Microsoft SQL Server dump
--
-- Host: localhost    Database: retail_events_db
-- ------------------------------------------------------

--
-- Table structure for table `dim_campaigns`
--

DROP TABLE IF EXISTS dim_campaigns;

CREATE TABLE dim_campaigns (
  campaign_id varchar(20) NOT NULL,
  campaign_Name varchar(50) NOT NULL,
  begin_date date NOT NULL,
  end_date date NOT NULL,
  PRIMARY KEY (campaign_id)
);

--
-- Dumping data for table `dim_campaigns`
--

INSERT INTO dim_campaigns VALUES ('CAMP_DIW_01','Diwali','2023-11-12','2023-11-18'),
('CAMP_SAN_01','Sankranti','2024-01-10','2024-01-16');

--
-- Table structure for table `dim_products`
--

DROP TABLE IF EXISTS dim_products;

CREATE TABLE dim_products (
  product_code varchar(10) NOT NULL,
  product_name varchar(255) NOT NULL,
  category varchar(50) NOT NULL,
  PRIMARY KEY (product_code)
);

--
-- Dumping data for table `dim_products`
--

INSERT INTO dim_products VALUES ('P01','Atliq_Masoor_Dal (1KG)','Grocery & Staples'),
('P02','Atliq_Sonamasuri_Rice (10KG)','Grocery & Staples'),
('P03','Atliq_Suflower_Oil (1L)','Grocery & Staples'),
('P04','Atliq_Farm_Chakki_Atta (1KG)','Grocery & Staples'),
('P05','Atliq_Scrub_Sponge_For_Dishwash','Home Care'),
('P06','Atliq_Fusion_Container_Set_of_3','Home Care'),
('P07','Atliq_Curtains','Home Care'),
('P08','Atliq_Double_Bedsheet_set','Home Care'),
('P09','Atliq_Body_Milk_Nourishing_Lotion (120ML)','Personal Care'),
('P10','Atliq_Cream_Beauty_Bathing_Soap (125GM)','Personal Care'),
('P11','Atliq_Doodh_Kesar_Body_Lotion (200ML)','Personal Care'),
('P12','Atliq_Lime_Cool_Bathing_Bar (125GM)','Personal Care'),
('P13','Atliq_High_Glo_15W_LED_Bulb','Home Appliances'),
('P14','Atliq_waterproof_Immersion_Rod','Home Appliances'),
('P15','Atliq_Home_Essential_8_Product_Combo','Combo1');

--
-- Table structure for table `dim_stores`
--

DROP TABLE IF EXISTS dim_stores;

CREATE TABLE dim_stores (
  store_id varchar(15) NOT NULL,
  city varchar(50) NOT NULL,
  PRIMARY KEY (store_id)
);

--
-- Dumping data for table `dim_stores`
--

INSERT INTO dim_stores VALUES ('STBLR-0','Bengaluru'),('STBLR-1','Bengaluru'),('STBLR-2','Bengaluru'),('STBLR-3','Bengaluru'),('STBLR-4','Bengaluru'),('STBLR-5','Bengaluru'),('STBLR-6','Bengaluru'),('STBLR-7','Bengaluru'),('STBLR-8','Bengaluru'),('STBLR-9','Bengaluru'),('STCBE-0','Coimbatore'),('STCBE-1','Coimbatore'),('STCBE-2','Coimbatore'),('STCBE-3','Coimbatore'),('STCBE-4','Coimbatore'),('STCHE-0','Chennai'),('STCHE-1','Chennai'),('STCHE-2','Chennai'),('STCHE-3','Chennai'),('STCHE-4','Chennai'),('STCHE-5','Chennai'),('STCHE-6','Chennai'),('STCHE-7','Chennai'),('STHYD-0','Hyderabad'),('STHYD-1','Hyderabad'),('STHYD-2','Hyderabad'),('STHYD-3','Hyderabad'),('STHYD-4','Hyderabad'),('STHYD-5','Hyderabad'),('STHYD-6','Hyderabad'),('STMDU-0','Madurai'),('STMDU-1','Madurai'),('STMDU-2','Madurai'),('STMDU-3','Madurai'),('STMLR-0','Mangalore'),('STMLR-1','Mangalore'),('STMLR-2','Mangalore'),('STMYS-0','Mysuru'),('STMYS-1','Mysuru'),('STMYS-2','Mysuru'),('STMYS-3','Mysuru'),('STTRV-0','Trivandrum'),('STTRV-1','Trivandrum'),('STVJD-0','Vijayawada'),('STVJD-1','Vijayawada'),('STVSK-0','Visakhapatnam'),('STVSK-1','Visakhapatnam'),('STVSK-2','Visakhapatnam'),('STVSK-3','Visakhapatnam'),('STVSK-4','Visakhapatnam');

--
-- Table structure for table `fact_events`
--

DROP TABLE IF EXISTS fact_events;

CREATE TABLE fact_events (
  event_id varchar(10) NOT NULL,
  store_id varchar(10) NOT NULL,
  campaign_id varchar(20) NOT NULL,
  product_code varchar(10) NOT NULL,
  base_price int NOT NULL,
  promo_type varchar(50) DEFAULT NULL,
  quantity_sold_before_promo int NOT NULL,
  quantity_sold_after_promo int NOT NULL
);
