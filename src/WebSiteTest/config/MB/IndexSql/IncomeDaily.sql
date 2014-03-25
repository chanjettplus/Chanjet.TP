--收入日报 单据日期为服务器登录日期的收入单、销售立账单据
Declare  @temp int
set @temp=(select value from EAP_AccInformation where Name='SAAccount')
if(@temp=0) ---单据立账
SELECT '销售收入' as name,Sum(saledeliverydetaildto.taxamount) AS Amount   
FROM sa_saledelivery_b AS saledeliverydetaildto
Inner join SA_SaleDelivery  as saledelivery on saledeliverydetaildto.idSaleDeliveryDTO=saledelivery.id  
inner join aa_inventory  as inventory on saledeliverydetaildto.idinventory=inventory.id
WHERE {saledelivery.idclerk_PersonDTO} 
and {saledelivery.idcustomer_PartnerDTO} 
and {saledelivery.iddepartment_DepartmentDTO}
and {saledelivery.makerid_UserDTO}
and {saledeliverydetaildto.idinventory_InventoryDTO} 
and {saledeliverydetaildto.idproject_ProjectDTO} 
and {saledeliverydetaildto.idwarehouse_WarehouseDTO}
AND datediff(day,saledelivery.voucherdate,getdate())=0
and saledelivery.voucherState='CB61249F-8222-44E0-B177-61FBC108AB61'
union all
--现金 收入单统计表
select IncomeItem.Incomename_lev1 as name,
sum(Detail.TaxAmount) as Amount  
from  CS_IncomeVoucher_b as Detail
left join   AA_Income_Ext as IncomeItem on Detail.idincomeitem = IncomeItem.[id]
left join   CS_IncomeVoucher   as IncomeVoucherDTO on Detail.idIncomeVoucherDTO = IncomeVoucherDTO.[id]
left join   eap_EnumItem   as VoucherState on IncomeVoucherDTO.voucherState = VoucherState.[id]
LEFT JOIN EAP_Menu ON (EAP_Menu.Code='cs03') 
where datediff(day,IncomeVoucherDTO.voucherdate,GETDATE())=0
and ({IncomeVoucherDTO.Idpartner_PartnerDTO}  
and {IncomeVoucherDTO.idDepartment_DepartmentDTO}
and {IncomeVoucherDTO.idClerk_PersonDTO}
and {IncomeVoucherDTO.makerid_UserDTO}
and {IncomeVoucherDTO.idstore_StoreDTO}
and {Detail.idproject_ProjectDTO}) 
group by IncomeItem.Incomeid_lev1,IncomeItem.Incomename_lev1
union all
--零售
select '零售收入' as name, sum(RetailDetail.taxamount) from RE_Retail as RetailDTO 
inner join RE_Retail_b as RetailDetail on RetailDTO.ID=RetailDetail.idretailDTO
where datediff(day,RetailDTO.voucherdate,getdate())=0 
 and {RetailDTO.idstore_StoreDTO} 
and {RetailDetail.idinventory_InventoryDTO} 
else
SELECT '销售收入' as name,Sum(saleInvoicedetaildto.TaxAmount) AS Amount   
FROM SA_SaleInvoice_b AS saleInvoicedetaildto
INNER JOIN SA_SaleInvoice AS saleInvoice ON saleInvoicedetaildto.idSaleInvoiceDTO = saleInvoice.id
WHERE {saleInvoice.idclerk_PersonDTO} 
and {saleInvoice.idcustomer_PartnerDTO} 
and {saleInvoice.iddepartment_DepartmentDTO} 
and {saleInvoice.makerid_UserDTO}
and {saleInvoicedetaildto.idinventory_InventoryDTO} 
and {saleInvoicedetaildto.idproject_ProjectDTO} 
and {saleInvoicedetaildto.idwarehouse_WarehouseDTO}
AND datediff(day,saleInvoice.voucherdate,getdate())=0
and saleInvoice.voucherState='CB61249F-8222-44E0-B177-61FBC108AB61'
union all
--现金 收入单统计表
select IncomeItem.Incomename_lev1 as name,
sum(Detail.TaxAmount) as Amount  
from  CS_IncomeVoucher_b as Detail
left join   AA_Income_Ext as IncomeItem on Detail.idincomeitem = IncomeItem.[id]
left join   CS_IncomeVoucher   as IncomeVoucherDTO on Detail.idIncomeVoucherDTO = IncomeVoucherDTO.[id]
left join   eap_EnumItem   as VoucherState on IncomeVoucherDTO.voucherState = VoucherState.[id]
LEFT JOIN EAP_Menu ON (EAP_Menu.Code='cs03') 
where datediff(day,IncomeVoucherDTO.voucherdate,GETDATE())=0
and ({IncomeVoucherDTO.Idpartner_PartnerDTO}  
and {IncomeVoucherDTO.idDepartment_DepartmentDTO}
and {IncomeVoucherDTO.idClerk_PersonDTO}
and {IncomeVoucherDTO.makerid_UserDTO}
and {IncomeVoucherDTO.idstore_StoreDTO}
and {Detail.idproject_ProjectDTO}) 
group by IncomeItem.Incomeid_lev1,IncomeItem.Incomename_lev1
union all 
--零售
select '零售收入' as name, sum(RetailDetail.taxamount) from RE_Retail as RetailDTO 
inner join RE_Retail_b as RetailDetail on RetailDTO.ID=RetailDetail.idretailDTO
where datediff(day,RetailDTO.voucherdate,getdate())=0 
 and {RetailDTO.idstore_StoreDTO} 
and {RetailDetail.idinventory_InventoryDTO} 