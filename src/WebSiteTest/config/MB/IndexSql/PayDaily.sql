---Ӧ�� ���ҽ��
Declare @temp int
declare @qj datetime
declare @vouchertype varchar(50)
set @temp=(select value from EAP_AccInformation where Name='PUAccount')
set @qj=(select top 1 begindate from SM_Period where BizTerminalState<>3 order by currentyear,currentperiod)
if(@temp=0) ------��������
set @vouchertype='5399D7A6-8B61-459A-AC53-5C208D1BC871'
else ------��Ʊ����
set @vouchertype='267210C0-CD76-404B-B311-BB89CE8EC7D2'
select Idpartner as Idpartner,
sum(BalanceAmount) as Amount from (--���� Ӧ������
--���
SELECT
--����ͻ���
partner.ID   as Idpartner,     --�ͻ�ID
ISNULL(Amount,0.0)-ISNULL(SettleAmount,0.0) as balanceAmount    --��ĩ���(����)
FROM (--�м��
Select sum(Amount) as Amount,
sum(SettleAmount) as SettleAmount,
Idpartner From (--�ڲ�
SELECT
Detail.idpartner AS idpartner,--������λID
Detail.amount AS Amount,--Ӧ��Ӧ�����(����),Ӧ��Ӧ�� 
Detail.settleAmount AS SettleAmount--�����Ѹ����(����)
FROM ARAP_Detail AS Detail	
LEFT JOIN AA_Partner AS Partner ON Detail.idpartner = Partner.ID--������λ
where ( idarapvouchertype =@vouchertype or idarapvouchertype ='F7E2CB97-A5D2-43A0-8DAE-E2FB90F0FDF2' or idarapvouchertype ='552ED4F9-A784-4C6B-AFCF-BBE77F9AFDCD' or idarapvouchertype ='D6E84177-11E2-4187-BE88-C340BAD1FAFA' or idarapvouchertype ='C044589E-F4DF-4995-912D-D5D252721048' or idarapvouchertype ='CCD85113-D257-43DA-85E3-DA441FD22A7A' or idarapvouchertype ='6267A967-A494-4C8C-8A75-DCFAF27E4357') 
and Detail.IsArFlag = 0  and Detail.registerDate<=GETDATE()
and ({Detail.iddepartment_DepartmentDTO} and {Detail.idperson_PersonDTO} and {Detail.idpartner_PartnerDTO})  
and Detail.registerDate >= @qj and Detail.auditFlag = 1 )AS Middle group by Idpartner) AS ARAP LEFT JOIN AA_Partner AS partner ON ARAP.Idpartner = partner.ID--������λ
UNION ALL  --���
SELECT  
--����ͻ���
partner.ID   as Idpartner,     --�ͻ�ID
ISNULL(Amount,0.0)-ISNULL(SettleAmount,0.0) as balanceAmount    --��ĩ���(����)
FROM (--�м��
Select sum(Amount) as Amount,
sum(SettleAmount) as SettleAmount,
Idpartner From (--�ڲ�
SELECT
Detail.idpartner AS idpartner,--������λID
Detail.amount AS Amount,--Ӧ��Ӧ�����(����),Ӧ��Ӧ��  
Detail.settleAmount AS SettleAmount--�����Ѹ����(����)
FROM ARAP_Detail AS Detail	
LEFT JOIN AA_Partner AS Partner ON Detail.idpartner = Partner.ID--������λ
where Detail.IsArFlag = 0 
and ({Detail.iddepartment_DepartmentDTO} and {Detail.idperson_PersonDTO} and {Detail.idpartner_PartnerDTO}) 
and Detail.registerDate<@qj and Detail.auditFlag = 1 )AS Middle group by Idpartner)  AS ARAP LEFT JOIN AA_Partner AS partner ON ARAP.Idpartner = partner.ID--������λ
) as arap group by Idpartner
order by Amount desc