---费用日报  单据日期为服务器登录日期的费用单、采购立账单据
Declare  @temp int
set @temp=(select value from EAP_AccInformation where Name='PUAccount')
if(@temp=0) ---单据立账
SELECT '采购劳务费' as name,Sum(purchasearrivaldetaildto.taxamount) AS amount
FROM   pu_purchasearrival_b AS purchasearrivaldetaildto
INNER JOIN pu_purchasearrival AS purchasearrivaldto
ON purchasearrivaldetaildto.idpurchasearrivaldto = purchasearrivaldto.id
left join AA_Inventory as Inventory on purchasearrivaldetaildto.idinventory=Inventory.id
WHERE  {purchasearrivaldetaildto.idinventory_InventoryDTO} 
and {purchasearrivaldetaildto.idproject_ProjectDTO} 
and {purchasearrivaldetaildto.idwarehouse_WarehouseDTO}
and {purchasearrivaldto.idclerk_PersonDTO}
and {purchasearrivaldto.makerid_UserDTO}
and {purchasearrivaldto.iddepartment_DepartmentDTO}
and {purchasearrivaldto.idpartner_PartnerDTO}
and {purchasearrivaldto.idproject_ProjectDTO}
and {purchasearrivaldto.idwarehouse_WarehouseDTO}
AND datediff(day,purchasearrivaldto.voucherdate,getdate())=0
AND purchasearrivaldto.voucherstate = 'CB61249F-8222-44E0-B177-61FBC108AB61'
and Inventory.IsLaborCost=1 ---是劳务存货
union all
-----费用单 按费用类别汇总
select expType.Name as name,sum(Detail.TaxAmount) as Amount 
from CS_ExpenseVoucher_b as Detail
left join  CS_ExpenseVoucher as ExpenseVoucherDTO on Detail.idExpenseVoucherDTO= ExpenseVoucherDTO.id
left join AA_ExpenseItem as expItem on Detail.idexpenseitem=expItem.id
inner join eap_EnumItem as expType on expItem.expenseType=expType.id
where datediff(day,ExpenseVoucherDTO.voucherdate,getdate())=0
and ({ExpenseVoucherDTO.iddepartment_DepartmentDTO}
and {ExpenseVoucherDTO.idClerk_PersonDTO}
and {ExpenseVoucherDTO.makerid_UserDTO}
and {ExpenseVoucherDTO.idstore_StoreDTO}
and {ExpenseVoucherDTO.idpartner_PartnerDTO}
and {Detail.idproject_ProjectDTO}) 
group by expType.Name
else
SELECT '采购劳务费' as name,Sum(purchaseInvoicedetaildto.taxamount) AS amount
FROM   PU_PurchaseInvoice_b AS purchaseInvoicedetaildto
INNER JOIN PU_PurchaseInvoice AS purchaseInvoicedto
ON purchaseInvoicedetaildto.idPurchaseInvoiceDTO = purchaseInvoicedto.id
left join AA_Inventory as Inventory on purchaseInvoicedetaildto.idinventory=Inventory.id
WHERE  {purchaseInvoicedetaildto.idinventory_InventoryDTO} 
and {purchaseInvoicedetaildto.idproject_ProjectDTO} 
and {purchaseInvoicedetaildto.idwarehouse_WarehouseDTO}
and {purchaseInvoicedto.idclerk_PersonDTO}
and {purchaseInvoicedto.makerid_UserDTO}
and {purchaseInvoicedto.iddepartment_DepartmentDTO}
and {purchaseInvoicedto.idpartner_PartnerDTO}
and {purchaseInvoicedto.idproject_ProjectDTO}
and {purchaseInvoicedto.idwarehouse_WarehouseDTO}
AND datediff(day,purchaseInvoicedto.voucherdate,getdate())=0
AND purchaseInvoicedto.voucherstate = 'CB61249F-8222-44E0-B177-61FBC108AB61'
and Inventory.IsLaborCost=1 ---是劳务存货
union all
-----费用单 按费用类别汇总
select expType.Name as name,sum(Detail.TaxAmount) as Amount 
from CS_ExpenseVoucher_b as Detail
left join  CS_ExpenseVoucher as ExpenseVoucherDTO on Detail.idExpenseVoucherDTO= ExpenseVoucherDTO.id
left join AA_ExpenseItem as expItem on Detail.idexpenseitem=expItem.id
inner join eap_EnumItem as expType on expItem.expenseType=expType.id
where datediff(day,ExpenseVoucherDTO.voucherdate,getdate())=0
and ({ExpenseVoucherDTO.iddepartment_DepartmentDTO}
and {ExpenseVoucherDTO.idClerk_PersonDTO}
and {ExpenseVoucherDTO.makerid_UserDTO}
and {ExpenseVoucherDTO.idstore_StoreDTO}
and {ExpenseVoucherDTO.idpartner_PartnerDTO}
and {Detail.idproject_ProjectDTO}) 
group by expType.Name