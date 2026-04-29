USE [AxDW]
GO

/****** Object:  View [dbo].[View_BestSellers]    Script Date: 4/28/2026 11:27:58 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER view [dbo].[View_BSTEcommmPhy_DF] as

SELECT [Company]
      ,[Sku]
      ,[Description]
      ,[Dept2]
      ,[Department]
      ,[SubDepartment]
      ,[Class]
      ,[SubClass]
      ,[Brand]
      ,[Supplier]
      ,[SupplierName]
      ,[Stype]
      ,[ReturnableYN]
      ,[PopGradeNo]
      ,[LRDEntity]
      ,[FRDEntity]
      ,[StockBracket]
      ,[StockBracketDescription]
      ,sum([Total_Stk_Qty]) as QtyOH
      ,sum([Total_Stk$]) as TotalStock$
      ,sum([Total_Prov$]) as TotalProv$
      ,[Category]
	  ,[BST_EcommYN]
	  ,[BST_PhyYN]
  FROM [AxDW].[dbo].[VW_StockAgeing]
  where Stype in ('normal purchase','purchase foreign')
  and Department <> 'services'
  and Company not in ('JOR','KWT','EGP')
  and BST_EcommYN <> 'N'
  and BST_PhyYN   <> 'N'
  
  group by  
       [Company]
      ,[Sku]
      ,[Description]
      ,[Dept2]
      ,[Department]
      ,[SubDepartment]
      ,[Class]
      ,[SubClass]
      ,[Brand]
      ,[Supplier]
      ,[SupplierName]
      ,[Stype]
      ,[ReturnableYN]
      ,[PopGradeNo]
      ,[LRDEntity]
      ,[FRDEntity]
      ,[StockBracket]
      ,[StockBracketDescription]
	  ,[Category]
	  ,[BST_EcommYN]
	  ,[BST_PhyYN]
	  
	  having sum(Total_Stk_Qty)<>0;



GO


