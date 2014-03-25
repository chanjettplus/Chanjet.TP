--本月销售额最多商品 销货单立账(发票立账把SaleDelivery修改为saleinvoice)--

Declare  @temp int
set @temp=(select value from EAP_AccInformation where Name='SAAccount')
 if( @temp=0)
 select  mainTmp.idinventory as invID, mainTmp.amount,mainTmp.quantity,inv.name as invName,unit.name as unitName from (
select top 1 sum(voucherInfo.quantity) as quantity,sum(voucherInfo.amount) as amount, voucherInfo.idbaseunit,voucherInfo.idinventory  from 
(
select RetailDetail.basequantity as quantity,RetailDetail.idinventory,RetailDetail.idbaseunit,RetailDetail.taxAmount as amount from RE_Retail as RetailDTO 
inner join RE_Retail_b as RetailDetail on RetailDTO.ID=RetailDetail.idretailDTO
where datediff(month,RetailDTO.voucherdate,getdate())=0 
 and {RetailDTO.idstore_StoreDTO} 
   and {RetailDTO.makerid_userdto} 
and {RetailDetail.idinventory_InventoryDTO} 
union all
 select detail.baseQuantity as quantity,detail.idinventory,detail.idbaseunit,detail.taxAmount as amount from SA_SaleDelivery_b detail 
left join SA_SaleDelivery dto on  dto.id=detail.idSaleDeliveryDTO
where  datediff(month,voucherdate,getdate())=0 
 and {dto.idcustomer_PartnerDTO}
 and {dto.makerid_userdto} 
 and {dto.iddepartment_DepartmentDTO}
 and {dto.idclerk_PersonDTO}
 and {detail.idinventory_InventoryDTO}
 and {detail.idproject_ProjectDTO}
 and {detail.idwarehouse_WarehouseDTO}
) as voucherInfo
group by idinventory,idbaseunit  order by amount desc 
) mainTmp
left join AA_Inventory inv on mainTmp.idinventory = inv.id
left join AA_Unit unit on mainTmp.idbaseunit = unit.id
else
select  mainTmp.idinventory as invID, mainTmp.amount,mainTmp.quantity,inv.name as invName,unit.name as unitName from (
select top 1 sum(voucherInfo.quantity) as quantity,sum(voucherInfo.amount) as amount,voucherInfo.idinventory, voucherInfo.idbaseunit from 
(
select RetailDetail.basequantity as quantity,RetailDetail.idinventory,RetailDetail.idbaseunit, RetailDetail.taxAmount as amount from RE_Retail as RetailDTO 
inner join RE_Retail_b as RetailDetail on RetailDTO.ID=RetailDetail.idretailDTO
where datediff(month,RetailDTO.voucherdate,getdate())=0 
 and {RetailDTO.idstore_StoreDTO} 
  and {RetailDTO.makerid_userdto} 
and {RetailDetail.idinventory_InventoryDTO} 
union all
 select detail.baseQuantity as quantity,detail.idinventory ,detail.idbaseunit,detail.taxAmount as amount from SA_SaleInvoice_b detail 
left join SA_SaleInvoice dto on  dto.id=detail.idSaleInvoiceDTO
left join AA_Inventory inv on inv.id = detail.idinventory
left join AA_Unit unit on unit.id=detail.idbaseunit
where datediff(month,voucherdate,getdate())=0 
 and {dto.idcustomer_PartnerDTO}
 and {dto.makerid_userdto} 
 and {dto.iddepartment_DepartmentDTO}
 and {dto.idclerk_PersonDTO}
 and {detail.idinventory_InventoryDTO}
 and {detail.idproject_ProjectDTO}
 and {detail.idwarehouse_WarehouseDTO}
) as voucherInfo
group by idinventory,idbaseunit  order by amount desc 
) mainTmp
left join AA_Inventory inv on mainTmp.idinventory = inv.id
left join AA_Unit unit on mainTmp.idbaseunit = unit.id