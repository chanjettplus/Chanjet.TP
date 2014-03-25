---本月新增客户--
select COUNT(id) as number from AA_partner
 where partnerType in ('45A62402-6AAF-42DE-9A27-7BA96B9B9D2C','0C90A0C3-960D-493A-869D-72D97189E4FC') and (datediff(MONTH,createdTime,GETDATE())=0)