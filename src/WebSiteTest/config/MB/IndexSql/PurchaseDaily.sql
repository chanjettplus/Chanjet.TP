--≤…π∫»’±®
Declare  @temp int
set @temp=(select value from EAP_AccInformation where Name='PUAccount')
if( @temp=0)
	SELECT detail.idinventory as Idinventory, 
	Sum(detail.taxamount) AS amount
	FROM   pu_purchasearrival_b AS detail
	INNER JOIN pu_purchasearrival AS dto
	ON detail.idpurchasearrivaldto = dto.id
	WHERE  1 = 1
		   AND datediff(day,dto.voucherdate,getdate())=0
		   AND dto.voucherstate = 'CB61249F-8222-44E0-B177-61FBC108AB61'
		    and {dto.idpartner_PartnerDTO}
			and {dto.iddepartment_DepartmentDTO}
			and {dto.idclerk_PersonDTO}
			and {dto.makerid_UserDTO}
			and {detail.idinventory_InventoryDTO}
			and {detail.idproject_ProjectDTO}
			and {detail.idwarehouse_WarehouseDTO}
	group by detail.idinventory
else
	SELECT detail.idinventory as Idinventory, 
	Sum(detail.taxamount) AS amount
	FROM   PU_PurchaseInvoice_b AS detail
		   INNER JOIN PU_PurchaseInvoice AS dto
			 ON detail.idPurchaseInvoiceDTO = dto.id
	WHERE  1 = 1
		   AND datediff(day,dto.voucherdate,getdate())=0
		   AND dto.voucherstate = 'CB61249F-8222-44E0-B177-61FBC108AB61'
		    and {dto.idpartner_PartnerDTO}
			and {dto.iddepartment_DepartmentDTO}
			and {dto.idclerk_PersonDTO}
			and {dto.makerid_UserDTO}
			and {detail.idinventory_InventoryDTO}
			and {detail.idproject_ProjectDTO}
			and {detail.idwarehouse_WarehouseDTO}
	group by detail.idinventory