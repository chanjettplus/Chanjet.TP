select COUNT(id) from SA_SaleDelivery as SaleDelivery
where SaleDelivery.voucherstate ='D6C5E975-900D-40D3-AEF0-5D189D230FB1' and SaleDelivery.IsBeforeSystemInuse=0 
and {SaleDelivery.idcustomer_PartnerDTO}
AND {SaleDelivery.IdsettleCustomer_PartnerDTO}
AND {SaleDelivery.iddepartment_DepartmentDTO}
AND {SaleDelivery.idclerk_PersonDTO}
AND {SaleDelivery.makerId_UserDTO}
AND {SaleDelivery.Idproject_ProjectDTO}
and (select count(*) from [sa_saledelivery_b] as saledeliverydetaildto where saledeliverydetaildto.idSaleDeliveryDTO=SaleDelivery.id and not({saledeliverydetaildto.Idproject_ProjectDTO})) < 1
and (select count(*) from [sa_saledelivery_b] as saledeliverydetaildto where saledeliverydetaildto.idSaleDeliveryDTO=SaleDelivery.id and not({saledeliverydetaildto.idinventory_InventoryDTO})) < 1
and (select count(*) from [sa_saledelivery_b] as saledeliverydetaildto where saledeliverydetaildto.idSaleDeliveryDTO=SaleDelivery.id and not({saledeliverydetaildto.idwarehouse_WarehouseDTO})) < 1