--����Ƿ�����ͻ�--
  Declare  @temp int
  Declare @tempID uniqueidentifier
  set @temp=(select value from EAP_AccInformation where Name='SAAccount')
if  @temp=0 set @tempID='5794D3DD-7FE4-4B5C-AF53-D21DDC13BF16'
else set @tempID='314949e5-47d0-494a-b764-1e2751f88788'
 
 select top 1
partnerName as cusName, cusid,
sum(BalanceAmount) as amount from (--���� Ӧ������  
				--���
                        SELECT  
                        --����ͻ���
                        Partner.ID   as cusid,     --����ͻ�ID
                        partnername, 
                        ISNULL(Amount,0.0)-ISNULL(SettleAmount,0.0) as balanceAmount    --��ĩ���(����)
                        FROM (--�м��
                        Select sum(Amount) as Amount,
                        sum(SettleAmount) as SettleAmount,
						Idpartner,partnername From (--�ڲ�
                        SELECT
                        Detail.Idpartner AS  Idpartner,--�ͻ� 
                        Partner.name as partnername, 
                        Detail.amount AS Amount,--Ӧ��Ӧ�����(����),Ӧ��Ӧ��
                        Detail.settleAmount AS SettleAmount--�����Ѹ����(����)
                        FROM ARAP_Detail AS Detail	
                        LEFT JOIN AA_Partner AS Partner ON Detail.Idpartner = Partner.ID--����ͻ�                       
                        where 1=1
             and Detail.IsArFlag = 1   
                            ---����Ȩ��--
             and (  1=1  
             and  {Detail.iddepartment_DepartmentDTO} and {Detail.idperson_PersonDTO} and {Detail.idpartner_PartnerDTO}        
             )
           ---����Ȩ��--  
                        and Detail.registerDate < =GETDATE()
                        and Detail.auditFlag = 1 )AS Middle group by Idpartner,partnername)  AS ARAP 
                        LEFT JOIN AA_Partner AS Partner ON ARAP.Idpartner = Partner.ID--������λ	
                )as arap 
group by partnerName ,cusid
                 order by amount desc