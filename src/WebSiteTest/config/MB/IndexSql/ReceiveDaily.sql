-----Ӧ�� ���ҽ��
Declare @temp int
declare @qj datetime
declare @vouchertype varchar(50)
set @temp=(select value from EAP_AccInformation where Name='SAAccount')
set @qj=(select top 1 begindate from SM_Period where BizTerminalState<>3 order by currentyear,currentperiod)
if(@temp=0) ------��������
set @vouchertype='5794D3DD-7FE4-4B5C-AF53-D21DDC13BF16'
else ------��Ʊ����
set @vouchertype='314949e5-47d0-494a-b764-1e2751f88788'
select IdnoSettlepartner as Idpartner,
sum(BalanceAmount) as Amount from (--���� Ӧ������
--���
SELECT 
--����ͻ���
                                 noSettlepartner.ID   as IdnoSettlepartner,     --����ͻ�ID
ISNULL(Amount,0.0)-ISNULL(SettleAmount,0.0) as balanceAmount    --��ĩ���(����)
FROM (--�м��
Select sum(Amount) as Amount,
sum(SettleAmount) as SettleAmount,
										   IdnoSettlepartner From (--�ڲ�
SELECT
Detail.idnosettlepartner AS  IdnoSettlepartner,--�ͻ�
Detail.amount AS Amount,--Ӧ��Ӧ�����(����),Ӧ��Ӧ��
Detail.settleAmount AS SettleAmount--�����Ѹ����(����)
FROM ARAP_Detail AS Detail	
LEFT JOIN AA_Partner AS Partner ON Detail.idpartner = Partner.ID--����ͻ�
LEFT JOIN AA_Partner AS noSettlePartner ON Detail.idnosettlepartner = noSettlePartner.ID--�ͻ�
where (idarapvouchertype =@vouchertype or idarapvouchertype ='8DF77A52-3447-44D3-82FE-E4E6B3D4FE66' or idarapvouchertype =N'F24A0934-F191-4D8B-A17C-814ECBAA626F' or idarapvouchertype ='82CB65E8-12AB-4559-9AC6-B660A3D18E15' or idarapvouchertype ='0A6377A7-B4DD-4894-B134-C2D0A8E37B58' or idarapvouchertype ='7DFBC113-DAC5-402F-B4C9-CD427C33CC0F' or idarapvouchertype ='CCD85113-D257-43DA-85E3-DA441FD22A7A' or idarapvouchertype ='6267A967-A494-4C8C-8A75-DCFAF27E4357') 
and Detail.IsArFlag = 1 and Detail.registerDate<=GETDATE() and Detail.registerDate>=@qj
and ({Detail.iddepartment_DepartmentDTO} and {Detail.idperson_PersonDTO} and {Detail.idpartner_PartnerDTO}) 
 and Detail.auditFlag = 1 )AS Middle group by IdnoSettlepartner) AS ARAP LEFT JOIN AA_Partner AS noSettlepartner ON ARAP.IdnoSettlepartner = noSettlepartner.ID--������λ
UNION ALL  --���
SELECT  
--����ͻ���
                                 noSettlepartner.ID   as IdnoSettlepartner,     --����ͻ�ID
ISNULL(Amount,0.0)-ISNULL(SettleAmount,0.0) as balanceAmount    --��ĩ���(����)
FROM (--�м��
Select sum(Amount) as Amount,
sum(SettleAmount) as SettleAmount,
												IdnoSettlepartner From (--�ڲ�
SELECT
Detail.idnosettlepartner AS  IdnoSettlepartner,--�ͻ�
Detail.amount AS Amount,--Ӧ��Ӧ�����(����),Ӧ��Ӧ��
Detail.settleAmount AS SettleAmount--�����Ѹ����(����)
FROM ARAP_Detail AS Detail	
LEFT JOIN AA_Partner AS Partner ON Detail.idpartner = Partner.ID--����ͻ�
LEFT JOIN AA_Partner AS noSettlePartner ON Detail.idnosettlepartner = noSettlePartner.ID--�ͻ�
where Detail.IsArFlag = 1 
and ({Detail.iddepartment_DepartmentDTO} and {Detail.idperson_PersonDTO} and {Detail.idpartner_PartnerDTO})  
and Detail.registerDate<=@qj and Detail.auditFlag = 1 )AS Middle group by IdnoSettlepartner)  AS ARAP LEFT JOIN AA_Partner AS noSettlepartner ON ARAP.IdnoSettlepartner = noSettlepartner.ID--������λ
) as arap group by IdnoSettlepartner
order by Amount desc