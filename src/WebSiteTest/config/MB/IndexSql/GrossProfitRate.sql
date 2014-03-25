----------销售毛利率
--单据立账
Declare  @temp int
declare @qj datetime
declare  @digits int
set @temp=(select value from EAP_AccInformation where Name='SAAccount')
set @qj=(select top 1 begindate from SM_Period where BizTerminalState<>3 order by currentyear,currentperiod)
set @digits=2
if(@temp=0)
SELECT (case when Sum(saletaxamount)<>0
then
round(Isnull(Sum(saletaxamount - dispatchcostamount - expensetaxamout),0),@digits)/round(Sum(saletaxamount),@digits) 
else 0 end) Amount
FROM   (select 
                     Sum(0.00) AS saletaxamount,
                     Sum(0.00) AS dispatchcostamount,
                     Sum(0.00) AS expensetaxamout
from SA_SaleOrder_b as SaleOrderDetailDTO
Inner join SA_SaleOrder  as Header on SaleOrderDetailDTO.idSaleOrderDTO=Header.id
left join AA_Department_Ext as Department on Header.iddepartment=Department.id
 where voucherdate >=@qj and voucherdate<=getdate() AND (voucherState='CB61249F-8222-44E0-B177-61FBC108AB61'  or voucherState='FDDC74ED-4027-4575-9CBB-7BF27965EE9B')  
 and ({Header.iddepartment_DepartmentDTO}  
 and {Header.idclerk_PersonDTO}  
 and {Header.idcustomer_PartnerDTO}  
 and {Header.idSettleCustomer_PartnerDTO}) group by Department.Departmentid_lev1,Department.Departmentname_lev1
 UNION ALL 
select 
                         Sum(saledeliverydetaildto.taxamount) AS saletaxamount,
                         Sum(0.00) AS dispatchcostamount,
                         Sum(0.00) AS expensetaxamout
 from  SA_SaleDelivery_b as SaleDeliveryDetailDTO
 Inner join   SA_SaleDelivery  as Header on SaleDeliveryDetailDTO.idSaleDeliveryDTO=Header.id
 left join   AA_Department_Ext as Department on Header.iddepartment=Department.id
 Where ( 1=1  and voucherdate <= GETDATE() and voucherdate >=@qj  and voucherState='CB61249F-8222-44E0-B177-61FBC108AB61'  or (isBeforeSystemInuse=1 and isNoArapBookKeeping=0 and  1=1 )) 
 and ({Header.iddepartment_DepartmentDTO}  
 and {Header.idclerk_PersonDTO}  
 and {Header.idcustomer_PartnerDTO}  
 and {Header.idSettleCustomer_PartnerDTO}) group by Department.Departmentid_lev1,Department.Departmentname_lev1
UNION ALL 
select 
                            Sum(RetailSettleDetailDTO.taxamount) AS saletaxamount,
                            Sum(0.00) AS dispatchcostamount,
                            Sum(0.00) AS expensetaxamout
from  RE_RetailSettle_b as RetailSettleDetailDTO
 Inner join   RE_RetailSettle  as Header on RetailSettleDetailDTO.idRetailSettleDTO=Header.id
 left join   AA_DR_Store  as Store on Header.idstore=Store.id
 left join   AA_Department_Ext as Department on Store.iddepartment=Department.id
 where  1=1  and 1=1 
 and ( 1=1  and voucherdate <= getdate() and voucherdate >=@qj  and voucherState='CB61249F-8222-44E0-B177-61FBC108AB61'  or (iscarriedforwardin = 1 and  1=1 )) 
 and ({Header.idstore_StoreDTO}
 and {Header.idcustomer_PartnerDTO}
 and {Header.idSettleCustomer_PartnerDTO}
 ) group by Department.Departmentid_lev1,Department.Departmentname_lev1
 UNION ALL 
select 
                     Sum(0.00) AS saletaxamount,
                     Sum(Isnull(rdrecord_b.amount,0) + Isnull(rdrecord_b.dispatchadjust,0)) AS dispatchcostamount,
                     Sum(0.00) AS expensetaxamout
from ST_RDRecord_b as RDRecord_b
 inner join  ST_RDRecord   as Header on RDRecord_b.idRDRecordDTO=Header.id
 left join  AA_Department_Ext as Department on Header.iddepartment=Department.id
 where  voucherdate<=Getdate() and voucherdate>=@qj and voucherState='CB61249F-8222-44E0-B177-61FBC108AB61' and (header.IDVoucherType=N'BB007F33-C0F0-4A19-8588-1E0E314D1F56' or header.IDVoucherType=N'CE55890B-19DE-45B7-969D-99CAEB47A050') 
 and ({Header.iddepartment_DepartmentDTO}
 and {Header.idclerk_PersonDTO}
 and {Header.idpartner_PartnerDTO}
 and {Header.idSettleCustomer_PartnerDTO}) group by Department.Departmentid_lev1,Department.Departmentname_lev1
 UNION ALL 
select 
                         Sum(0.00) AS saletaxamount,
                         Sum(Isnull(rdrecord_b.amount,0) + Isnull(rdrecord_b.dispatchadjust,0)) AS dispatchcostamount,
                         Sum(0.00) AS expensetaxamout
 from ST_RDRecord_b as RDRecord_b
 inner join  ST_RDRecord   as Header on RDRecord_b.idRDRecordDTO=Header.id
 left join  AA_Department_Ext as Department on Header.iddepartment=Department.id
 where voucherdate<=Getdate() and voucherdate >=@qj and voucherState='CB61249F-8222-44E0-B177-61FBC108AB61' and header.IDVoucherType='21EA9921-40C1-46EB-BF55-2DF64C7CDDFB' and isnull(RDRecord_b.idsourcevouchertype,N'00000000-0000-0000-0000-000000000000')  <>N'9CDE6B76-266C-47F3-AAF6-347D3B23F10B'
 and ({Header.iddepartment_DepartmentDTO}
 and {Header.idclerk_PersonDTO}
 and {Header.idpartner_PartnerDTO}
 and {Header.idSettleCustomer_PartnerDTO}) group by Department.Departmentid_lev1,Department.Departmentname_lev1
 UNION ALL 
select 
                     Sum(0.00) AS saletaxamount,
                     Sum(0.00) AS dispatchcostamount,
                     Sum(header.allowances) AS expensetaxamout
 from  ARAP_ReceivePayment as Header
 left join  AA_Department_Ext as Department on Header.Iddepartment=department.Id
 where  Header.isreceiveflag = 1 and voucherdate<=Getdate() and voucherdate >=@qj and voucherState='CB61249F-8222-44E0-B177-61FBC108AB61'  
 and ({Header.iddepartment_DepartmentDTO}
 and {Header.idperson_PersonDTO}
 and {Header.idpartner_PartnerDTO}) group by Department.Departmentid_lev1,Department.Departmentname_lev1
 UNION ALL 
select 
                         Sum(0.00) AS saletaxamount,
                         Sum(0.00) AS dispatchcostamount,
                         Sum(0.00) AS expensetaxamout
 from  CS_IncomeVoucher_b as Detail
 left join   CS_IncomeVoucher   as Header on Detail.idIncomeVoucherDTO = Header.[id]
 left join   AA_Department_Ext as Department on Header.iddepartment = Department.[id]
 where voucherdate<=Getdate() and voucherdate >=@qj and voucherState='CB61249F-8222-44E0-B177-61FBC108AB61' AND (Header.idbusinesstype = '37c8695b-31a7-48cb-b40a-87c79c4558df') 
 and ({Header.iddepartment_DepartmentDTO}
 and {Header.idclerk_PersonDTO}
 and {Header.idpartner_PartnerDTO}) group by Department.Departmentid_lev1,Department.Departmentname_lev1
 UNION ALL 
select 
                     Sum(0.00) AS saletaxamount,
                     Sum(0.00) AS dispatchcostamount,
                     Sum(0.00) AS expensetaxamout
 from  CS_IncomeVoucher_b as Detail
 left join   CS_IncomeVoucher   as Header on Detail.idIncomeVoucherDTO = Header.[id]
 left join   AA_Department_Ext as Department on Header.iddepartment = Department.[id]
 where voucherdate<=Getdate() and voucherdate >=@qj and voucherState='CB61249F-8222-44E0-B177-61FBC108AB61' AND (Header.idbusinesstype = '209d7654-9f25-40da-9154-e3948b841529') 
 and ({Header.iddepartment_DepartmentDTO}
 and {Header.idclerk_PersonDTO}
 and {Header.idpartner_PartnerDTO}) group by Department.Departmentid_lev1,Department.Departmentname_lev1
 UNION ALL 
select 
                     Sum(0.00) AS saletaxamount,
                     Sum(0.00) AS dispatchcostamount,
                     Sum(detail.taxamount) AS expensetaxamout
 from CS_ExpenseVoucher_b as Detail
 left join  CS_ExpenseVoucher   as Header on (Detail.idExpenseVoucherDTO= Header.id)
 left join  AA_Department_Ext as Department on Header.iddepartment = Department.id
         LEFT JOIN aa_expenseitem_ext AS expenseitem
ON detail.idexpenseitem = expenseitem.id         
LEFT JOIN aa_expenseitem AS expense
ON expense.id = expenseitem.id left join  AA_Partner as Customer on isnull(Header.idpartner,N'00000000-0000-0000-0000-000000000000') = Customer.[id]  where voucherdate >=@qj  and voucherdate <=getdate() and voucherState=N'CB61249F-8222-44E0-B177-61FBC108AB61' and (expense.expensetype in (N'3a58ceea-4964-49b0-92be-1e2affa73910',N'bfe9ca03-194a-4f29-9e03-c2ff2430f022',N'D79B1476-5FA9-4110-ABD4-D7E9CBB8ED66')
                                                                or (expense.expensetype=N'fb7d3a96-d4d6-42b0-b53e-ccc2474faf40' 
                                                                and isapportion=0))
and ({Header.iddepartment_DepartmentDTO}
and {Header.idclerk_PersonDTO}
and {Header.idpartner_PartnerDTO}) group by Department.Departmentid_lev1,Department.Departmentname_lev1)as t
else
-----发票立账
SELECT (case when Sum(saletaxamount)<>0
then
round(Isnull(Sum(saletaxamount - dispatchcostamount - expensetaxamout),0),@digits)/round(Sum(saletaxamount),@digits) 
else 0 end) Amount
FROM   (select
                     Sum(0.00) AS saletaxamount,
                     Sum(0.00) AS dispatchcostamount,
                     Sum(0.00) AS expensetaxamout
from SA_SaleOrder_b as SaleOrderDetailDTO
Inner join SA_SaleOrder  as Header on SaleOrderDetailDTO.idSaleOrderDTO=Header.id
left join AA_Department_Ext as Department on Header.iddepartment=Department.id
 where voucherdate>=@qj and voucherdate<=Getdate() and (voucherState='CB61249F-8222-44E0-B177-61FBC108AB61'  or voucherState='FDDC74ED-4027-4575-9CBB-7BF27965EE9B')  
 and ({Header.iddepartment_DepartmentDTO}
 and {Header.idclerk_PersonDTO}
 and {Header.idcustomer_PartnerDTO}
 and {Header.idSettleCustomer_PartnerDTO}) group by Department.Departmentid_lev1,Department.Departmentname_lev1
 UNION ALL 
select 
                         Sum(saleinvoice_b.taxamount) AS saletaxamount,
                         Sum(0.00) AS dispatchcostamount,
                         Sum(0.00) AS expensetaxamout
 from SA_SaleInvoice_b as SaleInvoice_b
Inner join SA_SaleInvoice  as Header on SaleInvoice_b.idSaleInvoiceDTO=Header.id
left join AA_Department_Ext as Department on Header.iddepartment=Department.id
 where  1=1  AND
 ( 1=1  and (voucherdate >= @qj and voucherdate <=getdate())  and voucherState='CB61249F-8222-44E0-B177-61FBC108AB61' ) 
 and ({Header.iddepartment_DepartmentDTO}
 and {Header.idclerk_PersonDTO}
 and {Header.idcustomer_PartnerDTO}
 and {Header.idSettleCustomer_PartnerDTO}) group by Department.Departmentid_lev1,Department.Departmentname_lev1
UNION ALL 
select 
                            Sum(RetailSettleDetailDTO.taxamount) AS saletaxamount,
                            Sum(0.00) AS dispatchcostamount,
                            Sum(0.00) AS expensetaxamout
  from  RE_RetailSettle_b as RetailSettleDetailDTO
 Inner join   RE_RetailSettle  as Header on RetailSettleDetailDTO.idRetailSettleDTO=Header.id
 left join   AA_DR_Store  as Store on Header.idstore=Store.id
 left join   AA_Department_Ext as Department on Store.iddepartment=Department.id
 where  1=1  and 1=1 
 and ( 1=1  and voucherdate <= getdate() and voucherdate >=@qj  and voucherState='CB61249F-8222-44E0-B177-61FBC108AB61') 
 and ({Header.idstore_StoreDTO}
 and {Header.idcustomer_PartnerDTO}
 and {Header.idSettleCustomer_PartnerDTO}
 ) group by Department.Departmentid_lev1,Department.Departmentname_lev1
 UNION ALL 
select 
                     Sum(0.00) AS saletaxamount,
                     Sum(Isnull(rdrecord_b.amount,0) + Isnull(rdrecord_b.dispatchadjust,0)) AS dispatchcostamount,
                     Sum(0.00) AS expensetaxamout
 from ST_RDRecord_b as RDRecord_b
 inner join  ST_RDRecord   as Header on RDRecord_b.idRDRecordDTO=Header.id
 left join  AA_Department_Ext as Department on Header.iddepartment=Department.id
 where  voucherdate<=Getdate() and voucherdate>=@qj and voucherState='CB61249F-8222-44E0-B177-61FBC108AB61' and (header.IDVoucherType=N'BB007F33-C0F0-4A19-8588-1E0E314D1F56' or header.IDVoucherType=N'CE55890B-19DE-45B7-969D-99CAEB47A050')
 and ({Header.iddepartment_DepartmentDTO}
 and {Header.idclerk_PersonDTO}
 and {Header.idpartner_PartnerDTO}
 and {Header.idSettleCustomer_PartnerDTO}) group by Department.Departmentid_lev1,Department.Departmentname_lev1
 UNION ALL 
select 
                         Sum(0.00) AS saletaxamount,
                         Sum(Isnull(rdrecord_b.amount,0) + Isnull(rdrecord_b.dispatchadjust,0)) AS dispatchcostamount,
                         Sum(0.00) AS expensetaxamout
 from ST_RDRecord_b as RDRecord_b
 inner join  ST_RDRecord   as Header on RDRecord_b.idRDRecordDTO=Header.id
 left join  AA_Department_Ext as Department on Header.iddepartment=Department.id
 where  voucherdate<=Getdate() and voucherdate>=@qj and voucherState='CB61249F-8222-44E0-B177-61FBC108AB61' and header.IDVoucherType='21EA9921-40C1-46EB-BF55-2DF64C7CDDFB' and isnull(RDRecord_b.idsourcevouchertype,N'00000000-0000-0000-0000-000000000000')  <>N'9CDE6B76-266C-47F3-AAF6-347D3B23F10B'
 and ({Header.iddepartment_DepartmentDTO}
 and {Header.idclerk_PersonDTO}
 and {Header.idpartner_PartnerDTO}
 and {Header.idSettleCustomer_PartnerDTO}) group by Department.Departmentid_lev1,Department.Departmentname_lev1
 UNION ALL 
select 
                     Sum(0.00) AS saletaxamount,
                     Sum(0.00) AS dispatchcostamount,
                     Sum(header.allowances) AS expensetaxamout
 from  ARAP_ReceivePayment as Header
 left join  AA_Department_Ext as Department on Header.Iddepartment=department.Id
 where Header.isreceiveflag = 1  and voucherdate<=Getdate() and voucherdate>=@qj and voucherState='CB61249F-8222-44E0-B177-61FBC108AB61'  
 and ({Header.iddepartment_DepartmentDTO}
 and {Header.idperson_PersonDTO}
 and {Header.idpartner_PartnerDTO}) group by Department.Departmentid_lev1,Department.Departmentname_lev1
 UNION ALL 
select 
                         Sum(0.00) AS saletaxamount,
                         Sum(0.00) AS dispatchcostamount,
                         Sum(0.00) AS expensetaxamout
 from  CS_IncomeVoucher_b as Detail
 left join   CS_IncomeVoucher   as Header on Detail.idIncomeVoucherDTO = Header.[id]
 left join   AA_Department_Ext as Department on Header.iddepartment = Department.[id]
 where  voucherdate<=Getdate() and voucherdate>=@qj and voucherState='CB61249F-8222-44E0-B177-61FBC108AB61' AND (Header.idbusinesstype = '37c8695b-31a7-48cb-b40a-87c79c4558df') 
 and ({Header.iddepartment_DepartmentDTO}
 and {Header.idclerk_PersonDTO}
 and {Header.idpartner_PartnerDTO}) group by Department.Departmentid_lev1,Department.Departmentname_lev1
 UNION ALL 
select 
                     Sum(0.00) AS saletaxamount,
                     Sum(0.00) AS dispatchcostamount,
                     Sum(0.00) AS expensetaxamout
 from  CS_IncomeVoucher_b as Detail
 left join   CS_IncomeVoucher   as Header on Detail.idIncomeVoucherDTO = Header.[id]
 left join   AA_Department_Ext as Department on Header.iddepartment = Department.[id]
 where voucherdate<=Getdate() and voucherdate>=@qj and voucherState='CB61249F-8222-44E0-B177-61FBC108AB61' AND (Header.idbusinesstype = '209d7654-9f25-40da-9154-e3948b841529') 
 and ({Header.iddepartment_DepartmentDTO}
 and {Header.idclerk_PersonDTO}
 and {Header.idpartner_PartnerDTO}) group by Department.Departmentid_lev1,Department.Departmentname_lev1
 UNION ALL 
select 
                     Sum(0.00) AS saletaxamount,
                     Sum(0.00) AS dispatchcostamount,
                     Sum(detail.taxamount) AS expensetaxamout
 from CS_ExpenseVoucher_b as Detail
 left join  CS_ExpenseVoucher   as Header on (Detail.idExpenseVoucherDTO= Header.id )
 left join  AA_Department_Ext as Department on Header.iddepartment = Department.id
         LEFT JOIN aa_expenseitem_ext AS expenseitem
ON detail.idexpenseitem = expenseitem.id         
LEFT JOIN aa_expenseitem AS expense
ON expense.id = expenseitem.id left join  AA_Partner as Customer on isnull(Header.idpartner,N'00000000-0000-0000-0000-000000000000') = Customer.[id]  where  voucherdate>=@qj and voucherdate <= getdate() and voucherState=N'CB61249F-8222-44E0-B177-61FBC108AB61' and (expense.expensetype in (N'3a58ceea-4964-49b0-92be-1e2affa73910',N'bfe9ca03-194a-4f29-9e03-c2ff2430f022',N'D79B1476-5FA9-4110-ABD4-D7E9CBB8ED66')
                                                                or (expense.expensetype=N'fb7d3a96-d4d6-42b0-b53e-ccc2474faf40' 
                                                                and isapportion=0)) 
and ({Header.iddepartment_DepartmentDTO}
and {Header.idclerk_PersonDTO}
and {Header.idpartner_PartnerDTO}) group by Department.Departmentid_lev1,Department.Departmentname_lev1)as t