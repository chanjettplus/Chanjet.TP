--今日销量最多商品 销货单立账(发票立账把SaleDelivery修改为saleinvoice)--

  Declare  @temp int
  set @temp=(select value from EAP_AccInformation where Name='SAAccount')
 if( @temp=0)
  select mainTmp.idinventory as invID, mainTmp.amount,mainTmp.quantity,inv.name as invName,unit.name as unitName from (
select top 1 sum(voucherInfo.amount) as amount,sum(voucherInfo.quantity) as quantity, voucherInfo.idbaseunit,voucherInfo.idinventory  from 
(
select RetailDetail.taxamount as amount, RetailDetail.basequantity as quantity, RetailDetail.idinventory,RetailDetail.idbaseunit from RE_Retail as RetailDTO 
inner join RE_Retail_b as RetailDetail on RetailDTO.ID=RetailDetail.idretailDTO
where datediff(day,RetailDTO.voucherdate,getdate())=0 
 and {RetailDTO.idstore_StoreDTO} 
    and {RetailDTO.makerid_userdto} 
and {RetailDetail.idinventory_InventoryDTO} 
union all
 select detail.taxamount as amount,detail.baseQuantity as quantity,detail.idinventory,detail.idbaseunit from SA_SaleDelivery_b detail 
left join SA_SaleDelivery dto on  dto.id=detail.idSaleDeliveryDTO
where datediff(day,voucherdate,getdate())=0 
 and {dto.idcustomer_PartnerDTO}
   and {dto.makerid_userdto} 
 and {dto.iddepartment_DepartmentDTO}
 and {dto.idclerk_PersonDTO}
 and {detail.idinventory_InventoryDTO}
 and {detail.idproject_ProjectDTO}
 and {detail.idwarehouse_WarehouseDTO}
) as voucherInfo
group by idinventory,idbaseunit  order by quantity desc 
) mainTmp
left join AA_Inventory inv on mainTmp.idinventory = inv.id
left join AA_Unit unit on mainTmp.idbaseunit = unit.id
else
 select mainTmp.idinventory as invID,  mainTmp.amount,mainTmp.quantity,inv.name as invName,unit.name as unitName from (
select top 1 sum(voucherInfo.amount) as amount,sum(voucherInfo.quantity) as quantity,voucherInfo.idinventory, voucherInfo.idbaseunit from 
(
select RetailDetail.taxamount as amount,RetailDetail.baseQuantity as quantity,RetailDetail.idinventory,RetailDetail.idbaseunit from RE_Retail as RetailDTO 
inner join RE_Retail_b as RetailDetail on RetailDTO.ID=RetailDetail.idretailDTO
where datediff(day,RetailDTO.voucherdate,getdate())=0 
 and {RetailDTO.idstore_StoreDTO} 
     and {RetailDTO.makerid_userdto} 
and {RetailDetail.idinventory_InventoryDTO} 
union all
select detail.taxamount as amount,detail.baseQuantity as quantity,detail.idinventory,detail.idbaseunit from SA_SaleInvoice_b detail 
left join SA_SaleInvoice dto on  dto.id=detail.idSaleInvoiceDTO
where datediff(day,voucherdate,getdate())=0 
 and {dto.idcustomer_PartnerDTO}
    and {dto.makerid_userdto} 
 and {dto.iddepartment_DepartmentDTO}
 and {dto.idclerk_PersonDTO}
 and {detail.idinventory_InventoryDTO}
 and {detail.idproject_ProjectDTO}
 and {detail.idwarehouse_WarehouseDTO}
) as voucherInfo
group by idinventory,idbaseunit  order by quantity desc 
) mainTmp
left join AA_Inventory inv on mainTmp.idinventory = inv.id
left join AA_Unit unit on mainTmp.idbaseunit = unit.id