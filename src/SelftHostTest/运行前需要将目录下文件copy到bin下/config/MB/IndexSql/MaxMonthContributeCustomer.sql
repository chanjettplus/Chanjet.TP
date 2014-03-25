  --本月贡献最大--
 Declare  @temp int
 set @temp=(select value from EAP_AccInformation where Name='SAAccount')
 if( @temp=0)
   select top 1 * 
   from 
   (
   select  customer.id as cusid,  isnull(sum( detail.taxAmount),0) as amount,Customer.name as cusname from aa_partner customer
   left join sa_saleDelivery dto on dto.idcustomer=customer.id
left join SA_SaleDelivery_b detail on  detail.idSaleDeliveryDTO=dto.id
left join AA_Inventory inv on inv.id=detail.idinventory
where datediff(MONTH,dto.voucherdate,GETDATE())=0  and  {detail.idwarehouse_WareHouseDTO} and {detail.idproject_projectDTO} and {detail.idinventory_inventoryDTO} and {dto.idcustomer_PartnerDTO} and {dto.idclerk_personDTO} and {dto.iddepartment_departmentDTO} and {dto.makerid_userdto}
group by Customer.name ,customer.id 
union all
select  Store.id as cusid,  isnull(sum(RetailDetail.taxamount),0) as amount,Store.name as  cusname
from  AA_DR_Store as Store 
inner join RE_Retail as RetailDTO on RetailDTO.idstore=Store.ID
inner join RE_Retail_b as RetailDetail on RetailDTO.ID=RetailDetail.idretailDTO
where datediff(month,RetailDTO.voucherdate,getdate())=0 
and Store.storetype = '808442FA-A496-442E-9832-DFD51FF8801E'
and {RetailDTO.idstore_StoreDTO} 
and {RetailDetail.idinventory_InventoryDTO} 
group by RetailDTO.idstore,Store.name,store.id
 ) as t
 order by amount desc 
else
select top 1 * 
   from 
   (
  select customer.id as cusid, isnull(sum( detail.taxAmount),0) as amount,Customer.name as cusname from aa_partner customer
   left join sa_saleInvoice dto on dto.idcustomer=customer.id
left join SA_SaleInvoice_b detail on  detail.idSaleInvoiceDTO=dto.id
left join AA_Inventory inv on inv.id=detail.idinventory
where datediff(MONTH,dto.voucherdate,GETDATE())=0   and {detail.idwarehouse_WareHouseDTO} and {detail.idproject_projectDTO} and {detail.idinventory_inventoryDTO} and {dto.idcustomer_PartnerDTO} and {dto.idclerk_personDTO} and {dto.iddepartment_departmentDTO} and {dto.makerid_userdto}
group by Customer.name ,customer.id
union all
select Store.id as cusid,  isnull(sum(RetailDetail.taxamount),0) as amount,Store.name as  cusname
from  AA_DR_Store as Store 
inner join RE_Retail as RetailDTO on RetailDTO.idstore=Store.ID
inner join RE_Retail_b as RetailDetail on RetailDTO.ID=RetailDetail.idretailDTO
where datediff(month,RetailDTO.voucherdate,getdate())=0 
and Store.storetype = '808442FA-A496-442E-9832-DFD51FF8801E'
 and {RetailDTO.idstore_StoreDTO} 
and {RetailDetail.idinventory_InventoryDTO} 
group by RetailDTO.idstore,Store.name,Store.id 
) as t
order by amount desc 