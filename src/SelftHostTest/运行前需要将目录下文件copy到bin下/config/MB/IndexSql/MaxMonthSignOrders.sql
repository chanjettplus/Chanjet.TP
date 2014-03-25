--本月签单 最多
 select top 1 person.id as clerkid, COUNT(dto.id) as number,person.name  as clerkname,SUM(dto.taxAmount) as amount from AA_person  person
 left join  SA_SaleOrder dto on person.id=dto.idclerk
where  datediff(MONTH,dto.voucherdate,GETDATE())=0 and dto.voucherState<>'FDDC74ED-4027-4575-9CBB-7BF27965EE9B'  and {dto.iddepartment_departmentDTO} and {dto.idclerk_personDTO} and {dto.idcustomer_partnerDTO} and {dto.idproject_projectDTO}  and {dto.makerid_userdto}
group by person.name ,person.id order by number desc