--�ۼ�Ƿ�����--
  Declare  @temp int
  Declare @tempID uniqueidentifier
  set @temp=(select value from EAP_AccInformation where Name='SAAccount')
if  @temp=0 set @tempID='5794D3DD-7FE4-4B5C-AF53-D21DDC13BF16'
else set @tempID='314949e5-47d0-494a-b764-1e2751f88788'
select top 1 a.Idpartner as cusid, a.BalanceAmount as amount,a.partnerName as cusname from ( select Idpartner as Idpartner,
partnerName as partnerName,

sum( Amount ) as Amount,
sum( SettleAmount ) as SettleAmount,
sum(BalanceAmount) as BalanceAmount from (--���� Ӧ������
                            --���
                            SELECT 
                                 partner.ID   as Idpartner,     --�ͻ�ID
                                 partner.Code AS partnerCode,    --�ͻ�����
                                 partner.Name AS partnerName,    --�ͻ�
                                 partner.PartnerAbbName AS partnerAbbName,--�ͻ����
                                 --partnerclass.ID as IdpartnerClass,  --�ͻ�����ID
                                 --partnerClass.Name as partnerClassName,  --�ͻ�����
   	
                                --�ֹܲ���
                                 saleDepartment.Id as IdsaleDepartment,	--�ֹܲ���ID
                                 saleDepartment.Code AS saleDepartmentCode,--�ֹܲ��ű���
                                 saleDepartment.Name AS saleDepartmentName,--�ֹܲ���
                            	
                                --�ֹ���Ա
                                 saleMan.Id as IdsaleMan,    --�ֹ���ԱID
                                 saleMan.Code AS saleManCode,--�ֹ���Ա����
                                 saleMan.Name AS saleManName,  --�ֹ���Ա
                            	
                                --����
                                 District.Id as Iddistricts,--����ID
                                 District.Code AS districtCode, --��������
                                 District.Name AS districtName,--����
                                ARAP.origAmount AS origAmount,--Ӧ��
                                ARAP.Amount AS Amount,	   --Ӧ�գ����ң�
                                ARAP.origSettleAmount AS origSettleAmount ,  --����
                                ARAP.SettleAmount AS settleAmount,	  --���գ����ң�
                                ARAP.origInAllowances as origAllowances,	 --��������
                                ARAP.InAllowances as allowances,     --�������ã����ң�	
				                ISNULL(origAmount,0.0)-ISNULL(origSettleAmount,0.0) as origBalanceAmount,--��ĩ���
				                ISNULL(Amount,0.0)-ISNULL(SettleAmount,0.0) as balanceAmount    --��ĩ���(����)

                                FROM (--�м��
                                    Select sum(origAmount) as origAmount,
                                           sum(Amount) as Amount,
                                           sum(origSettleAmount) as origSettleAmount,
                                           sum(SettleAmount) as SettleAmount,
                                           sum(origInAllowances) as origInAllowances,
                                           sum(InAllowances) as InAllowances,Idpartner From (--�ڲ�
            SELECT
            Partner.idpartnerclass AS IdpartnerClass,--����ͻ�����
	        Detail.idpartner AS idpartner,--����ͻ�         
			noSettlepartner.idpartnerclass AS IdnoSettlepartnerClass,--�ͻ�����
            Detail.idnosettlepartner AS  IdnoSettlepartner,--�ͻ�
	        Detail.iddepartment AS iddepartment,--����ID
            Detail.idperson AS idperson,--ҵ��ԱID	
	        Detail.idcurrency AS idcurrency,--����ID
	                Detail.origAmount AS origAmount, --(Ӧ��Ӧ��)
	                Detail.amount AS Amount,--Ӧ��Ӧ�����(����),Ӧ��Ӧ��

	                Detail.origSettleAmount AS origSettleAmount, --�����Ѹ����  
	                Detail.settleAmount AS SettleAmount,--�����Ѹ����(����)
            Detail.origInAllowances AS origInAllowances,--�������� 
	        Detail.inAllowances AS InAllowances ,--�������ñ���	
        	
	        REPLACE(STR(Detail.year) + '.' + RIGHT('00'+Cast(Detail.period as varchar),2), ' ', '') AS period

            FROM ARAP_Detail AS Detail	
	        LEFT JOIN AA_Partner AS Partner ON Detail.idpartner = Partner.ID--����ͻ�
            LEFT JOIN AA_Partner AS noSettlePartner ON Detail.idnosettlepartner = noSettlePartner.ID--�ͻ�
             where ( idarapvouchertype =@tempID or idarapvouchertype ='8DF77A52-3447-44D3-82FE-E4E6B3D4FE66' or idarapvouchertype ='82CB65E8-12AB-4559-9AC6-B660A3D18E15' or idarapvouchertype ='0A6377A7-B4DD-4894-B134-C2D0A8E37B58' or idarapvouchertype ='7DFBC113-DAC5-402F-B4C9-CD427C33CC0F' or idarapvouchertype ='CCD85113-D257-43DA-85E3-DA441FD22A7A' or idarapvouchertype ='6267A967-A494-4C8C-8A75-DCFAF27E4357') and Detail.IsArFlag = 1    --����Ȩ��---
               and (  1=1  and  {Detail.iddepartment_DepartmentDTO} and {Detail.idperson_PersonDTO} and {Detail.idpartner_PartnerDTO} 
             --����Ȩ��---
             
              and     (detail.registerDate<=CONVERT(varchar(100), GETDATE(), 23)  and detail.registerDate>=(select   (select begindate from sm_period where  CONVERT(varchar(12),getdate(),23) between begindate and enddate)))
              
               and Detail.auditFlag = 1 )) AS Middle group by Idpartner) AS ARAP LEFT JOIN AA_Partner AS partner ON ARAP.Idpartner = partner.ID--������λ
				LEFT JOIN AA_Department AS SaleDepartment ON Partner.idsaledepartment = SaleDepartment.ID--�ֹܲ���
				LEFT JOIN AA_Person AS SaleMan ON Partner.idsaleman = SaleMan.ID--�ֹ���Ա
				LEFT JOIN AA_District AS District ON Partner.iddistrict = District.ID--����
                UNION ALL  --���
                        	    SELECT  
                        	    
                                 partner.ID   as Idpartner,     --�ͻ�ID
                                 partner.Code AS partnerCode,    --�ͻ�����
                                 partner.Name AS partnerName,    --�ͻ�
                                 partner.PartnerAbbName AS partnerAbbName,--�ͻ����
                                 --partnerclass.ID as IdpartnerClass,  --�ͻ�����ID
                                 --partnerClass.Name as partnerClassName,  --�ͻ�����
   	
                                --�ֹܲ���
                                 saleDepartment.Id as IdsaleDepartment,	--�ֹܲ���ID
                                 saleDepartment.Code AS saleDepartmentCode,--�ֹܲ��ű���
                                 saleDepartment.Name AS saleDepartmentName,--�ֹܲ���
                            	
                                --�ֹ���Ա
                                 saleMan.Id as IdsaleMan,    --�ֹ���ԱID
                                 saleMan.Code AS saleManCode,--�ֹ���Ա����
                                 saleMan.Name AS saleManName,  --�ֹ���Ա
                            	
                                --����
                                 District.Id as Iddistricts,--����ID
                                 District.Code AS districtCode, --��������
                                 District.Name AS districtName,--����    	
                                0.0 AS origAmount,     --Ӧ��
                                0.0 AS Amount,	        --Ӧ�գ����ң�
                            		
                                0.0 AS origSettleAmount,  --����
                                0.0 AS settleAmount,	  --���գ����ң�

                                0.0 AS  origAllowances,	 --��������
                                0.0 AS  allowances,     --�������ã����ң�	
                                
				                ISNULL(origAmount,0.0)-ISNULL(origSettleAmount,0.0) as origBalanceAmount,--��ĩ���
				                ISNULL(Amount,0.0)-ISNULL(SettleAmount,0.0) as balanceAmount    --��ĩ���(����)

                                FROM (--�м��
                                         Select sum(origAmount) as origAmount,
                                                sum(Amount) as Amount,
                                                sum(origSettleAmount) as origSettleAmount,
                                                sum(SettleAmount) as SettleAmount,
                                                sum(origInAllowances) as origInAllowances,
                                                sum(InAllowances) as InAllowances,Idpartner From (--�ڲ�
            SELECT
            Partner.idpartnerclass AS IdpartnerClass,--����ͻ�����
	        Detail.idpartner AS idpartner,--����ͻ�         
			noSettlepartner.idpartnerclass AS IdnoSettlepartnerClass,--�ͻ�����
            Detail.idnosettlepartner AS  IdnoSettlepartner,--�ͻ�
	        Detail.iddepartment AS iddepartment,--����ID
            Detail.idperson AS idperson,--ҵ��ԱID	
	        Detail.idcurrency AS idcurrency,--����ID
	                Detail.origAmount AS origAmount, --(Ӧ��Ӧ��)
	                Detail.amount AS Amount,--Ӧ��Ӧ�����(����),Ӧ��Ӧ��

	                Detail.origSettleAmount AS origSettleAmount, --�����Ѹ����  
	                Detail.settleAmount AS SettleAmount,--�����Ѹ����(����)
            Detail.origInAllowances AS origInAllowances,--�������� 
	        Detail.inAllowances AS InAllowances ,--�������ñ���	
        	
	        REPLACE(STR(Detail.year) + '.' + RIGHT('00'+Cast(Detail.period as varchar),2), ' ', '') AS period

            FROM ARAP_Detail AS Detail	
	        LEFT JOIN AA_Partner AS Partner ON Detail.idpartner = Partner.ID--����ͻ�
            LEFT JOIN AA_Partner AS noSettlePartner ON Detail.idnosettlepartner = noSettlePartner.ID--�ͻ�
             where Detail.IsArFlag = 1 
              --����Ȩ��---
              and (  1=1  and {Detail.iddepartment_DepartmentDTO} and {Detail.idperson_PersonDTO} and {Detail.idpartner_PartnerDTO}
             --����Ȩ��---
             
              and  1=1  and detail.registerDate<(select  CONVERT(varchar(100),  (select begindate from sm_period where  getdate() between begindate and enddate), 23)) and Detail.auditFlag = 1 )) AS Middle group by Idpartner)  AS ARAP LEFT JOIN AA_Partner AS partner ON ARAP.Idpartner = partner.ID--������λ
				LEFT JOIN AA_Department AS SaleDepartment ON Partner.idsaledepartment = SaleDepartment.ID--�ֹܲ���
				LEFT JOIN AA_Person AS SaleMan ON Partner.idsaleman = SaleMan.ID--�ֹ���Ա
				LEFT JOIN AA_District AS District ON Partner.iddistrict = District.ID--����
                ) as arap group by Idpartner,partnerName) a order by a.BalanceAmount desc
