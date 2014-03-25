select COUNT(id) from PU_PurchaseOrder as PurchaseOrder
where PurchaseOrder.voucherstate ='D6C5E975-900D-40D3-AEF0-5D189D230FB1' 
and {PurchaseOrder.idpartner_PartnerDTO} 
AND {PurchaseOrder.iddepartment_DepartmentDTO}
AND {PurchaseOrder.idclerk_PersonDTO} 
AND {PurchaseOrder.makerId_UserDTO} 
AND {PurchaseOrder.Idproject_ProjectDTO}
and (select count(*) from [PU_PurchaseOrder_b] as PurchaseOrderDetailDTO where PurchaseOrderDetailDTO.idPurchaseOrderDTO=PurchaseOrder.id and not({PurchaseOrderDetailDTO.Idproject_ProjectDTO})) < 1
and (select count(*) from [PU_PurchaseOrder_b] as PurchaseOrderDetailDTO where PurchaseOrderDetailDTO.idPurchaseOrderDTO=PurchaseOrder.id and not({PurchaseOrderDetailDTO.idinventory_InventoryDTO})) < 1
and (select count(*) from [PU_PurchaseOrder_b] as PurchaseOrderDetailDTO where PurchaseOrderDetailDTO.idPurchaseOrderDTO=PurchaseOrder.id and not({PurchaseOrderDetailDTO.idwarehouse_WarehouseDTO})) < 1