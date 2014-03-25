--本月新增会员--
select COUNT(id) as number from AA_DR_Member where datediff(MONTH,effectivedate,GETDATE())=0