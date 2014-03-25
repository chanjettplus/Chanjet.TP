--本月成单最多业务员 （条件加上单据日期）--
 Declare  @temp int
  set @temp=(select value from EAP_AccInformation where Name='SAAccount')
 if( @temp=0)
 select top 1  person.id as clerkid,  COUNT(dto.id) as number,person.name  as  clerkName,SUM(dto.taxAmount) as amount from SA_SaleDelivery  dto
 left join  AA_Person person on person.id=dto.idclerk
where idbusinesstype <>'23FBABAD-1697-41AB-9FAC-8BA86B38FF01' and dto.idclerk is not null
and datediff(MONTH,dto.voucherdate,GETDATE())=0 
and   {dto.idcustomer_PartnerDTO} and {dto.idclerk_personDTO} and {dto.iddepartment_departmentDTO}
 and {dto.makerid_userdto}
group by person.name,person.id order by number desc
else
 select top 1  person.id as clerkid, COUNT(dto.id) as number,person.name  as  clerkName,SUM(dto.taxAmount) as amount from SA_SaleInvoice  dto
 left join  AA_Person person on person.id=dto.idclerk
where  dto.idclerk is not null  and dto.idbusinesstype <>'23FBABAD-1697-41AB-9FAC-8BA86B38FF01' 
and datediff(MONTH,dto.voucherdate,GETDATE())=0 
and   {dto.idcustomer_PartnerDTO} and {dto.idclerk_personDTO} and {dto.iddepartment_departmentDTO}
 and {dto.makerid_userdto}
group by person.name,person.id order by number desc