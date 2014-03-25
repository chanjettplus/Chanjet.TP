--本月欠款最多客户--
  Declare  @temp int
  Declare @tempID uniqueidentifier
  set @temp=(select value from EAP_AccInformation where Name='SAAccount')
if  @temp=0 set @tempID='5794D3DD-7FE4-4B5C-AF53-D21DDC13BF16'
else set @tempID='314949e5-47d0-494a-b764-1e2751f88788'
 
 select top 1
partnerName as cusName, cusid,
sum(BalanceAmount) as amount from (--往来 应收总账  
				--外层
                        SELECT  
                        --结算客户组
                        Partner.ID   as cusid,     --结算客户ID
                        partnername, 
                        ISNULL(Amount,0.0)-ISNULL(SettleAmount,0.0) as balanceAmount    --期末余额(本币)
                        FROM (--中间层
                        Select sum(Amount) as Amount,
                        sum(SettleAmount) as SettleAmount,
						Idpartner,partnername From (--内层
                        SELECT
                        Detail.Idpartner AS  Idpartner,--客户 
                        Partner.name as partnername, 
                        Detail.amount AS Amount,--应收应付金额(本币),应收应付
                        Detail.settleAmount AS SettleAmount--已收已付金额(本币)
                        FROM ARAP_Detail AS Detail	
                        LEFT JOIN AA_Partner AS Partner ON Detail.Idpartner = Partner.ID--结算客户                       
                        where 1=1
             and Detail.IsArFlag = 1   
                            ---数据权限--
             and (  1=1  
             and  {Detail.iddepartment_DepartmentDTO} and {Detail.idperson_PersonDTO} and {Detail.idpartner_PartnerDTO}        
             )
           ---数据权限--  
                        and Detail.registerDate < =GETDATE()
                        and Detail.auditFlag = 1 )AS Middle group by Idpartner,partnername)  AS ARAP 
                        LEFT JOIN AA_Partner AS Partner ON ARAP.Idpartner = Partner.ID--往来单位	
                )as arap 
group by partnerName ,cusid
                 order by amount desc