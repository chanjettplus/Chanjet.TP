--------应收占比
declare @qj datetime
declare @temp int
declare @vouchertype varchar(50)
declare @digits int
set @digits=2
set @temp=(select value from EAP_AccInformation where Name='SAAccount')
set @qj=(select top 1 begindate from SM_Period where BizTerminalState<>3 order by currentyear,currentperiod)
if(@temp=0) ------单据立账
set @vouchertype='5794D3DD-7FE4-4B5C-AF53-D21DDC13BF16'
else ------发票立账
set @vouchertype='314949e5-47d0-494a-b764-1e2751f88788'

Declare  @vouchertaxamount decimal(18,2)


if(@temp=0) 
set @vouchertaxamount =
(select
(
SELECT isnull(sum(saledeliverydetaildto.taxamount) ,0)
FROM sa_saledelivery_b AS saledeliverydetaildto
Inner join SA_SaleDelivery  as saledelivery on saledeliverydetaildto.idSaleDeliveryDTO=saledelivery.id  
inner join aa_inventory  as inventory on saledeliverydetaildto.idinventory=inventory.id
WHERE datediff(day,saledelivery.voucherdate,getdate())=0
and saledelivery.voucherState='CB61249F-8222-44E0-B177-61FBC108AB61'
and {saledelivery.idclerk_PersonDTO} 
and {saledelivery.idcustomer_PartnerDTO} 
and {saledelivery.iddepartment_DepartmentDTO}
and {saledelivery.makerid_UserDTO}
and {saledeliverydetaildto.idinventory_InventoryDTO} 
and {saledeliverydetaildto.idproject_ProjectDTO} 
and {saledeliverydetaildto.idwarehouse_WarehouseDTO}
)
+
(
select 
isnull(sum(Detail.TaxAmount),0) 
from  CS_IncomeVoucher_b as Detail
left join   AA_Income_Ext as IncomeItem on Detail.idincomeitem = IncomeItem.[id]
left join   CS_IncomeVoucher   as IncomeVoucherDTO on Detail.idIncomeVoucherDTO = IncomeVoucherDTO.[id]
left join   eap_EnumItem   as VoucherState on IncomeVoucherDTO.voucherState = VoucherState.[id]
LEFT JOIN EAP_Menu ON (EAP_Menu.Code='cs03') 
where datediff(day,IncomeVoucherDTO.voucherdate,GETDATE())=0
And (VoucherState.ID='cb61249f-8222-44e0-b177-61fbc108ab61')
and ({IncomeVoucherDTO.Idpartner_PartnerDTO}  
and {IncomeVoucherDTO.idDepartment_DepartmentDTO}
and {IncomeVoucherDTO.idClerk_PersonDTO}
and {IncomeVoucherDTO.makerid_UserDTO}
and {IncomeVoucherDTO.idstore_StoreDTO}
and {Detail.idproject_ProjectDTO}) 
)
)
else
set @vouchertaxamount =
(select
(
SELECT isnull(sum(saleInvoicedetaildto.TaxAmount),0) 
FROM SA_SaleInvoice_b AS saleInvoicedetaildto
INNER JOIN SA_SaleInvoice AS saleInvoice ON saleInvoicedetaildto.idSaleInvoiceDTO = saleInvoice.id
WHERE {saleInvoice.idclerk_PersonDTO} 
and {saleInvoice.idcustomer_PartnerDTO} 
and {saleInvoice.iddepartment_DepartmentDTO} 
and {saleInvoice.makerid_UserDTO}
and {saleInvoicedetaildto.idinventory_InventoryDTO} 
and {saleInvoicedetaildto.idproject_ProjectDTO} 
and {saleInvoicedetaildto.idwarehouse_WarehouseDTO}
AND datediff(day,saleInvoice.voucherdate,getdate())=0
and saleInvoice.voucherState='CB61249F-8222-44E0-B177-61FBC108AB61'
)
+
(
select 
isnull(sum(Detail.TaxAmount),0) 
from  CS_IncomeVoucher_b as Detail
left join   AA_Income_Ext as IncomeItem on Detail.idincomeitem = IncomeItem.[id]
left join   CS_IncomeVoucher   as IncomeVoucherDTO on Detail.idIncomeVoucherDTO = IncomeVoucherDTO.[id]
left join   eap_EnumItem   as VoucherState on IncomeVoucherDTO.voucherState = VoucherState.[id]
LEFT JOIN EAP_Menu ON (EAP_Menu.Code='cs03') 
where datediff(day,IncomeVoucherDTO.voucherdate,GETDATE())=0
And (VoucherState.ID='cb61249f-8222-44e0-b177-61fbc108ab61')
and ({IncomeVoucherDTO.Idpartner_PartnerDTO}  
and {IncomeVoucherDTO.idDepartment_DepartmentDTO}
and {IncomeVoucherDTO.idClerk_PersonDTO}
and {IncomeVoucherDTO.makerid_UserDTO}
and {IncomeVoucherDTO.idstore_StoreDTO}
and {Detail.idproject_ProjectDTO}) 
)

)



select (case when @vouchertaxamount<>0
then round(Amount,@digits)/round(@vouchertaxamount,@digits)
else 0 end)as amount
from(
select
sum(Amount) as Amount
from (--往来 应收总账
--外层
SELECT 
--结算客户组
partner.ID   as Idpartner,     --客户ID
ARAP.Amount AS Amount	   --应收（本币）
FROM (--中间层
Select 
sum(Amount) as Amount,
Idpartner From (--内层
SELECT
Detail.idpartner AS idpartner,--结算客户         
Detail.amount AS Amount--应收应付金额(本币),应收应付
FROM ARAP_Detail AS Detail	
LEFT JOIN AA_Partner AS Partner ON Detail.idpartner = Partner.ID--结算客户
LEFT JOIN AA_Partner AS noSettlePartner ON Detail.idnosettlepartner = noSettlePartner.ID--客户
where ( idarapvouchertype =@vouchertype or idarapvouchertype ='8DF77A52-3447-44D3-82FE-E4E6B3D4FE66' or idarapvouchertype ='F24A0934-F191-4D8B-A17C-814ECBAA626F' or idarapvouchertype ='82CB65E8-12AB-4559-9AC6-B660A3D18E15' or idarapvouchertype ='0A6377A7-B4DD-4894-B134-C2D0A8E37B58' or idarapvouchertype ='7DFBC113-DAC5-402F-B4C9-CD427C33CC0F' or idarapvouchertype ='CCD85113-D257-43DA-85E3-DA441FD22A7A' or idarapvouchertype ='6267A967-A494-4C8C-8A75-DCFAF27E4357') and Detail.IsArFlag = 1  
and ({Detail.iddepartment_DepartmentDTO} and {Detail.idperson_PersonDTO} and {Detail.idpartner_PartnerDTO}) 
and datediff(day,Detail.registerDate,getdate())=0 and Detail.registerDate >= @qj and Detail.auditFlag = 1 )AS Middle group by Idpartner) AS ARAP LEFT JOIN AA_Partner AS partner ON ARAP.Idpartner = partner.ID--往来单位
) as arap)as t