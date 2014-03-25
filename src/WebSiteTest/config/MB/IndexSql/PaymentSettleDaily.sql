--今日付款 付款单统计表
select sum(isnull(arapsettles.Amount,0)) as Amount from  ARAP_ReceivePayment as arap
 left join  ARAP_ReceivePayment_MultiSettle  as arapsettles on arap.Id= arapsettles.idArapReceivePaymentDTO
 left join  eap_EnumItem  as voucherState on arap.voucherState=voucherState.Id
 where (datediff(day,arap.VoucherDate,GETDATE())=0) 
 and ({arap.Idpartner_PartnerDTO}
 and {arap.Iddepartment_DepartmentDTO}
 and {arap.Idperson_PersonDTO}
 and {arap.makerid_UserDTO}
 and {arap.Idproject_ProjectDTO}) 
 and arap.isReceiveFlag=0