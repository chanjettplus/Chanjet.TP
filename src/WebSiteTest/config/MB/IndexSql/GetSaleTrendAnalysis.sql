/*********************************销售趋势分析*****************/
Declare  @temp int
set @temp=(select value from EAP_AccInformation where Name='SAAccount')
if( @temp=0)
select voucherYear,voucherMonth,SUM(taxAmount) as Amount from (select  
	                (DATENAME(Year,SaleDelivery.voucherdate)) as voucherYear,(DATENAME (MONTH,SaleDelivery.voucherdate)) as voucherMonth,
              
sum( SaleDeliveryDetailDTO.taxAmount ) as taxAmount from  SA_SaleDelivery_b as SaleDeliveryDetailDTO
 Inner join   SA_SaleDelivery  as SaleDelivery on SaleDeliveryDetailDTO.idSaleDeliveryDTO=SaleDelivery.id  
inner join aa_inventory  as inventory on SaleDeliveryDetailDTO.idinventory=inventory.id
 where  1=1   
 and  {SaleDeliveryDetailDTO.idwarehouse_WarehouseDTO} and {SaleDeliveryDetailDTO.idinventory_InventoryDTO} and {SaleDeliveryDetailDTO.idproject_ProjectDTO} and {SaleDelivery.iddepartment_DepartmentDTO} and {SaleDelivery.idclerk_PersonDTO} and {SaleDelivery.idsettleCustomer_PartnerDTO}
 and (SaleDelivery.voucherdate>=(select min(begindate) from SM_Period) and SaleDelivery.voucherdate <=(select max(enddate) from SM_Period))
  group by SaleDelivery.voucherdate) a group by voucherMonth,voucherYear
  /*********************************销售趋势分析 发票立账*****************/
else
select voucherYear,voucherMonth,SUM(taxAmount) as Amount from (select  
	                (DATENAME(Year,SaleDelivery.voucherdate)) as voucherYear,(DATENAME (MONTH,SaleDelivery.voucherdate)) as voucherMonth,
              
sum( SaleDeliveryDetailDTO.taxAmount ) as taxAmount from  SA_SaleInvoice_b as SaleDeliveryDetailDTO
 Inner join   SA_SaleInvoice  as SaleDelivery on SaleDeliveryDetailDTO.idSaleInvoiceDTO=SaleDelivery.id  
inner join aa_inventory  as inventory on SaleDeliveryDetailDTO.idinventory=inventory.id
 where  1=1   
 and   {SaleDeliveryDetailDTO.idwarehouse_WarehouseDTO} and {SaleDeliveryDetailDTO.idinventory_InventoryDTO} and {SaleDeliveryDetailDTO.idproject_ProjectDTO} and {SaleDelivery.iddepartment_DepartmentDTO} and {SaleDelivery.idclerk_PersonDTO} and {SaleDelivery.idsettleCustomer_PartnerDTO}
 and (SaleDelivery.voucherdate>=(select min(begindate) from SM_Period) and SaleDelivery.voucherdate <=(select max(enddate) from SM_Period))
  group by SaleDelivery.voucherdate) a group by voucherMonth,voucherYear
