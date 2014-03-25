---应付 本币金额
Declare @temp int
declare @qj datetime
declare @vouchertype varchar(50)
set @temp=(select value from EAP_AccInformation where Name='PUAccount')
set @qj=(select top 1 begindate from SM_Period where BizTerminalState<>3 order by currentyear,currentperiod)
if(@temp=0) ------单据立账
set @vouchertype='5399D7A6-8B61-459A-AC53-5C208D1BC871'
else ------发票立账
set @vouchertype='267210C0-CD76-404B-B311-BB89CE8EC7D2'
select Idpartner as Idpartner,
sum(BalanceAmount) as Amount from (--往来 应付总账
--外层
SELECT
--结算客户组
partner.ID   as Idpartner,     --客户ID
ISNULL(Amount,0.0)-ISNULL(SettleAmount,0.0) as balanceAmount    --期末余额(本币)
FROM (--中间层
Select sum(Amount) as Amount,
sum(SettleAmount) as SettleAmount,
Idpartner From (--内层
SELECT
Detail.idpartner AS idpartner,--往来单位ID
Detail.amount AS Amount,--应收应付金额(本币),应收应付 
Detail.settleAmount AS SettleAmount--已收已付金额(本币)
FROM ARAP_Detail AS Detail	
LEFT JOIN AA_Partner AS Partner ON Detail.idpartner = Partner.ID--往来单位
where ( idarapvouchertype =@vouchertype or idarapvouchertype ='F7E2CB97-A5D2-43A0-8DAE-E2FB90F0FDF2' or idarapvouchertype ='552ED4F9-A784-4C6B-AFCF-BBE77F9AFDCD' or idarapvouchertype ='D6E84177-11E2-4187-BE88-C340BAD1FAFA' or idarapvouchertype ='C044589E-F4DF-4995-912D-D5D252721048' or idarapvouchertype ='CCD85113-D257-43DA-85E3-DA441FD22A7A' or idarapvouchertype ='6267A967-A494-4C8C-8A75-DCFAF27E4357') 
and Detail.IsArFlag = 0  and Detail.registerDate<=GETDATE()
and ({Detail.iddepartment_DepartmentDTO} and {Detail.idperson_PersonDTO} and {Detail.idpartner_PartnerDTO})  
and Detail.registerDate >= @qj and Detail.auditFlag = 1 )AS Middle group by Idpartner) AS ARAP LEFT JOIN AA_Partner AS partner ON ARAP.Idpartner = partner.ID--往来单位
UNION ALL  --外层
SELECT  
--结算客户组
partner.ID   as Idpartner,     --客户ID
ISNULL(Amount,0.0)-ISNULL(SettleAmount,0.0) as balanceAmount    --期末余额(本币)
FROM (--中间层
Select sum(Amount) as Amount,
sum(SettleAmount) as SettleAmount,
Idpartner From (--内层
SELECT
Detail.idpartner AS idpartner,--往来单位ID
Detail.amount AS Amount,--应收应付金额(本币),应收应付  
Detail.settleAmount AS SettleAmount--已收已付金额(本币)
FROM ARAP_Detail AS Detail	
LEFT JOIN AA_Partner AS Partner ON Detail.idpartner = Partner.ID--往来单位
where Detail.IsArFlag = 0 
and ({Detail.iddepartment_DepartmentDTO} and {Detail.idperson_PersonDTO} and {Detail.idpartner_PartnerDTO}) 
and Detail.registerDate<@qj and Detail.auditFlag = 1 )AS Middle group by Idpartner)  AS ARAP LEFT JOIN AA_Partner AS partner ON ARAP.Idpartner = partner.ID--往来单位
) as arap group by Idpartner
order by Amount desc