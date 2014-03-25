--销售日报
Declare  @temp int
set @temp=(select value from EAP_AccInformation where Name='SAAccount')
if( @temp=0)
	SELECT 
	'Clerk' as SearchType,
	dto.idclerk as idtemp, 
	Sum(detail.taxamount) AS amount
	FROM   SA_SaleDelivery_b AS detail
	INNER JOIN SA_SaleDelivery AS dto
	ON detail.idSaleDeliveryDTO = dto.id
	WHERE datediff(day,dto.voucherdate,getdate())=0
	AND dto.voucherstate = 'CB61249F-8222-44E0-B177-61FBC108AB61'
    and {dto.idcustomer_PartnerDTO}
	and {dto.iddepartment_DepartmentDTO}
	and {dto.idclerk_PersonDTO}
	and {dto.makerid_UserDTO}
	and {detail.idinventory_InventoryDTO}
	and {detail.idproject_ProjectDTO}
	and {detail.idwarehouse_WarehouseDTO}
	and dto.idclerk is not null
	group by dto.idclerk 
	union
	SELECT 
	'Customer' as SearchType,
	dto.idcustomer as idtemp, 
	Sum(detail.taxamount) AS amount
	FROM   SA_SaleDelivery_b AS detail
	INNER JOIN SA_SaleDelivery AS dto
	ON detail.idSaleDeliveryDTO = dto.id
	WHERE datediff(day,dto.voucherdate,getdate())=0
	AND dto.voucherstate = 'CB61249F-8222-44E0-B177-61FBC108AB61'
    and {dto.idcustomer_PartnerDTO}
	and {dto.iddepartment_DepartmentDTO}
	and {dto.idclerk_PersonDTO}
	and {dto.makerid_UserDTO}
	and {detail.idinventory_InventoryDTO}
	and {detail.idproject_ProjectDTO}
	and {detail.idwarehouse_WarehouseDTO}
	group by dto.idcustomer 
	union
	SELECT 
	'Inventory' as SearchType,
	detail.idinventory as idtemp, 
	Sum(detail.taxamount) AS amount
	FROM   SA_SaleDelivery_b AS detail
	INNER JOIN SA_SaleDelivery AS dto
	ON detail.idSaleDeliveryDTO = dto.id
	WHERE datediff(day,dto.voucherdate,getdate())=0
	AND dto.voucherstate = 'CB61249F-8222-44E0-B177-61FBC108AB61'
    and {dto.idcustomer_PartnerDTO}
	and {dto.iddepartment_DepartmentDTO}
	and {dto.idclerk_PersonDTO}
	and {dto.makerid_UserDTO}
	and {detail.idinventory_InventoryDTO}
	and {detail.idproject_ProjectDTO}
	and {detail.idwarehouse_WarehouseDTO}
	group by detail.idinventory
	union
	SELECT 
	'InventoryClass' as SearchType,
	InventoryClass.id as idtemp, 
	Sum(detail.taxamount) AS amount
	FROM   SA_SaleDelivery_b AS detail
	INNER JOIN SA_SaleDelivery AS dto
	ON detail.idSaleDeliveryDTO = dto.id
	inner join AA_Inventory inventory on detail.idinventory = inventory.id
	inner join AA_InventoryClass InventoryClass on inventory.idinventoryclass = InventoryClass.id
	WHERE datediff(day,dto.voucherdate,getdate())=0
	AND dto.voucherstate = 'CB61249F-8222-44E0-B177-61FBC108AB61'
    and {dto.idcustomer_PartnerDTO}
	and {dto.iddepartment_DepartmentDTO}
	and {dto.idclerk_PersonDTO}
	and {dto.makerid_UserDTO}
	and {detail.idinventory_InventoryDTO}
	and {detail.idproject_ProjectDTO}
	and {detail.idwarehouse_WarehouseDTO}
	group by InventoryClass.id
else
	SELECT 
	'Clerk' as SearchType,
	dto.idclerk as idtemp, 
	Sum(detail.taxamount) AS amount
	FROM   SA_SaleInvoice_b AS detail
	INNER JOIN SA_SaleInvoice AS dto
	ON detail.idSaleInvoiceDTO = dto.id
	WHERE datediff(day,dto.voucherdate,getdate())=0
	AND dto.voucherstate = 'CB61249F-8222-44E0-B177-61FBC108AB61'
    and {dto.idcustomer_PartnerDTO}
	and {dto.iddepartment_DepartmentDTO}
	and {dto.idclerk_PersonDTO}
	and {dto.makerid_UserDTO}
	and {detail.idinventory_InventoryDTO}
	and {detail.idproject_ProjectDTO}
	and {detail.idwarehouse_WarehouseDTO}
    and dto.idclerk is not null
	group by dto.idclerk 
	union all
	SELECT 
	'Customer' as SearchType,
	dto.idcustomer as idtemp, 
	Sum(detail.taxamount) AS amount
	FROM   SA_SaleInvoice_b AS detail
	INNER JOIN SA_SaleInvoice AS dto
	ON detail.idSaleInvoiceDTO = dto.id
	WHERE datediff(day,dto.voucherdate,getdate())=0
	AND dto.voucherstate = 'CB61249F-8222-44E0-B177-61FBC108AB61'
    and {dto.idcustomer_PartnerDTO}
	and {dto.iddepartment_DepartmentDTO}
	and {dto.idclerk_PersonDTO}
	and {dto.makerid_UserDTO}
	and {detail.idinventory_InventoryDTO}
	and {detail.idproject_ProjectDTO}
	and {detail.idwarehouse_WarehouseDTO}
	group by dto.idcustomer 
	union
	SELECT 
	'Inventory' as SearchType,
	detail.idinventory as idtemp, 
	Sum(detail.taxamount) AS amount
	FROM   SA_SaleInvoice_b AS detail
	INNER JOIN SA_SaleInvoice AS dto
	ON detail.idSaleInvoiceDTO = dto.id
	WHERE datediff(day,dto.voucherdate,getdate())=0
	AND dto.voucherstate = 'CB61249F-8222-44E0-B177-61FBC108AB61'
    and {dto.idcustomer_PartnerDTO}
	and {dto.iddepartment_DepartmentDTO}
	and {dto.idclerk_PersonDTO}
	and {dto.makerid_UserDTO}
	and {detail.idinventory_InventoryDTO}
	and {detail.idproject_ProjectDTO}
	and {detail.idwarehouse_WarehouseDTO}
	group by detail.idinventory
	union
	SELECT 
	'InventoryClass' as SearchType,
	InventoryClass.id as idtemp, 
	Sum(detail.taxamount) AS amount
	FROM   SA_SaleInvoice_b AS detail
	INNER JOIN SA_SaleInvoice AS dto
	ON detail.idSaleInvoiceDTO = dto.id
	inner join AA_Inventory inventory on detail.idinventory = inventory.id
	inner join AA_InventoryClass InventoryClass on inventory.idinventoryclass = InventoryClass.id
	WHERE datediff(day,dto.voucherdate,getdate())=0
	AND dto.voucherstate = 'CB61249F-8222-44E0-B177-61FBC108AB61'
    and {dto.idcustomer_PartnerDTO}
	and {dto.iddepartment_DepartmentDTO}
	and {dto.idclerk_PersonDTO}
	and {dto.makerid_UserDTO}
	and {detail.idinventory_InventoryDTO}
	and {detail.idproject_ProjectDTO}
	and {detail.idwarehouse_WarehouseDTO}
	group by InventoryClass.id
