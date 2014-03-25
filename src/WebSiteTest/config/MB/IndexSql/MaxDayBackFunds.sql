--今日/回款最多(条件加上单据日期)--
select top 1 person.id as clerkid, SUM(detail.amount) as amount,person.name as clerkName from ARAP_ReceivePayment_MultiSettle  detail
left join ARAP_ReceivePayment dto on dto.id=detail.idArapReceivePaymentDTO
left join AA_Person  person on person.id=dto.idperson
left join AA_Currency currency on currency.id=dto.idcurrency
where isReceiveFlag=1 and dto.idperson is not null 
and datediff(DAY,dto.voucherdate,GETDATE())=0 
and {dto.makerId_userDTO} and  {dto.idpartner_partnerDTO} and {dto.idperson_personDTO} and {dto.idproject_projectDTO} and {dto.iddepartment_departmentDTO} and {detail.idbankaccount_bankAccountDTO} 
group by person.name ,person.id order by amount desc