--进销比=单据日期为服务器日期的【采购立账单本币含税金额/销售立账本币含税金额】
declare @temp1 int
declare @temp2 int
declare @sale decimal(18,2)
declare @purchase decimal(18,2)
declare @retail decimal(18,2)
select @temp1=value from EAP_AccInformation where Name='SAAccount'
select @temp2=value from EAP_AccInformation where Name='PUAccount'
if(@temp1=0) ---销售单据立账
SELECT @sale=isnull(Sum(saledeliverydetaildto.TaxAmount),0)   
FROM sa_saledelivery_b AS saledeliverydetaildto
INNER JOIN sa_saledelivery AS saledelivery ON saledeliverydetaildto.idsaledeliverydto = saledelivery.id
WHERE {saledelivery.idclerk_PersonDTO} 
and {saledelivery.idcustomer_PartnerDTO} 
and {saledelivery.iddepartment_DepartmentDTO} 
and {saledelivery.idproject_ProjectDTO} 
and {saledelivery.idsettleCustomer_PartnerDTO}
and {saledelivery.idwarehouse_WarehouseDTO} 
and {saledeliverydetaildto.idinventory_InventoryDTO} 
and {saledeliverydetaildto.idproject_ProjectDTO} 
and {saledeliverydetaildto.idwarehouse_WarehouseDTO}
AND datediff(day,saledelivery.voucherdate,getdate())=0
and saledelivery.voucherState='CB61249F-8222-44E0-B177-61FBC108AB61'
else
SELECT @sale=isnull(Sum(saleInvoicedetaildto.TaxAmount),0)  
FROM SA_SaleInvoice_b AS saleInvoicedetaildto
INNER JOIN SA_SaleInvoice AS saleInvoice ON saleInvoicedetaildto.idSaleInvoiceDTO = saleInvoice.id
WHERE {saleInvoice.idclerk_PersonDTO} 
and {saleInvoice.idcustomer_PartnerDTO} 
and {saleInvoice.iddepartment_DepartmentDTO} 
and {saleInvoice.idproject_ProjectDTO} 
and {saleInvoice.idsettleCustomer_PartnerDTO}
and {saleInvoice.idwarehouse_WarehouseDTO} 
and {saleInvoicedetaildto.idinventory_InventoryDTO} 
and {saleInvoicedetaildto.idproject_ProjectDTO} 
and {saleInvoicedetaildto.idwarehouse_WarehouseDTO}
AND datediff(day,saleInvoice.voucherdate,getdate())=0
and saleInvoice.voucherState='CB61249F-8222-44E0-B177-61FBC108AB61'
select @retail=isnull(sum(RetailDetail.taxamount),0) from RE_Retail as RetailDTO 
inner join RE_Retail_b as RetailDetail on RetailDTO.ID=RetailDetail.idretailDTO
where datediff(day,RetailDTO.voucherdate,getdate())=0 
 and {RetailDTO.idstore_StoreDTO} 
and {RetailDetail.idinventory_InventoryDTO}
if((@sale+@retail)=0)
select 0 as Amount
else
begin
if(@temp2=0)--采购单据立账
SELECT @purchase=isnull(Sum(purchasearrivaldetaildto.taxamount),0)
FROM   pu_purchasearrival_b AS purchasearrivaldetaildto
INNER JOIN pu_purchasearrival AS purchasearrivaldto
ON purchasearrivaldetaildto.idpurchasearrivaldto = purchasearrivaldto.id
WHERE  {purchasearrivaldetaildto.idinventory_InventoryDTO} 
and {purchasearrivaldetaildto.idproject_ProjectDTO} 
and {purchasearrivaldetaildto.idwarehouse_WarehouseDTO}
and {purchasearrivaldto.idclerk_PersonDTO}
and {purchasearrivaldto.iddepartment_DepartmentDTO}
and {purchasearrivaldto.idpartner_PartnerDTO}
and {purchasearrivaldto.idproject_ProjectDTO}
and {purchasearrivaldto.idwarehouse_WarehouseDTO}
AND datediff(day,purchasearrivaldto.voucherdate,getdate())=0
AND purchasearrivaldto.voucherstate = 'CB61249F-8222-44E0-B177-61FBC108AB61'
else
SELECT @purchase=isnull(Sum(purchaseInvoicedetaildto.taxamount),0)
FROM   PU_PurchaseInvoice_b AS purchaseInvoicedetaildto
INNER JOIN PU_PurchaseInvoice AS purchaseInvoicedto
ON purchaseInvoicedetaildto.idPurchaseInvoiceDTO = purchaseInvoicedto.id
WHERE  {purchaseInvoicedetaildto.idinventory_InventoryDTO} 
and {purchaseInvoicedetaildto.idproject_ProjectDTO} 
and {purchaseInvoicedetaildto.idwarehouse_WarehouseDTO}
and {purchaseInvoicedto.idclerk_PersonDTO}
and {purchaseInvoicedto.iddepartment_DepartmentDTO}
and {purchaseInvoicedto.idpartner_PartnerDTO}
and {purchaseInvoicedto.idproject_ProjectDTO}
and {purchaseInvoicedto.idwarehouse_WarehouseDTO}
AND datediff(day,purchaseInvoicedto.voucherdate,getdate())=0
AND purchaseInvoicedto.voucherstate = 'CB61249F-8222-44E0-B177-61FBC108AB61'
select @purchase/(@retail+@sale) as Amount
end