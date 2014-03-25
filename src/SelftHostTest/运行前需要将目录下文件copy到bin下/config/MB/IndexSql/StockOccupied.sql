--存货占用 (库存总账的金额合计)
 declare @beginDate varchar(max)
declare @endDate varchar(max)
DECLARE @sql VARCHAR(MAX)
set @sql='select sum(t.amount) as amount from ( select CAST(sum(isnull(RDRecord.ArrivalAmount,0)-isnull(RDRecord.DispatchAmount,0)) as numeric(18,2)) as Amount,sum(isnull(RDRecord.ArrivalBaseQuantity,0)-isnull(RDRecord.DispatchBaseQuantity,0)) as BaseQuantity,sum(isnull(RDRecord.ArrivalSubQuantity,0)-isnull(RDRecord.DispatchSubQuantity,0)) SubQuantity,CAST(0.00 as numeric(18,2)) as OccupancyRate,
InventoryClass.InventoryClassName_lev1 as invClassName   from ST_RDDetail as RDRecord
 inner join  AA_Inventory   as Inventory on RDRecord.IDInventory=Inventory.ID
 left join  AA_InventoryClass_Ext as InventoryClass on Inventory.idInventoryClass=InventoryClass.id 
 where     {RDRecord.IDwarehouse_$warehouseDTO} and {RDRecord.IDInventory_$inventoryDTO}   and 
  {rdrecordvoucherdate} 
 group by InventoryClass.InventoryClassName_lev1 having abs(SUM(isnull(RDRecord.ArrivalAmount,0)-isnull(RDRecord.DispatchAmount,0)))>0.005 or SUM(isnull(RDRecord.ArrivalBaseQuantity,0)-isnull(RDRecord.DispatchBaseQuantity,0))<>0) as t'
  select  @beginDate =CONVERT(varchar(100),  (select begindate from sm_period where id in ( select idenableperiod from EAP_AccInformation where name='stock' or name='StdIERP')), 23)+' 00:00:00'
select  @endDate =CONVERT(varchar(100),  (select enddate from sm_period where  CONVERT(varchar(100), GETDATE(), 23) between begindate and enddate), 23)+' 00:00:00'

  set @sql=replace(@sql,' {rdrecordvoucherdate}','rdrecord.voucherdate <= '''+@enddate+''' and VoucherState=''CB61249F-8222-44E0-B177-61FBC108AB61''  and (VoucherDate>='''+@begindate+''' or 
IDVoucherType=''AC3E4CA8-18ED-4E48-8464-F64379BCB10D'')') 

exec (@sql)