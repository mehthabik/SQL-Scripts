

with TransCons_Agg as (		
	select a.FinYear1, a.Date, a.Company, a.StoreNo, a.ItemId, a.Description, a.Dept2, a.Department, a.SubDepartment, a.Class, a.SubClass, a.TransID,	
		b.[GROUP],b.[TYPE_CODE],
		sum(a.Qty) QtySold, sum(a.sales$) Sls, sum(a.sales$-cost$) Mgn
	from Fact_TransConsol a	
	left join Dim_AttachmentPrincipal b	
		on a.SubClass = b.SUB_CLASS_NAME
	where DATE >=  '2025-02-01'	
		
	and stype not in ('','Concession','Service','Ticketing')	
	group by a.FinYear1, a.Date, a.Company, a.StoreNo, a.ItemId, a.Description, a.Dept2, a.Department, a.SubDepartment, a.Class, a.SubClass, a.TransID,	
		b.[GROUP],b.[TYPE_CODE]
		
),		
Type_A_Agg as (		
	select distinct TransId, [GROUP], [TYPE_CODE]	
	from TransCons_Agg	
	WHERE  [TYPE_CODE] = 'A'	
),		
	Type_P_Agg as (	
	select distinct TransId, [GROUP], [TYPE_CODE]	
	from TransCons_Agg	
	WHERE  [TYPE_CODE] = 'P'	
)		
SELECT a.FinYear1, a.Company, a.TransId, a.[GROUP], a.[TYPE_CODE],		
	c.[type_code] as 'Type_Code_P', b.[type_code] as 'Type_Code_A',	
	case 	
	when c.[type_code] = 'P' and b.[type_code]  = 'A' then '1- Attachment Transaction'	
	when c.[type_code] = 'P' and b.[type_code]  is null then '2- MISSED opportunity'	
	when c.[type_code] is null and b.[type_code]  = 'A' then '3- Attachment Only'	
	else 'Non Attachment Trans'	
	end as 'FLAG',	
	Sum(a.qtysold) QtySold,	
	Sum(a.sls) Sales,	
	Sum(a.mgn) Margin	
	FROM TransCons_Agg a	
	left join Type_A_Agg b	
		on a.TransId = b.TransId and a.[GROUP] = b.[GROUP]
	left join Type_P_Agg c	
		on a.TransId = c.TransId and a.[GROUP] = c.[GROUP]
	where a.[GROUP] = 'D'	
	group by a.FinYear1, a.Company, a.TransId, a.[GROUP], a.[TYPE_CODE], c.[type_code] , b.[type_code]	
