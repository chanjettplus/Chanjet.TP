--销存差=【单据日期同服务器日期的（销售立账单据+零售单）的本币含税金额合计】—【库存明细账开始日期为空，结束日期为服务器日期的所有存货的结存金额合计】；零售单本版不处理。
Declare  @temp int
set @temp=(select value from EAP_AccInformation where Name='SAAccount')
--存货占用 (库存总账的金额合计)
 declare @strAccountperiod as decimal(7,2)
 declare @strCurrentperiod as decimal(7,2)
 select @strCurrentperiod=currentyear+0.01*currentperiod from sm_period where  CONVERT(varchar(100), GETDATE(), 23) between begindate and enddate
 select @strAccountperiod=currentyear+0.01*currentperiod from SM_Period where id in(select idEnablePeriod from EAP_AccInformation where name='stock' or name='StdIERP')
 
if(@temp=0) ---单据立账
select
(SELECT isnull(Sum(saledeliverydetaildto.taxamount),0) AS taxamount   
FROM sa_saledelivery_b AS saledeliverydetaildto
Inner join   SA_SaleDelivery  as saledelivery on saledeliverydetaildto.idSaleDeliveryDTO=saledelivery.id  
inner join aa_inventory  as inventory on saledeliverydetaildto.idinventory=inventory.id
WHERE {saledelivery.idclerk_PersonDTO} 
and {saledelivery.idcustomer_PartnerDTO} 
and {saledelivery.iddepartment_DepartmentDTO}
and {saledeliverydetaildto.idinventory_InventoryDTO} 
and {saledeliverydetaildto.idproject_ProjectDTO} 
and {saledeliverydetaildto.idwarehouse_WarehouseDTO}
AND datediff(day,saledelivery.voucherdate,getdate())=0
and saledelivery.voucherState='CB61249F-8222-44E0-B177-61FBC108AB61')
+
(
select isnull(sum(RetailDetail.taxamount),0) from RE_Retail as RetailDTO 
inner join RE_Retail_b as RetailDetail on RetailDTO.ID=RetailDetail.idretailDTO
where datediff(day,RetailDTO.voucherdate,getdate())=0 
 and {RetailDTO.idstore_StoreDTO} 
and {RetailDetail.idinventory_InventoryDTO} 
)
-
(select isnull((SUM(BeginAmount)+SUM(ArrivalAmount)-SUM(DispatchAmount)),0) as amount from (
 SELECT 
  sum( isnull(InAmount,0)-isnull(OutAmount,0) ) as BeginAmount,
  sum( 0 ) as ArrivalAmount,
  sum( 0 ) as DispatchAmount
  from ST_SubsidiaryBook as RDDetail
  where 
    {RDDetail.idinventory_InventoryDTO} 
    and {RDDetail.idproject_ProjectDTO} 
	and {RDDetail.idwarehouse_WarehouseDTO}
	and
  (accountperiod=0 or  (accountperiod>0 or accountperiod<0)  and 
  accountyear+0.01*accountperiod<=@strCurrentperiod  and accountyear+0.01*accountperiod>=@strAccountperiod)
  ) t)
as Amount
else
select
(SELECT isnull(Sum(saleInvoicedetaildto.TaxAmount),0) AS taxamount   
FROM SA_SaleInvoice_b AS saleInvoicedetaildto
INNER JOIN SA_SaleInvoice AS saleInvoice ON saleInvoicedetaildto.idSaleInvoiceDTO = saleInvoice.id
WHERE {saleInvoice.idclerk_PersonDTO} 
and {saleInvoice.idcustomer_PartnerDTO} 
and {saleInvoice.iddepartment_DepartmentDTO}  
and {saleInvoicedetaildto.idinventory_InventoryDTO} 
and {saleInvoicedetaildto.idproject_ProjectDTO} 
and {saleInvoicedetaildto.idwarehouse_WarehouseDTO}
AND datediff(day,saleInvoice.voucherdate,getdate())=0
and saleInvoice.voucherState='CB61249F-8222-44E0-B177-61FBC108AB61')
+
(
select isnull(sum(RetailDetail.taxamount),0) from RE_Retail as RetailDTO 
inner join RE_Retail_b as RetailDetail on RetailDTO.ID=RetailDetail.idretailDTO
where datediff(day,RetailDTO.voucherdate,getdate())=0 
 and {RetailDTO.idstore_StoreDTO} 
and {RetailDetail.idinventory_InventoryDTO} 
)
-
(select isnull((SUM(BeginAmount)+SUM(ArrivalAmount)-SUM(DispatchAmount)),0) as amount from (
 SELECT 
  sum( isnull(InAmount,0)-isnull(OutAmount,0) ) as BeginAmount,
  sum( 0 ) as ArrivalAmount,
  sum( 0 ) as DispatchAmount
  from ST_SubsidiaryBook as RDDetail
  where 
    {RDDetail.idinventory_InventoryDTO} 
    and {RDDetail.idproject_ProjectDTO} 
	and {RDDetail.idwarehouse_WarehouseDTO}
	and
  (accountperiod=0 or  (accountperiod>0 or accountperiod<0)  and 
  accountyear+0.01*accountperiod<=@strCurrentperiod  and accountyear+0.01*accountperiod>=@strAccountperiod)
  )t
)
as Amount