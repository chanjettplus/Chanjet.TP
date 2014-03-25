select COUNT(id) from SA_SaleOrder as SaleOrder 
where voucherstate ='D6C5E975-900D-40D3-AEF0-5D189D230FB1'
and {SaleOrder.idcustomer_PartnerDTO}
AND {SaleOrder.IdsettleCustomer_PartnerDTO}
AND {SaleOrder.idDepartment_DepartmentDTO}
AND {SaleOrder.idClerk_PersonDTO} 
AND {SaleOrder.Idproject_ProjectDTO}
AND {SaleOrder.makerId_UserDTO}-----销售订单个数
and (select count(*) from [SA_SaleOrder_b] as SaleOrderDetailDTO where SaleOrderDetailDTO.idsaleorderdto=SaleOrder.id and not({SaleOrderDetailDTO.Idproject_ProjectDTO})) < 1
and (select count(*) from [SA_SaleOrder_b] as SaleOrderDetailDTO where SaleOrderDetailDTO.idsaleorderdto=SaleOrder.id and not({SaleOrderDetailDTO.idinventory_InventoryDTO})) < 1
and (select count(*) from [SA_SaleOrder_b] as SaleOrderDetailDTO where SaleOrderDetailDTO.idsaleorderdto=SaleOrder.id and not({SaleOrderDetailDTO.idwarehouse_WarehouseDTO})) < 1