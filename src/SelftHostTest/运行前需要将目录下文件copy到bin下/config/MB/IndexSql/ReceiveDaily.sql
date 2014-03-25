-----应收 本币金额
Declare @temp int
declare @qj datetime
declare @vouchertype varchar(50)
set @temp=(select value from EAP_AccInformation where Name='SAAccount')
set @qj=(select top 1 begindate from SM_Period where BizTerminalState<>3 order by currentyear,currentperiod)
if(@temp=0) ------单据立账
set @vouchertype='5794D3DD-7FE4-4B5C-AF53-D21DDC13BF16'
else ------发票立账
set @vouchertype='314949e5-47d0-494a-b764-1e2751f88788'
select IdnoSettlepartner as Idpartner,
sum(BalanceAmount) as Amount from (--往来 应收总账
--外层
SELECT 
--结算客户组
                                 noSettlepartner.ID   as IdnoSettlepartner,     --结算客户ID
ISNULL(Amount,0.0)-ISNULL(SettleAmount,0.0) as balanceAmount    --期末余额(本币)
FROM (--中间层
Select sum(Amount) as Amount,
sum(SettleAmount) as SettleAmount,
										   IdnoSettlepartner From (--内层
SELECT
Detail.idnosettlepartner AS  IdnoSettlepartner,--客户
Detail.amount AS Amount,--应收应付金额(本币),应收应付
Detail.settleAmount AS SettleAmount--已收已付金额(本币)
FROM ARAP_Detail AS Detail	
LEFT JOIN AA_Partner AS Partner ON Detail.idpartner = Partner.ID--结算客户
LEFT JOIN AA_Partner AS noSettlePartner ON Detail.idnosettlepartner = noSettlePartner.ID--客户
where (idarapvouchertype =@vouchertype or idarapvouchertype ='8DF77A52-3447-44D3-82FE-E4E6B3D4FE66' or idarapvouchertype =N'F24A0934-F191-4D8B-A17C-814ECBAA626F' or idarapvouchertype ='82CB65E8-12AB-4559-9AC6-B660A3D18E15' or idarapvouchertype ='0A6377A7-B4DD-4894-B134-C2D0A8E37B58' or idarapvouchertype ='7DFBC113-DAC5-402F-B4C9-CD427C33CC0F' or idarapvouchertype ='CCD85113-D257-43DA-85E3-DA441FD22A7A' or idarapvouchertype ='6267A967-A494-4C8C-8A75-DCFAF27E4357') 
and Detail.IsArFlag = 1 and Detail.registerDate<=GETDATE() and Detail.registerDate>=@qj
and ({Detail.iddepartment_DepartmentDTO} and {Detail.idperson_PersonDTO} and {Detail.idpartner_PartnerDTO}) 
 and Detail.auditFlag = 1 )AS Middle group by IdnoSettlepartner) AS ARAP LEFT JOIN AA_Partner AS noSettlepartner ON ARAP.IdnoSettlepartner = noSettlepartner.ID--往来单位
UNION ALL  --外层
SELECT  
--结算客户组
                                 noSettlepartner.ID   as IdnoSettlepartner,     --结算客户ID
ISNULL(Amount,0.0)-ISNULL(SettleAmount,0.0) as balanceAmount    --期末余额(本币)
FROM (--中间层
Select sum(Amount) as Amount,
sum(SettleAmount) as SettleAmount,
												IdnoSettlepartner From (--内层
SELECT
Detail.idnosettlepartner AS  IdnoSettlepartner,--客户
Detail.amount AS Amount,--应收应付金额(本币),应收应付
Detail.settleAmount AS SettleAmount--已收已付金额(本币)
FROM ARAP_Detail AS Detail	
LEFT JOIN AA_Partner AS Partner ON Detail.idpartner = Partner.ID--结算客户
LEFT JOIN AA_Partner AS noSettlePartner ON Detail.idnosettlepartner = noSettlePartner.ID--客户
where Detail.IsArFlag = 1 
and ({Detail.iddepartment_DepartmentDTO} and {Detail.idperson_PersonDTO} and {Detail.idpartner_PartnerDTO})  
and Detail.registerDate<=@qj and Detail.auditFlag = 1 )AS Middle group by IdnoSettlepartner)  AS ARAP LEFT JOIN AA_Partner AS noSettlepartner ON ARAP.IdnoSettlepartner = noSettlepartner.ID--往来单位
) as arap group by IdnoSettlepartner
order by Amount desc