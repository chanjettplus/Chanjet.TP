--���д�� (�ֽ����������˺���Ϊ�����С����˺ű������ϼ�)
declare @temp int
select @temp=value from EAP_AccInformation where Name='CS'
if(@temp=0) ----�Ƿ����� �ֽ�����-����
select sum(isnull(amount,0) + isnull(inAmount,0) - isnull(outAmount,0)) AS Amount --������� 
from  CS_CashAccount  AS CashAccount
LEFT OUTER JOIN  AA_BankAccount AS BankAccount ON CashAccount.idbankaccount = BankAccount.id LEFT OUTER JOIN AA_Department  AS Department ON CashAccount.iddepartment = Department.id
LEFT OUTER JOIN  AA_Currency AS Currency ON BankAccount.idCurrency = Currency.id 
LEFT OUTER JOIN  eap_EnumItem AS EnumItem ON  BankAccount.bankNoType=EnumItem.ID
where BankAccount.bankNoType='d6db8097-aaef-40b1-9e7b-909569ae6901'
and (CashAccount.sourceVoucherDate <getdate()
and (( len(CashAccount.sourceVoucherAuditor) !=0 and isPeriodBeginning = 0) or isPeriodBeginning = 1 ))
and ({CashAccount.idbankaccount_BankAccountDTO})
else
select 
(select isnull(SUM(isnull(amount,0)),0)---�ڳ�ֵ
from CS_CashAccount  AS CashAccount
LEFT OUTER JOIN  AA_BankAccount AS BankAccount ON CashAccount.idbankaccount = BankAccount.id
where BankAccount.bankNoType='d6db8097-aaef-40b1-9e7b-909569ae6901'
and isPeriodBeginning=1
and ({CashAccount.idbankaccount_BankAccountDTO})
)+
(
select isnull(sum(isnull(amountDr,0) - isnull(amountCr,0)),0) AS Amount --�������
from CS_CashAccountDaily AS CashAccountDaily 
left join AA_BankAccount BankAccount on CashAccountDaily.idbankaccount=BankAccount.id
where BankAccount.bankNoType='d6db8097-aaef-40b1-9e7b-909569ae6901'
and CashAccountDaily.VoucherDate<GETDATE()
and {CashAccountDaily.idbankaccount_BankAccountDTO}
) as Amount