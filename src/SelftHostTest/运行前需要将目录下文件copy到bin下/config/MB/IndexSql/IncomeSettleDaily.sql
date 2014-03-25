--今日收款 收款单统计表
select sum(isnull(arapsettles.Amount,0)) as Amount from  ARAP_ReceivePayment as arap
 left join  ARAP_ReceivePayment_MultiSettle  as arapsettles on arap.Id= arapsettles.idArapReceivePaymentDTO
 left join  eap_EnumItem  as voucherState on arap.voucherState=voucherState.Id
 where (datediff(day,arap.VoucherDate,getdate())=0) 
 and ({arap.Idpartner_PartnerDTO}
 and {arap.Iddepartment_DepartmentDTO}
 and {arap.Idperson_PersonDTO}
 and {arap.makerid_UserDTO}
 and {arap.idstore_StoreDTO}
 and {arap.Idproject_ProjectDTO})  
 and arap.isReceiveFlag=1