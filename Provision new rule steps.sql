/*
alter table [dbo].[VW_StockAgeing_BD_202604]
add CatExclusionYN nvarchar (10) null

alter table [dbo].[VW_StockAgeing_BD_202604]
add Total_Prov$ float null

/*Fill CatExclusionYN */
update BD
set CatExclusionYN = 
case 
when 
tmp.exclusionyn = 'Y'
then 'Y' else 'N' END
from VW_StockAgeing_BD_202604 BD
left join temp_tbl_Provexclusions tmp
on tmp.subclass = BD.subclass

--check
select distinct subclass , CatExclusionYN from VW_StockAgeing_BD_202604
where dept2='Tech'

*/

UPDATE VW_StockAgeing_BD_202604
SET Total_Prov$ = 0

-- 1- Update new provision based on new rules --category exclusions
UPDATE VW_StockAgeing_BD_202604
SET Total_Prov$ =
CASE 
    WHEN dept2 = 'tech' 
         AND CatExclusionYN = 'Y'
         AND stockbracket NOT IN ('[6-9M]', '[>9M]')
        THEN 0

    WHEN dept2 = 'tech' 
         AND CatExclusionYN = 'Y'
         AND stockbracket = '[6-9M]'
        THEN (Total_Stk$ * 0.25)

    WHEN dept2 = 'tech' 
         AND CatExclusionYN = 'Y'
         AND stockbracket = '[>9M]'
        THEN (Total_Stk$ * 0.5)
END;


-- 2- Update new provision based on new rules --other tech
UPDATE VW_StockAgeing_BD_202604
SET Total_Prov$ =
CASE 
    WHEN dept2 = 'tech' 
         AND CatExclusionYN = 'N'
         AND stockbracket NOT IN ('[3-6M]','[6-9M]', '[>9M]')
        THEN 0

	WHEN dept2 = 'tech' 
         AND CatExclusionYN = 'N'
         AND stockbracket = '[3-6M]'
        THEN (Total_Stk$ * 0.1)

    WHEN dept2 = 'tech' 
         AND CatExclusionYN = 'N'
         AND stockbracket = '[6-9M]'
        THEN (Total_Stk$ * 0.25)

    WHEN dept2 = 'tech' 
         AND CatExclusionYN = 'N'
         AND stockbracket = '[>9M]'
        THEN (Total_Stk$ * 0.5)

END;

-- 3- Update new provision based on new rules --lifestyle and culture
UPDATE VW_StockAgeing_BD_202604
SET Total_Prov$ = total_Prov$4 
where dept2 in ('LIFESTYLE','CULTURE','SERVICES')
;
 

 

