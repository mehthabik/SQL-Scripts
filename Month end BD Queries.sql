--phase 1--
alter TABLE [dbo].[VW_StockAgeing_BD_202604]
alter column StockBracket nvarchar(20) null

ALTER TABLE [dbo].[VW_StockAgeing_BD_202604]
Add StockBracket3 nvarchar (10) null,
StockBracketDescription3 nvarchar (12) null,
[Total_Prov$3] [Float] NULL,
[ReturnableYNNew] nvarchar (10) null,
[FRDEntity] [date] NULL,
[Total_Stk_LC] [decimal](18, 10) NULL,
Category nvarchar (50) null,
DropShippingYN nvarchar(5) null,
PromoYN nvarchar (10) null,
BestSellersYN nvarchar (5) null,
CatExclusionYN nvarchar (10) null,
StoreType nvarchar (20) null

--rename stockbrackets and prov (last)  ----------------------------------------------------------------
--update only after returnable yn renamed(as Returnable YN_Old) and new as YN
update a
set a.[Returnable YN]=b.returnableyn
from [VW_StockAgeing_BD_202604] a
left join Dim_Returnables b
	on a.supplier = b.vendor
	 and a.brand=b.brand;
 
--applies return status based on vendor level status (for whats remaining)
update a
set a.[Returnable YN]= b.RETURNABLEYN
from [VW_StockAgeing_BD_202604] a
left join  Dim_Returnables b
on a.Supplier=b.VENDOR
where a.[Returnable YN] = ''
	or a.[Returnable YN] is null
	and b.brand = '';
 
--applies demo flag
UPDATE s 
SET [Returnable YN]= 
    CASE 
        WHEN s.DESCRIPTION LIKE 'Demo %' OR s.DESCRIPTION LIKE 'Demo-%' OR s.DESCRIPTION LIKE '% Demo %' 
          OR s.DESCRIPTION LIKE '%(demo)%'  OR s.DESCRIPTION LIKE '%DEMO-%' OR s.DESCRIPTION LIKE '%DEMO %' 
		  --OR s.DESCRIPTION NOT LIKE '%DEMON%' 
          OR (LEN(s.STORE) = 4 AND RIGHT(s.STORE, 1) = '1' AND s.STORE NOT IN ('7001', '4991')) 
        THEN 'Demo' 
       else s.[Returnable YN]
    END
FROM [VW_StockAgeing_BD_202604] s
 
--applies return status N on whatever we were nto able to capture
update [VW_StockAgeing_BD_202604]
set [Returnable YN] = 'N'
where [Returnable YN] is null
------------------------------------------------

UPDATE dbo.VW_StockAgeing_BD_202604
SET [VW_StockAgeing_BD_202604].[FRDEntity] = VW_StockAgeing.[FRDEntity]
	FROM [VW_StockAgeing_BD_202604] 
	LEFT JOIN VW_StockAgeing
	ON dbo.[VW_StockAgeing_BD_202604].company = VW_StockAgeing.company and 
	dbo.[VW_StockAgeing_BD_202604].sku = VW_StockAgeing.sku
---------------------------------------------------------------------------------------

UPDATE dbo.[VW_StockAgeing_BD_202604]
SET dbo.[VW_StockAgeing_BD_202604].[Total_Stk_LC] = VW_StockAgeing.[Total_Stk_LC]
	FROM dbo.[VW_StockAgeing_BD_202604] 
	LEFT JOIN VW_StockAgeing
	ON dbo.[VW_StockAgeing_BD_202604].company = VW_StockAgeing.company and 
	dbo.[VW_StockAgeing_BD_202604].sku = VW_StockAgeing.sku

--------------------------------------------------------------------------------

UPDATE a
SET a.DropShippingYN = b.DropShippingYN
FROM [VW_StockAgeing_BD_202604] a
LEFT JOIN Dim_ItemMaster b
    ON a.company = b.COMPANY
	AND a.Sku = b.ITEMNUMBER
LEFT JOIN Dim_StoreName S
	ON a.Store=S.STORE
where s.StoreType='Ecomm'

-------------------------------------------------------------------------------

UPDATE [VW_StockAgeing_BD_202604]
 
SET StockBracket3 =
 
   CASE
   WHEN DEPARTMENT IN ('MUSIC', 'BOOKS') and SubDepartment not in ('VINYL','CDS','CASSETTES','DVD/BLU-RAY') THEN
   CASE 
       WHEN DATEDIFF(DAY, LRDEntity, GETDATE()-1) < 271 THEN '0-9M'
 
       WHEN DATEDIFF(DAY, LRDEntity, GETDATE()-1) < 361 THEN '9-12M'
 
       WHEN DATEDIFF(DAY, LRDEntity, GETDATE()-1) < 541 THEN '12-18M'
 
       WHEN DATEDIFF(DAY, LRDEntity, GETDATE()-1) > 540 THEN '>18M'
   END
 
  
  WHEN DEPARTMENT IN ('MUSIC') and SubDepartment in ('VINYL','CDS','CASSETTES','DVD/BLU-RAY') THEN
  CASE
      WHEN DATEDIFF(DAY, LRDEntity, GETDATE()-1) < 541 THEN '0-18M'
	  WHEN DATEDIFF(DAY, LRDEntity, GETDATE()-1) < 721 THEN '18-24M'
	  WHEN DATEDIFF(DAY, LRDEntity, GETDATE()-1) < 811 THEN '24-27M'
	  WHEN DATEDIFF(DAY, LRDEntity, GETDATE()-1) > 810 THEN '>27M'
       
   END
  ELSE StockBracket
  END;

--2
UPDATE [VW_StockAgeing_BD_202604]
SET StockBracketDescription3 = 
     CASE 
          WHEN DEPARTMENT IN ('MUSIC', 'BOOKS') and SubDepartment not in ('VINYL','CDS','CASSETTES','DVD/BLU-RAY') THEN
             CASE
                WHEN DATEDIFF(DAY, LRDEntity, GETDATE()-1) < 271 THEN 'Moving'
				WHEN DATEDIFF(DAY, LRDEntity, GETDATE()-1) < 361 THEN 'Slow Moving'
				WHEN DATEDIFF(DAY, LRDEntity, GETDATE()-1) < 541 THEN 'Non Moving'
				WHEN DATEDIFF(DAY, LRDEntity, GETDATE()-1) > 540 THEN 'Non Moving'
    		 END
          
	     WHEN DEPARTMENT IN ('MUSIC') and SubDepartment in ('VINYL','CDS','CASSETTES','DVD/BLU-RAY') THEN
	       CASE
              WHEN DATEDIFF(DAY, LRDEntity, GETDATE()-1) < 541 THEN 'Moving'
			  WHEN DATEDIFF(DAY, LRDEntity, GETDATE()-1) < 721 THEN 'Slow Moving'
              WHEN DATEDIFF(DAY, LRDEntity, GETDATE()-1) < 811 THEN 'Non Moving'
              WHEN DATEDIFF(DAY, LRDEntity, GETDATE()-1) > 810 THEN 'Non Moving'
           END
     ELSE StockBracketDescription
	 END;
--3
UPDATE [VW_StockAgeing_BD_202604]
SET Total_Prov$3 =
 

    CASE 
        WHEN (Department IN ('BOOKS', 'MUSIC') AND StockBracket3 = '0-9M') THEN 0.00 * Total_Stk$
        WHEN (Department IN ('BOOKS', 'MUSIC') AND StockBracket3 = '9-12M') THEN 0.10 * Total_Stk$
        WHEN (Department IN ('BOOKS', 'MUSIC') AND StockBracket3 = '12-18M') THEN 0.50 * Total_Stk$
        WHEN (Department IN ('BOOKS', 'MUSIC') AND StockBracket3 = '>18M') THEN 0.50 * Total_Stk$
 
        WHEN (Department = 'MUSIC' AND StockBracket3 = '0-18M') THEN 0.00 * Total_Stk$
        WHEN (Department = 'MUSIC' AND StockBracket3 = '18-24M') THEN 0.10 * Total_Stk$
        WHEN (Department = 'MUSIC' AND StockBracket3 = '24-27M') THEN 0.50 * Total_Stk$
        WHEN (Department = 'MUSIC' AND StockBracket3 = '>27M') THEN 0.50 * Total_Stk$
   
   ELSE Total_Prov$
   END	
---------------------------------------------------------------------------------

UPDATE [VW_StockAgeing_BD_202604]
SET PromoYN = Stg_PricingHUBCatalog.is_discounted
FROM [VW_StockAgeing_BD_202604]
LEFT JOIN Stg_PricingHUBCatalog
    ON [VW_StockAgeing_BD_202604].Company = Stg_PricingHUBCatalog.country_code
   AND [VW_StockAgeing_BD_202604].Sku = Stg_PricingHUBCatalog.item_number;

--------------------------------------------------------------------------------

update [VW_StockAgeing_BD_202604]
set [VW_StockAgeing_BD_202604].BestSellersYN =
case
     when Dim_BestSellers.bestsellersyn = 'Y' then 'Y'
	 else 'N'
	 end
from [VW_StockAgeing_BD_202604] 
left join Dim_BestSellers 
on [VW_StockAgeing_BD_202604].Company=Dim_BestSellers.Company and [VW_StockAgeing_BD_202604].Sku=Dim_BestSellers.ItemId

---------------------------------------------------------------------------------
update [VW_StockAgeing_BD_202604]
set dbo.[VW_StockAgeing_BD_202604].StoreType=Dim_StoreName.StoreType
from dbo.[VW_StockAgeing_BD_202604]
left join Dim_StoreName
ON dbo.[VW_StockAgeing_BD_202604].Store = Dim_StoreName.STORE
-----------------------------------------------------------------------------------

update [VW_StockAgeing_BD_202604]

set Category =

       Case

       when Class = 'MOBILE PHONES' then '1-MOBILE PHONES'

       when Class = 'MOBILE ACCESSORIES' then '2-MOBILE ACCESSORIES'

       when Class = 'COMPUTERS' then '3-COMPUTERS'

       when SubDepartment = 'COMPUTERS & ACCESSORIES'

              and Class <> 'COMPUTERS' then '4-Other Computers'

       when Class = 'TABLETS & E-READERS' then '5-TABLETS & E-READERS'

       when Class = 'TABLET ACCESSORIES' then '6-TABLET ACCESSORIES'

       when Class = 'SMART WATCH ACCESSORIES' then '7-SMART WATCH ACCESSORIES'

       when Class = 'SMARTWATCHES & TRACKERS' then '8-SMARTWATCHES & TRACKERS'

       when SubDepartment = 'AUDIO + VIDEO' then '9-AUDIO + VIDEO'

       when Department = 'ELECTRONICS'

              and SubDepartment not in ('MOBILES & ACCESSORIES','COMPUTERS & ACCESSORIES','TABLETS & ACCESSORIES','SMART WATCHES + WEARABLES','AUDIO + VIDEO')

                     then '10-Other Electronics'

       when Class = 'GAMING CONSOLES' then '11-GAMING CONSOLES'

       when Class = 'GAMING PCS & MONITORS' then '12-GAMING PCS & MONITORS'

       when SubDepartment = 'VIDEO GAMES & CARDS' then '13-VIDEO GAMES & CARDS'

       when Department = 'GAMING'

              and SubDepartment not in ('GAMING HARDWARE','VIDEO GAMES & CARDS')

                     then '14-Other Gaming'

       when Department = 'FASHION' then '15-FASHION'

       when Department = 'TOYS' then '16-TOYS'

       when Department = 'HOUSE' then '17-HOUSE'

       when Department = 'STATIONERY' then '18-STATIONERY'

       when Dept2 = 'LIFESTYLE'

              and SubDepartment not in ('FASHION','TOYS','HOUSE','STATIONERY')

                     then '19-Other Lifestyle'

       when Department = 'BOOKS' then '20-BOOKS'

       when SubDepartment = 'VINYL' then '21-VINYL'

       when SubDepartment = 'TURNTABLES & AUDIO' then '22-TURNTABLES & AUDIO'

       when SubDepartment = 'CDS' then '23-CDS'

       when Department = 'MUSIC'

              and SubDepartment not in ('VINYL','TURNTABLES & AUDIO','CDS')

                     then '24-Other Music'

       end