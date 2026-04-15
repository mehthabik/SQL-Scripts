
UPDATE sc
SET sc.Description = stg.PRODUCTNAME
FROM SalesConsol sc
left JOIN Dim_ItemMaster stg
ON sc.company = stg.company
AND sc.itemid = stg.itemnumber
where sc.Date>='2025-02-01'

UPDATE sc
SET sc.Department = stg.LTCATEGORY1
FROM SalesConsol sc
left JOIN Dim_ItemMaster stg
ON sc.company = stg.company
AND sc.itemid = stg.itemnumber
where sc.Date>='2025-02-01'

UPDATE sc
SET sc.SubDepartment = stg.LTCATEGORY2
FROM SalesConsol sc
left JOIN Dim_ItemMaster stg
ON sc.company = stg.company
AND sc.itemid = stg.itemnumber
where sc.Date>='2025-02-01'

UPDATE sc
SET sc.Class = stg.LTCATEGORY3
FROM SalesConsol sc
left JOIN Dim_ItemMaster stg
ON sc.company = stg.company
AND sc.itemid = stg.itemnumber
where sc.Date>='2025-02-01'

UPDATE sc
SET sc.SubClass = stg.LTCATEGORY4
FROM SalesConsol sc
left JOIN Dim_ItemMaster stg
ON sc.company = stg.company
AND sc.itemid = stg.itemnumber
where sc.Date>='2025-02-01'

UPDATE sc
SET sc.Brand = stg.BRAND
FROM SalesConsol sc
left JOIN Dim_ItemMaster stg
ON sc.company = stg.company
AND sc.itemid = stg.itemnumber
where sc.Date>='2025-02-01'

UPDATE sc
SET sc.Supplier = stg.VENDORID
FROM SalesConsol sc
left JOIN Dim_ItemMaster stg
ON sc.company = stg.company
AND sc.itemid = stg.itemnumber
where sc.Date>='2025-02-01'

UPDATE sc
SET sc.SupplierName = stg.VENDORNAME
FROM SalesConsol sc
left JOIN Dim_ItemMaster stg
ON sc.company = stg.company
AND sc.itemid = stg.itemnumber
where sc.Date>='2025-02-01'

UPDATE sc
SET sc.Stype = stg.ITEMGROUPNAME
FROM SalesConsol sc
left JOIN Dim_ItemMaster stg
ON sc.company = stg.company
AND sc.itemid = stg.itemnumber
where sc.Date>='2025-02-01'

---------------------------------------
