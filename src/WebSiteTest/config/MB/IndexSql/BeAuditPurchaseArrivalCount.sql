select COUNT(id) from PU_PurchaseArrival as PurchaseArrival
where PurchaseArrival.voucherstate ='D6C5E975-900D-40D3-AEF0-5D189D230FB1'
and {PurchaseArrival.idpartner_PartnerDTO}
AND {PurchaseArrival.iddepartment_DepartmentDTO} 
AND {PurchaseArrival.idclerk_PersonDTO} 
AND {PurchaseArrival.MakerId_UserDTO}
AND {PurchaseArrival.Idproject_ProjectDTO}
and (select count(*) from [pu_purchasearrival_b] as purchasearrivaldetaildto where purchasearrivaldetaildto.idPurchaseArrivalDTO=PurchaseArrival.id and not({purchasearrivaldetaildto.Idproject_ProjectDTO})) < 1
and (select count(*) from [pu_purchasearrival_b] as purchasearrivaldetaildto where purchasearrivaldetaildto.idPurchaseArrivalDTO=PurchaseArrival.id and not({purchasearrivaldetaildto.idinventory_InventoryDTO})) < 1
and (select count(*) from [pu_purchasearrival_b] as purchasearrivaldetaildto where purchasearrivaldetaildto.idPurchaseArrivalDTO=PurchaseArrival.id and not({purchasearrivaldetaildto.idwarehouse_WarehouseDTO})) < 1