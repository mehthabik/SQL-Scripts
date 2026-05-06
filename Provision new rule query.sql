---New Provision Rule---phase 2
alter table [dbo].[VW_StockAgeing_BD_202604]
add Total_Prov$ float null


update vw
set CatExclusionYN = 
case 
when 
tmp.exclusionyn = 'Y'
then 'Y' else 'N' END
from VW_StockAgeing_BD_202604 vw
left join temp_tbl_Provexclusions tmp
on tmp.subclass = vw.subclass

--after renaming brackets and prov from phase one query
UPDATE VW_StockAgeing_BD_202604
SET Total_Prov$ = 0

-- 1- Update new provision based on new rules --category exclusions
UPDATE VW_StockAgeing_BD_202604
SET Total_Prov$ =
CASE 
    WHEN dept2 = 'tech' 
         AND CatExclusionYN = 'Y'
         AND stockbracket NOT IN ('6-9M', '>9M')
        THEN 0

    WHEN dept2 = 'tech' 
         AND CatExclusionYN = 'Y'
         AND stockbracket = '6-9M'
        THEN (Total_Stk$ * 0.25)

    WHEN dept2 = 'tech' 
         AND CatExclusionYN = 'Y'
         AND stockbracket = '>9M'
        THEN (Total_Stk$ * 0.5)
-- part 2
    WHEN dept2 = 'tech' 
         AND CatExclusionYN = 'N'
         AND stockbracket NOT IN ('3-6M','6-9M', '>9M')
        THEN 0

	WHEN dept2 = 'tech' 
         AND CatExclusionYN = 'N'
         AND stockbracket = '3-6M'
        THEN (Total_Stk$ * 0.1)

    WHEN dept2 = 'tech' 
         AND CatExclusionYN = 'N'
         AND stockbracket = '6-9M'
        THEN (Total_Stk$ * 0.25)

    WHEN dept2 = 'tech' 
         AND CatExclusionYN = 'N'
         AND stockbracket = '>9M'
        THEN (Total_Stk$ * 0.5)

	WHEN STORETYPE IN ('Demo','Defective')
		THEN total_Prov$4 

	else total_Prov$4 

	end 

Update VW_StockAgeing_BD_202604
set Total_Prov$ = 0
where Dept2='Lifestyle'
and StockBracket='2-3M'

UPDATE VW_StockAgeing_BD_202604
SET Total_Prov$ = total_Prov$4 
where STORETYPE IN ('Demo','Defective')

/*	
-- Further update on Provision Calculation
-- Calculation Logic : 										
										
	• Lifestyle Only 									
	• Stanley brand, Demo, Defective, RTV locations will follow old calculation									
	• Change in Prov %'s for the rest of categories :									
		○ Bracket [3-6M] From 25% To 10%								
		○ Bracket [6-9M] From 50% To 30%								
		○ Brackets [>9M] and the rest of brackets remains the same as old.	
		
-- Check if impact is the same -$357k (Mar26 vs Feb)
-- created ronaldn/20260401
*/
update VW_StockAgeing_BD_202604
set Total_Prov$ = 																		
	case 									
		when StoreType in ('Demo','Defective','RTV')
			--or Brand = 'STANL'  --> commented out as of 30 apr-2026
		then Total_Prov$
		else
			case 													
			    when [StockBracket] = '3-6M' then (Total_Stk$ * 0.1)															
			    when [StockBracket] = '6-9M' then (Total_Stk$ * 0.3)
				when [StockBracket] = '>9M' then Total_Prov$
				else Total_Prov$	
			end
	end 
where Dept2 = 'Lifestyle'


 

