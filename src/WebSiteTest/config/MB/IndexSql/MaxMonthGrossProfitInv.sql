
 --本月毛利最多---

Declare  @temp int
  set @temp=(select value from EAP_AccInformation where Name='SAAccount')
  
 if ( @temp=0) 
  select top 1 invid, SUM(amount) as amount,SUM(quantity) as quantity,invName,unitName from (
select mainTmp.idinventory as invID,  mainTmp.amount,mainTmp.quantity,inv.name as invName,unit.name as unitName from (
select  tmp.idinventory as idinventory,tmp.idunit as idunit,(case when abs( (ISNULL(tmp.discountAmount,0)-ISNULL(tmp.CostAmount,0)-ISNULL(tmp.expenseAmount,0)-ISNULL(tmp.allowancesAmount,0)))<0.0000001 then 0.00 else (ISNULL(tmp.discountAmount,0)-ISNULL(tmp.CostAmount,0)-ISNULL(tmp.expenseAmount,0)-ISNULL(tmp.allowancesAmount,0)) end) as amount,tmp.baseQuantity as quantity from 
(select 
Sum(SaleDeliveryDetailDTO.expenseAmount)  as  expenseAmount,
Sum(SaleDeliveryDetailDTO.discountAmount) as discountAmount,
Sum(ReceivePayment_b.allowancesAmount) as allowancesAmount,
Sum((
                    --当成本取值为非记账成本时
                    case when(00<>00) then
                        (
                            SaleDeliveryDetailDTO.baseQuantity*0
                        )
                         --当为先出库后销货情况
                         when(SaleDeliveryDetailDTO.idsourceVoucherType='BB007F33-C0F0-4A19-8588-1E0E314D1F56' or SaleDeliveryDetailDTO.idsourceVoucherType='EB475F0D-3379-4568-BB37-77877E830594') then
                        (
                            (isnull(SaleDeliveryDetailDTO.baseQuantity,0)) * ((Isnull(rdthensalerdrecord_b.amount,0)+Isnull(rdthensalerdrecord_b.dispatchAdjust,0))/rdthensalerdrecord_b.baseQuantity)
                        )
                        else
                        (
                            isnull((RDThenSaleRDThenRDRDRecord_b.totalAmount),0)+
                            isnull((isnull(SaleDeliveryDetailDTO.baseQuantity,0)- 
                            isnull(RDThenSaleRDThenRDRDRecord_b.baseQuantity,0))*isnull(Inventory.invSCost,0) ,0)  
                        )
                    end
                    ) ) as CostAmount ,
Inventory.id as idinventory,
SaleDeliveryDetailDTO.idbaseunit as idunit,
sum( SaleDeliveryDetailDTO.baseQuantity ) as baseQuantity   
 from SA_SaleDelivery_b as SaleDeliveryDetailDTO
Inner join AA_Inventory   as Inventory on SaleDeliveryDetailDTO.idinventory=Inventory.id
inner join AA_Unit as unit on SaleDeliveryDetailDTO.idbaseunit=unit.id
left join  
 (SELECT 
      sum(isnull(ST_RDRecord_b.amount,0) + ISNULL(ST_RDRecord_b.dispatchAdjust,0)) as totalAmount,
      sum(isnull(ST_RDRecord_b.baseQuantity,0)) as baseQuantity,
      ST_RDRecord_b.sourceVoucherDetailId 
      FROM ST_RDRecord_b, ST_RDRecord 
      WHERE  ST_RDRecord_b.idRDRecordDTO = ST_RDRecord.id 
      AND ST_RDRecord.voucherState ='CB61249F-8222-44E0-B177-61FBC108AB61'
      group by   ST_RDRecord_b.sourceVoucherDetailId 
  )as RDThenSaleRDThenRDRDRecord_b on RDThenSaleRDThenRDRDRecord_b.sourceVoucherDetailId =SaleDeliveryDetailDTO.id
Inner join SA_SaleDelivery   as SaleDelivery on SaleDeliveryDetailDTO.idSaleDeliveryDTO=SaleDelivery.id
left join ST_RDRecord_b as RDThenSaleRDRecord_b on SaleDeliveryDetailDTO.sourceVoucherDetailId =RDThenSaleRDRecord_b.id 
left join 
(
    select voucherDetailID as voucherDetailID, sum(allowancesAmount) as allowancesAmount 
                                            from ARAP_ReceivePayment_b ReceivePayment left join sa_saledelivery_b  saledeliverydetail on saledeliverydetail.id=ReceivePayment.voucherDetailID
                                            group by voucherDetailID
 ) as ReceivePayment_b On ReceivePayment_b.voucherDetailID=SaleDeliveryDetailDTO.id 
left join( 
 select SaleInvoiceRDInfo.sourceVoucherDetailId,SaleInvoiceRDInfo.sourceVoucherid,SaleInvoiceRDInfo.idSaleInvoiceDetailDTO,SaleInvoice_b.idSaleInvoiceDTO as voucherId
   from(
		 select sourceVoucherDetailId,sourceVoucherid, 
		 min(cast(idSaleInvoiceDetailDTO as varchar(50)))as idSaleInvoiceDetailDTO  
		 from  sa_SaleInvoiceSourceRelation
		 group by sourceVoucherDetailId,sourceVoucherid
     ) SaleInvoiceRDInfo 
  left join SA_SaleInvoice_b  SaleInvoice_b on  
   SaleInvoice_b.id = SaleInvoiceRDInfo.idSaleInvoiceDetailDTO
) as SaleInvoiceSourceRelation on SaleDeliveryDetailDTO.id=SaleInvoiceSourceRelation.sourceVoucherDetailId
and SaleInvoiceSourceRelation.sourceVoucherId =SaleDeliveryDetailDTO.idSaleDeliveryDTO
 where  1=1  And (datediff(month,SaleDelivery.voucherdate,GETDATE())=0 And (SaleDelivery.voucherState='cb61249f-8222-44e0-b177-61fbc108ab61'))
 and {SaleDelivery.iddepartment_DepartmentDTO}
 and {SaleDeliveryDetailDTO.idinventory_InventoryDTO}
 and {SaleDelivery.idclerk_PersonDTO}
 and {SaleDeliveryDetailDTO.idwarehouse_WarehouseDTO}
 and {SaleDelivery.idcustomer_PartnerDTO}
 and {SaleDelivery.idsettleCustomer_PartnerDTO} 
 and {SaleDeliveryDetailDTO.idproject_ProjectDTO}
 group by Inventory.id,SaleDeliveryDetailDTO.idbaseunit
 ) as tmp
 
 )mainTmp
 left join AA_Inventory inv on mainTmp.idinventory = inv.id
 left join AA_Unit unit on mainTmp.idunit = unit.id
 union all

select  t.invID as invID,    ISNULL(DiscountAmount,0)-ISNULL(CostAmount,0) as amount,t.Quantity as quantity,t.Inventory as invName,t.Unit as unitName from (
select inventory.id as invID,
(case when Inventory.Name is null then '' else  Inventory.Name end) as Inventory,
SUM(isnull(Detail.BaseQuantity,0)) as Quantity
                    ,SUM(isnull(RetailAmount,0)) as RetailAmount
                    ,SUM(isnull(Detail.TaxAmount,0)) as DiscountAmount
                    ,SUM(isnull(Detail.amount,0)) as CostAmount
                   ,(case when Unit.Name is null then '' else  Unit.Name end) as Unit
                      from ST_RDRecord_b as Detail
inner join AA_Inventory as Inventory on Inventory.id=Detail.idinventory
left join AA_Unit as Unit on Unit.id=Inventory.idunit
 left join ST_RDRecord as Header on Header.id=Detail.idRDRecordDTO where  1=1  And datediff(month,voucherdate,GETDATE())=0 AND Header.IDVoucherType='CE55890B-19DE-45B7-969D-99CAEB47A050'  
  and {Detail.idinventory_InventoryDTO} 

  group by Header.ID,Inventory.id,Inventory.Code,Inventory.Name,unit.name
 
 
 UNION  all
Select inventory.id as invID,
(case when Inventory.Name is null then '' else  Inventory.Name end) as Inventory,
SUM(CASE WHEN Inventory.IsLaborCost=1  THEN isnull(Detail.BaseQuantity,0)
                                               ELSE isnull(Detail.Quantity,0)
                                          END) as Quantity
                    ,SUM(isnull(RetailAmount,0)) as RetailAmount
                    ,SUM(isnull(Detail.TaxAmount,0)) as DiscountAmount
                    ,SUM(isnull(Inventory.invSCost,0)*(CASE WHEN Inventory.IsLaborCost=1 
                                               THEN isnull(Detail.BaseQuantity,0)
                                               ELSE isnull(Detail.Quantity,0)
                                          END)) as CostAmount
                    ,(case when Unit.Name is null then '' else  Unit.Name end) as Unit
                     from  RE_Retail_b as Detail
                     
inner join AA_Inventory as Inventory on Inventory.id=Detail.idinventory
left join AA_Unit as Unit on Unit.id=Inventory.idunit
 left join RE_Retail as Header on Header.id=Detail.idRetailDTO  where  1=1  And datediff(month,voucherdate,GETDATE())=0 and 1=1  and Detail.IsSaleOut='46A912CB-2AF5-41E3-8508-04260AC6E773' and Header.IsCancel='1EFBB98C-7140-495F-881B-6E23DFF364F3' and Detail.Isdel=0 and Inventory.IsLaborCost=1    
   and {Detail.idinventory_InventoryDTO} 
 
 
 group by Header.ID,Inventory.id,Inventory.Code,Inventory.Name,unit.name
 UNION ALL 
select inventory.id as invID,
(case when Inventory.Name is null then '' else  Inventory.Name end) as Inventory,
SUM(isnull(Detail.Quantity,0)) as Quantity
                    ,SUM(Detail.RetailPrice*isnull(Detail.Quantity,0)) as RetailAmount
                    ,SUM(isnull(Detail.TaxAmount,0)) as DiscountAmount
                    ,SUM(isnull(Inventory.invSCost,0)*(isnull(Detail.Quantity,0))) as CostAmount                 ,(case when Unit.Name is null then '' else  Unit.Name end) as Unit
                      from  RE_RetailSettle_b as Detail
inner join AA_Inventory as Inventory on Inventory.id=Detail.idinventory
left join AA_Unit as Unit on Unit.id=Inventory.idunit
 left join RE_RetailSettle as Header on Header.id=Detail.idRetailSettleDTO  left join AA_Unit as RetailSettleUnit on RetailSettleUnit.id=Detail.idunit  where  1=1  And datediff(month,voucherdate,GETDATE())=0 and Inventory.IsLaborCost=1 and Detail.issource=1    
   and {Detail.idinventory_InventoryDTO} 
    group by Header.ID,Inventory.id,Inventory.Code,Inventory.Name,unit.name) t
 ) main1 group by main1.invName,main1.unitName,main1.invID order by amount desc
 
 
else 


   select  top 1 invID,  SUM(amount) as amount ,SUM(quantity) as quantity,invName,unitName from (
select  mainTmp.invID as invID, mainTmp.amount,mainTmp.quantity,mainTmp.invName as invName,mainTmp.unitName as unitName from (
select  tmp.invid,(case when abs( (ISNULL(tmp.discountAmount,0)-ISNULL(tmp.CostAmount,0)-ISNULL(tmp.expenseAmount,0)-ISNULL(tmp.allowancesAmount,0)))<0.0000001 then 0.00 else (ISNULL(tmp.discountAmount,0)-ISNULL(tmp.CostAmount,0)-ISNULL(tmp.expenseAmount,0)-ISNULL(tmp.allowancesAmount,0)) end) as amount,tmp.baseQuantity as quantity, tmp.invName as invName, tmp.unitName as unitName from 
(select inventory.id as invid, sum(SaleInvoiceDetailDTO.expenseAmount) as  expenseAmount,
sum(SaleInvoiceDetailDTO.discountAmount) as discountAmount,
sum(ReceivePayment_b.allowancesAmount) as allowancesAmount,
Sum((
                    --当成本取值为非记账成本时
                    case when(00<>00) then
                        (
                           SaleInvoiceDetailDTO.baseQuantity*0
                        )
                          --当为先出库后销货情况
                         when(SaleDeliveryDetailDTO.idsourceVoucherType='BB007F33-C0F0-4A19-8588-1E0E314D1F56' or 
SaleDeliveryDetailDTO.idsourceVoucherType='EB475F0D-3379-4568-BB37-77877E830594') then
                        (
                            (SaleInvoiceDetailDTO.baseQuantity) * 
((Isnull(rdthensalerdrecord_b.amount,0)+Isnull(rdthensalerdrecord_b.dispatchAdjust,0))/rdthensalerdrecord_b.baseQuantity)
                        )
                         else
                        (
                            case when ((isnull(SaleInvoiceDetailDTO.baseQuantity,0) <= isnull(RDThenSaleRDThenRDRDRecord_b.baseQuantity,0)) and 
isnull(RDThenSaleRDThenRDRDRecord_b.baseQuantity,0)> 0) then
                            (
                              (SaleInvoiceDetailDTO.baseQuantity*((Isnull(RDThenSaleRDThenRDRDRecord_b.totalAmount,0))/RDThenSaleRDThenRDRDRecord_b.baseQuantity))
                            )
                            else
                            (
                              isnull(RDThenSaleRDThenRDRDRecord_b.totalAmount,0) +(isnull(SaleInvoiceDetailDTO.baseQuantity,0) - 
isnull(RDThenSaleRDThenRDRDRecord_b.baseQuantity,0)) *isnull(Inventory.invSCost,0) 
                            )
                            end
                        )
                     end
                    ) ) as CostAmount ,
           
BaseUnit.name as unitName,
Inventory.name as invName,
sum( SaleInvoiceDetailDTO.baseQuantity ) as baseQuantity          
 from Sa_SaleInvoice_b as SaleInvoiceDetailDTO
Inner join SA_SaleInvoice   as SaleInvoice on SaleInvoiceDetailDTO.idSaleInvoiceDTO=SaleInvoice.id
left join SA_SaleInvoiceSourceRelation as SaleInvoiceSourceRelation on SaleInvoiceSourceRelation.idsaleInvoiceDetailDTO = SaleInvoiceDetailDTO.id and 
(SaleInvoiceSourceRelation.idsourcevouchertype='5794D3DD-7FE4-4B5C-AF53-D21DDC13BF16' or SaleInvoiceSourceRelation.idsourcevouchertype = 
'201720E7-82F9-4C1F-AEA9-0892A121EACD')
left join Sa_SaleDelivery_b as SaleDeliveryDetailDTO on SaleInvoiceDetailDTO.sourceVoucherDetailId =SaleDeliveryDetailDTO.id
left join Sa_SaleDelivery as SaleDelivery on SaleDeliveryDetailDTO.idSaleDeliveryDTO = SaleDelivery.id
left join AA_Partner   as SaleDelivery_Customer on SaleInvoice.idcustomer=SaleDelivery_Customer.id
left join AA_District   as SaleDelivery_Customer_District on SaleDelivery_Customer.iddistrict=SaleDelivery_Customer_District.id
left join AA_PartnerClass   as SaleDelivery_Customer_CustomerClass on SaleDelivery_Customer.idpartnerclass=SaleDelivery_Customer_CustomerClass.id
left join AA_Warehouse   as Warehouse on SaleInvoiceDetailDTO.idwarehouse=Warehouse.id
left join AA_Department   as SaleDelivery_Department on SaleInvoice.iddepartment=SaleDelivery_Department.id
left join AA_Person   as SaleDelivery_Clerk on SaleInvoice.idclerk=SaleDelivery_Clerk.id
 left join  AA_Project  as Project on SaleInvoiceDetailDTO.idproject=Project.id
 left join  AA_ProjectClass  as Project_ProjectClass on Project.idclass=Project_ProjectClass.id
left join AA_Person   as SaleDelivery_Customer_SaleMan on SaleDelivery_Customer.idsaleman=SaleDelivery_Customer_SaleMan.id
left join AA_Department   as SaleDelivery_Customer_SaleDepartment on SaleDelivery_Customer.idsaledepartment=SaleDelivery_Customer_SaleDepartment.id
left join AA_Partner  as SettleCustomer on SaleInvoice.idsettleCustomer=SettleCustomer.id
left join AA_PartnerClass  as SettleCustomerClass on SettleCustomer.idpartnerclass=SettleCustomerClass.id
 left join  AA_Person  as SettleSaleMan on SettleCustomer.idsaleman=SettleSaleMan.id
 left join  AA_Department  as SettleSaleDepartment on SettleCustomer.idsaledepartment=SettleSaleDepartment.id
Inner join AA_Inventory   as Inventory on SaleInvoiceDetailDTO.idinventory=Inventory.id
left join AA_InventoryClass   as Inventory_InventoryClass on Inventory.idinventoryclass=Inventory_InventoryClass.id
 left join  eap_EnumItem  as Brand on Inventory.productInfo=Brand.id
left join AA_Unit   as BaseUnit on SaleInvoiceDetailDTO.idbaseunit=BaseUnit.id
 left join  
                                   (SELECT 
                                    sum(isnull(ST_RDRecord_b.amount,0) + ISNULL(ST_RDRecord_b.dispatchAdjust,0)) as totalAmount,
                                    sum(isnull(ST_RDRecord_b.baseQuantity,0)) as baseQuantity,
                                    ST_RDRecord_b.sourceVoucherDetailId 
                                    FROM ST_RDRecord_b, ST_RDRecord
                                    WHERE  ST_RDRecord_b.idRDRecordDTO = ST_RDRecord.id 
                                    AND ST_RDRecord.voucherState ='CB61249F-8222-44E0-B177-61FBC108AB61'
                                    group by ST_RDRecord_b.sourceVoucherDetailId ) as RDThenSaleRDThenRDRDRecord_b on 
RDThenSaleRDThenRDRDRecord_b.sourceVoucherDetailId =SaleInvoiceDetailDTO.sourceVoucherDetailId

 left join ST_RDRecord_b  RDThenSaleRDRecord_b on SaleDeliveryDetailDTO.sourceVoucherDetailId =RDThenSaleRDRecord_b.id
         
                    LEFT JOIN ( SELECT  voucherDetailID AS voucherDetailID ,
                            SUM(allowancesAmount) AS allowancesAmount
                    FROM    ARAP_ReceivePayment_b ReceivePayment
                            LEFT JOIN sa_saleinvoice_b saleinvoicedetail ON saleinvoicedetail.id = ReceivePayment.voucherDetailID
                    GROUP BY voucherDetailID
                  ) AS ReceivePayment_b ON ReceivePayment_b.voucherDetailID = SaleInvoiceDetailDTO.id  
 where  1=1  And ((datediff(month,SaleInvoice.voucherdate,GETDATE())=0 ) And 
(SaleInvoice.VoucherState='cb61249f-8222-44e0-b177-61fbc108ab61') )
  and {SaleInvoice.iddepartment_DepartmentDTO}
 and {SaleInvoiceDetailDTO.idinventory_InventoryDTO}
 and {SaleInvoice.idclerk_PersonDTO}
 and {SaleInvoiceDetailDTO.idwarehouse_WarehouseDTO}
 and {SaleInvoice.idcustomer_PartnerDTO}
 and {SaleInvoice.idsettleCustomer_PartnerDTO} 
 and {SaleInvoiceDetailDTO.idproject_ProjectDTO}

group by BaseUnit.name,Inventory.name,Inventory.id
 ) as tmp
 
 union all

select   t.invID,    ISNULL(DiscountAmount,0)-ISNULL(CostAmount,0) as amount,t.Quantity as quantity,t.Inventory as invName,t.Unit as unitName from (
select  inventory.id as invID,
(case when Inventory.Name is null then '' else  Inventory.Name end) as Inventory,
SUM(isnull(Detail.BaseQuantity,0)) as Quantity
                    ,SUM(isnull(RetailAmount,0)) as RetailAmount
                    ,SUM(isnull(Detail.TaxAmount,0)) as DiscountAmount
                    ,SUM(isnull(Detail.amount,0)) as CostAmount
                   ,(case when Unit.Name is null then '' else  Unit.Name end) as Unit
                      from ST_RDRecord_b as Detail
inner join AA_Inventory as Inventory on Inventory.id=Detail.idinventory
left join AA_Unit as Unit on Unit.id=Inventory.idunit
 left join ST_RDRecord as Header on Header.id=Detail.idRDRecordDTO where  1=1  And datediff(month,voucherdate,GETDATE())=0 AND Header.IDVoucherType='CE55890B-19DE-45B7-969D-99CAEB47A050'  
  and {Detail.idinventory_InventoryDTO} 

  group by Header.ID,Inventory.id,Inventory.Code,Inventory.Name,unit.name
 
 
 UNION  all
Select  inventory.id as invID,
(case when Inventory.Name is null then '' else  Inventory.Name end) as Inventory,
SUM(CASE WHEN Inventory.IsLaborCost=1  THEN isnull(Detail.BaseQuantity,0)
                                               ELSE isnull(Detail.Quantity,0)
                                          END) as Quantity
                    ,SUM(isnull(RetailAmount,0)) as RetailAmount
                    ,SUM(isnull(Detail.TaxAmount,0)) as DiscountAmount
                    ,SUM(isnull(Inventory.invSCost,0)*(CASE WHEN Inventory.IsLaborCost=1 
                                               THEN isnull(Detail.BaseQuantity,0)
                                               ELSE isnull(Detail.Quantity,0)
                                          END)) as CostAmount
                    ,(case when Unit.Name is null then '' else  Unit.Name end) as Unit
                     from  RE_Retail_b as Detail
                     
inner join AA_Inventory as Inventory on Inventory.id=Detail.idinventory
left join AA_Unit as Unit on Unit.id=Inventory.idunit
 left join RE_Retail as Header on Header.id=Detail.idRetailDTO  where  1=1  And datediff(month,voucherdate,GETDATE())=0 and 1=1  and Detail.IsSaleOut='46A912CB-2AF5-41E3-8508-04260AC6E773' and Header.IsCancel='1EFBB98C-7140-495F-881B-6E23DFF364F3' and Detail.Isdel=0 and Inventory.IsLaborCost=1    
   and {Detail.idinventory_InventoryDTO} 
 
 
 group by Header.ID,Inventory.id,Inventory.Code,Inventory.Name,unit.name
 UNION ALL 
select  inventory.id as invID,
(case when Inventory.Name is null then '' else  Inventory.Name end) as Inventory,
SUM(isnull(Detail.Quantity,0)) as Quantity
                    ,SUM(Detail.RetailPrice*isnull(Detail.Quantity,0)) as RetailAmount
                    ,SUM(isnull(Detail.TaxAmount,0)) as DiscountAmount
                    ,SUM(isnull(Inventory.invSCost,0)*(isnull(Detail.Quantity,0))) as CostAmount                 ,(case when Unit.Name is null then '' else  Unit.Name end) as Unit
                      from  RE_RetailSettle_b as Detail
inner join AA_Inventory as Inventory on Inventory.id=Detail.idinventory
left join AA_Unit as Unit on Unit.id=Inventory.idunit
 left join RE_RetailSettle as Header on Header.id=Detail.idRetailSettleDTO  left join AA_Unit as RetailSettleUnit on RetailSettleUnit.id=Detail.idunit  where  1=1  And datediff(month,voucherdate,GETDATE())=0 and Inventory.IsLaborCost=1 and Detail.issource=1    
   and {Detail.idinventory_InventoryDTO} 
    group by Header.ID,Inventory.id,Inventory.Code,Inventory.Name,unit.name) t

 )mainTmp
) main2 group by main2.invName,main2.unitName,main2.invID
 order by amount desc
 
 
 



