--今日销售额
Declare  @temp int
set @temp=(select value from EAP_AccInformation where Name='SAAccount')
if( @temp=0)
	SELECT Sum(detail.taxamount) AS amount  
	FROM sa_saledelivery_b AS detail
	left JOIN sa_saledelivery AS dto ON detail.idsaledeliverydto = dto.id
	WHERE 1 = 1
	AND datediff(day,dto.voucherdate,getdate())=0
	and dto.voucherState='CB61249F-8222-44E0-B177-61FBC108AB61'
	and {dto.idcustomer_PartnerDTO}
	and {dto.iddepartment_DepartmentDTO}
	and {dto.idclerk_PersonDTO}
	and {dto.makerid_UserDTO}
	and {detail.idinventory_InventoryDTO}
	and {detail.idproject_ProjectDTO}
	and {detail.idwarehouse_WarehouseDTO}
else
SELECT Sum(detail.taxamount) AS amount   
	FROM SA_SaleInvoice_b AS detail
	INNER JOIN SA_SaleInvoice AS dto ON detail.idSaleInvoiceDTO = dto.id
	WHERE 1 = 1
	AND datediff(day,dto.voucherdate,getdate())=0
	and dto.voucherState='CB61249F-8222-44E0-B177-61FBC108AB61'
    and {dto.idcustomer_PartnerDTO}
	and {dto.iddepartment_DepartmentDTO}
	and {dto.idclerk_PersonDTO}
	and {dto.makerid_UserDTO}
	and {detail.idinventory_InventoryDTO}
	and {detail.idproject_ProjectDTO}
	and {detail.idwarehouse_WarehouseDTO}