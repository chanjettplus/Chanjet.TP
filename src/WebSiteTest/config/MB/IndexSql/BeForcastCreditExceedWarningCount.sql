Select count(*) from (select orderunoutamount as orderunoutamount,outunsettleamount as outunsettleamount,
isnull(salesettleamount,0) as salesettleamount,isnull(incomeunsettleamount,0) as incomeunsettleamount,
isnull(receiveuncancelamount,0) as receiveuncancelamount ,isnull(AA_Partner.SaleCreditLine,0) as saleCreditLine,isnull(expenseSettleAmount,0) as expenseSettleAmount ,
 (select value from EAP_AccInformation where Name='IsOrderedButNoSend') as IsOrderedButNoSend,
(select value from EAP_AccInformation where Name='IsSendedButNoBalance') as IsSendedButNoBalance,
(select value from EAP_AccInformation where Name='IsPrepay') as IsPrepay,
(select value from EAP_AccInformation where Name='IsRevenueBill') as IsRevenueBill,
(select value from EAP_AccInformation where Name='IsReceivableAccount') as IsReceivableAccount,
(select value from EAP_AccInformation where Name='IsExpenseBill') as IsExpenseBill
from SA_CreditOccupancy as CreditOccupancy
inner join AA_Partner on CreditOccupancy.idcustomer=AA_Partner.id
left join AA_Person on AA_Person.id=AA_Partner.IdsaleMan
left join AA_Department on AA_Department.id=AA_Partner.IdsaleDepartment
where AA_Partner.SaleCreditLine is not null
 and {CreditOccupancy.idcustomer_PartnerDTO} 
) as tmpTable
 where (saleCreditLine
                                    -case when IsOrderedButNoSend=1 then orderunoutamount else 0 end
                                    -case when IsSendedButNoBalance=1 then  outunsettleamount else 0 end
                                    +case when IsPrepay=1 then  receiveuncancelamount else 0 end
                                    -case when IsRevenueBill=1 then  incomeunsettleamount else 0 end
                                    -case when IsReceivableAccount=1 then  salesettleamount else 0 end
                                      +case when IsExpenseBill=1 then  expenseSettleAmount else 0 end
                                )<0 -----信用超额预警个数