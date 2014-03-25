select COUNT(ArapReceivePaymentDTO.id)
from ARAP_ReceivePayment as ArapReceivePaymentDTO
where (ArapReceivePaymentDTO.auditor is Null or ArapReceivePaymentDTO.auditor='') and 
ArapReceivePaymentDTO.isReceiveFlag = 0 and (1=1 
and {ArapReceivePaymentDTO.Idpartner_PartnerDTO} 
and {ArapReceivePaymentDTO.Iddepartment_DepartmentDTO} 
and {ArapReceivePaymentDTO.Idperson_PersonDTO} 
and {ArapReceivePaymentDTO.makerId_UserDTO} 
and {ArapReceivePaymentDTO.Idproject_ProjectDTO} 
and (select count(*) from [ARAP_ReceivePayment_MultiSettle] as ArapMultiSettle where ArapMultiSettle.idArapReceivePaymentDTO = ArapReceivePaymentDTO.id and not({ArapMultiSettle.IdbankAccount_BankAccountDTO})) < 1 
and (select count(*) from [ARAP_ReceivePayment_b] as Arapb where Arapb.idArapReceivePaymentDTO = ArapReceivePaymentDTO.id and not({Arapb.idproject_ProjectDTO})) < 1 
and (select count(*) from [ARAP_ReceivePayment_b] as Arapb where Arapb.idArapReceivePaymentDTO = ArapReceivePaymentDTO.id and not({Arapb.idnosettlepartner_PartnerDTO})) < 1)