--累计欠款最多--
  Declare  @temp int
  Declare @tempID uniqueidentifier
  set @temp=(select value from EAP_AccInformation where Name='SAAccount')
if  @temp=0 set @tempID='5794D3DD-7FE4-4B5C-AF53-D21DDC13BF16'
else set @tempID='314949e5-47d0-494a-b764-1e2751f88788'
select top 1 a.Idpartner as cusid, a.BalanceAmount as amount,a.partnerName as cusname from ( select Idpartner as Idpartner,
partnerName as partnerName,

sum( Amount ) as Amount,
sum( SettleAmount ) as SettleAmount,
sum(BalanceAmount) as BalanceAmount from (--往来 应收总账
                            --外层
                            SELECT 
                                 partner.ID   as Idpartner,     --客户ID
                                 partner.Code AS partnerCode,    --客户编码
                                 partner.Name AS partnerName,    --客户
                                 partner.PartnerAbbName AS partnerAbbName,--客户简称
                                 --partnerclass.ID as IdpartnerClass,  --客户分类ID
                                 --partnerClass.Name as partnerClassName,  --客户分类
   	
                                --分管部门
                                 saleDepartment.Id as IdsaleDepartment,	--分管部门ID
                                 saleDepartment.Code AS saleDepartmentCode,--分管部门编码
                                 saleDepartment.Name AS saleDepartmentName,--分管部门
                            	
                                --分管人员
                                 saleMan.Id as IdsaleMan,    --分管人员ID
                                 saleMan.Code AS saleManCode,--分管人员编码
                                 saleMan.Name AS saleManName,  --分管人员
                            	
                                --地区
                                 District.Id as Iddistricts,--地区ID
                                 District.Code AS districtCode, --地区编码
                                 District.Name AS districtName,--地区
                                ARAP.origAmount AS origAmount,--应收
                                ARAP.Amount AS Amount,	   --应收（本币）
                                ARAP.origSettleAmount AS origSettleAmount ,  --已收
                                ARAP.SettleAmount AS settleAmount,	  --已收（本币）
                                ARAP.origInAllowances as origAllowances,	 --其中折让
                                ARAP.InAllowances as allowances,     --其中折让（本币）	
				                ISNULL(origAmount,0.0)-ISNULL(origSettleAmount,0.0) as origBalanceAmount,--期末余额
				                ISNULL(Amount,0.0)-ISNULL(SettleAmount,0.0) as balanceAmount    --期末余额(本币)

                                FROM (--中间层
                                    Select sum(origAmount) as origAmount,
                                           sum(Amount) as Amount,
                                           sum(origSettleAmount) as origSettleAmount,
                                           sum(SettleAmount) as SettleAmount,
                                           sum(origInAllowances) as origInAllowances,
                                           sum(InAllowances) as InAllowances,Idpartner From (--内层
            SELECT
            Partner.idpartnerclass AS IdpartnerClass,--结算客户分类
	        Detail.idpartner AS idpartner,--结算客户         
			noSettlepartner.idpartnerclass AS IdnoSettlepartnerClass,--客户分类
            Detail.idnosettlepartner AS  IdnoSettlepartner,--客户
	        Detail.iddepartment AS iddepartment,--部门ID
            Detail.idperson AS idperson,--业务员ID	
	        Detail.idcurrency AS idcurrency,--币种ID
	                Detail.origAmount AS origAmount, --(应收应付)
	                Detail.amount AS Amount,--应收应付金额(本币),应收应付

	                Detail.origSettleAmount AS origSettleAmount, --已收已付金额  
	                Detail.settleAmount AS SettleAmount,--已收已付金额(本币)
            Detail.origInAllowances AS origInAllowances,--其中折让 
	        Detail.inAllowances AS InAllowances ,--其中折让本币	
        	
	        REPLACE(STR(Detail.year) + '.' + RIGHT('00'+Cast(Detail.period as varchar),2), ' ', '') AS period

            FROM ARAP_Detail AS Detail	
	        LEFT JOIN AA_Partner AS Partner ON Detail.idpartner = Partner.ID--结算客户
            LEFT JOIN AA_Partner AS noSettlePartner ON Detail.idnosettlepartner = noSettlePartner.ID--客户
             where ( idarapvouchertype =@tempID or idarapvouchertype ='8DF77A52-3447-44D3-82FE-E4E6B3D4FE66' or idarapvouchertype ='82CB65E8-12AB-4559-9AC6-B660A3D18E15' or idarapvouchertype ='0A6377A7-B4DD-4894-B134-C2D0A8E37B58' or idarapvouchertype ='7DFBC113-DAC5-402F-B4C9-CD427C33CC0F' or idarapvouchertype ='CCD85113-D257-43DA-85E3-DA441FD22A7A' or idarapvouchertype ='6267A967-A494-4C8C-8A75-DCFAF27E4357') and Detail.IsArFlag = 1    --数据权限---
               and (  1=1  and  {Detail.iddepartment_DepartmentDTO} and {Detail.idperson_PersonDTO} and {Detail.idpartner_PartnerDTO} 
             --数据权限---
             
              and     (detail.registerDate<=CONVERT(varchar(100), GETDATE(), 23)  and detail.registerDate>=(select   (select begindate from sm_period where  CONVERT(varchar(12),getdate(),23) between begindate and enddate)))
              
               and Detail.auditFlag = 1 )) AS Middle group by Idpartner) AS ARAP LEFT JOIN AA_Partner AS partner ON ARAP.Idpartner = partner.ID--往来单位
				LEFT JOIN AA_Department AS SaleDepartment ON Partner.idsaledepartment = SaleDepartment.ID--分管部门
				LEFT JOIN AA_Person AS SaleMan ON Partner.idsaleman = SaleMan.ID--分管人员
				LEFT JOIN AA_District AS District ON Partner.iddistrict = District.ID--地区
                UNION ALL  --外层
                        	    SELECT  
                        	    
                                 partner.ID   as Idpartner,     --客户ID
                                 partner.Code AS partnerCode,    --客户编码
                                 partner.Name AS partnerName,    --客户
                                 partner.PartnerAbbName AS partnerAbbName,--客户简称
                                 --partnerclass.ID as IdpartnerClass,  --客户分类ID
                                 --partnerClass.Name as partnerClassName,  --客户分类
   	
                                --分管部门
                                 saleDepartment.Id as IdsaleDepartment,	--分管部门ID
                                 saleDepartment.Code AS saleDepartmentCode,--分管部门编码
                                 saleDepartment.Name AS saleDepartmentName,--分管部门
                            	
                                --分管人员
                                 saleMan.Id as IdsaleMan,    --分管人员ID
                                 saleMan.Code AS saleManCode,--分管人员编码
                                 saleMan.Name AS saleManName,  --分管人员
                            	
                                --地区
                                 District.Id as Iddistricts,--地区ID
                                 District.Code AS districtCode, --地区编码
                                 District.Name AS districtName,--地区    	
                                0.0 AS origAmount,     --应收
                                0.0 AS Amount,	        --应收（本币）
                            		
                                0.0 AS origSettleAmount,  --已收
                                0.0 AS settleAmount,	  --已收（本币）

                                0.0 AS  origAllowances,	 --其中折让
                                0.0 AS  allowances,     --其中折让（本币）	
                                
				                ISNULL(origAmount,0.0)-ISNULL(origSettleAmount,0.0) as origBalanceAmount,--期末余额
				                ISNULL(Amount,0.0)-ISNULL(SettleAmount,0.0) as balanceAmount    --期末余额(本币)

                                FROM (--中间层
                                         Select sum(origAmount) as origAmount,
                                                sum(Amount) as Amount,
                                                sum(origSettleAmount) as origSettleAmount,
                                                sum(SettleAmount) as SettleAmount,
                                                sum(origInAllowances) as origInAllowances,
                                                sum(InAllowances) as InAllowances,Idpartner From (--内层
            SELECT
            Partner.idpartnerclass AS IdpartnerClass,--结算客户分类
	        Detail.idpartner AS idpartner,--结算客户         
			noSettlepartner.idpartnerclass AS IdnoSettlepartnerClass,--客户分类
            Detail.idnosettlepartner AS  IdnoSettlepartner,--客户
	        Detail.iddepartment AS iddepartment,--部门ID
            Detail.idperson AS idperson,--业务员ID	
	        Detail.idcurrency AS idcurrency,--币种ID
	                Detail.origAmount AS origAmount, --(应收应付)
	                Detail.amount AS Amount,--应收应付金额(本币),应收应付

	                Detail.origSettleAmount AS origSettleAmount, --已收已付金额  
	                Detail.settleAmount AS SettleAmount,--已收已付金额(本币)
            Detail.origInAllowances AS origInAllowances,--其中折让 
	        Detail.inAllowances AS InAllowances ,--其中折让本币	
        	
	        REPLACE(STR(Detail.year) + '.' + RIGHT('00'+Cast(Detail.period as varchar),2), ' ', '') AS period

            FROM ARAP_Detail AS Detail	
	        LEFT JOIN AA_Partner AS Partner ON Detail.idpartner = Partner.ID--结算客户
            LEFT JOIN AA_Partner AS noSettlePartner ON Detail.idnosettlepartner = noSettlePartner.ID--客户
             where Detail.IsArFlag = 1 
              --数据权限---
              and (  1=1  and {Detail.iddepartment_DepartmentDTO} and {Detail.idperson_PersonDTO} and {Detail.idpartner_PartnerDTO}
             --数据权限---
             
              and  1=1  and detail.registerDate<(select  CONVERT(varchar(100),  (select begindate from sm_period where  getdate() between begindate and enddate), 23)) and Detail.auditFlag = 1 )) AS Middle group by Idpartner)  AS ARAP LEFT JOIN AA_Partner AS partner ON ARAP.Idpartner = partner.ID--往来单位
				LEFT JOIN AA_Department AS SaleDepartment ON Partner.idsaledepartment = SaleDepartment.ID--分管部门
				LEFT JOIN AA_Person AS SaleMan ON Partner.idsaleman = SaleMan.ID--分管人员
				LEFT JOIN AA_District AS District ON Partner.iddistrict = District.ID--地区
                ) as arap group by Idpartner,partnerName) a order by a.BalanceAmount desc
