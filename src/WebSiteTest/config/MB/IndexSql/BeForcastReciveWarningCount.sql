declare @endDate datetime
declare @daycount int
declare @audit int
select @daycount=value from EAP_AccInformation where Name='ReceiveWarningDays'
select @audit=isneedaudit from SM_VoucherType where code='ARAP01'
set @endDate=DATEADD(d,@daycount,GETDATE())
if(@audit=0)
select count(1)as ReciveCount
from [ARAP_Detail] [ArapDetailDTO]
where  arapdetaildto.isarflag=1 and arapdetaildto.auditflag=1 and arapdetaildto.auditbussinessflag=1 and arapdetaildto.prepayflag=0 
and '0'+cast(arapdetaildto.id as varchar(40)) in (select zzdid from (select min (arap_detail.bussinessflag+cast(arap_detail.id as varchar(40))) as zzdid ,sum(arap_detail.origamount-arap_detail.origsettleamount ) as rorigamount from arap_detail 
left join arap_detail s on s.isarflag=1 and s.voucherdetailid = arap_detail.voucherdetailid and s.idvouchertype = s.idarapvouchertype and s.auditbussinessflag=1 and s.auditflag = 1 and s.prepayflag=0 
where arap_detail.isarflag=1 and arap_detail.auditbussinessflag=1 and arap_detail.auditflag = 1 and arap_detail.prepayflag=0 and (arap_detail.auditflag='1' or arap_detail.bussinessflag='1' or (arap_detail.bussinessflag='2' and arap_detail.idarapvouchertype in ('{0A6377A7-B4DD-4894-B134-C2D0A8E37B58}','{D6E84177-11E2-4187-BE88-C340BAD1FAFA}','{CCD85113-D257-43DA-85E3-DA441FD22A7A}'))) 
and ( arap_detail.arrivaldate<=@endDate) group by arap_detail.idpartner,arap_detail.idvouchertype,arap_detail.voucherid ) zzd where rorigamount<>0 and bussinessflag=0 ) and 1=1 
and {arapdetaildto.idpartner_PartnerDTO} 
and ({arapdetaildto.iddepartment_DepartmentDTO}) 
and ({arapdetaildto.idperson_PersonDTO}) ------收款预警个数
else
select count(1)as ReciveCount
from [ARAP_Detail] [ArapDetailDTO]
where  arapdetaildto.isarflag=1 and arapdetaildto.auditflag=1 and arapdetaildto.auditbussinessflag=1 and arapdetaildto.prepayflag=0 and arapdetaildto.id in (select zzdid from (select min (cast(case when arap_detail.bussinessflag = 0 then arap_detail.id else N'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF' end as varchar(40))) as zzdid ,sum(arap_detail.origamount-arap_detail.origsettleamount + case when m.id is null then 0 else arap_detail.origcashamount end) as rorigamount from arap_detail left join arap_detail s on s.isarflag=1 and s.voucherdetailid = arap_detail.voucherdetailid and s.idvouchertype = s.idarapvouchertype and s.auditbussinessflag=1 and s.auditflag = 1 and s.prepayflag=0 
 left join arap_receivepayment m on m.isreceiveflag=1 and m.isauto=1 and m.auditorid is null and m.sourcevoucherid=arap_detail.voucherid where arap_detail.isarflag=1 and arap_detail.auditbussinessflag=1 and arap_detail.auditflag = 1 and arap_detail.prepayflag=0 and (arap_detail.auditflag=N'1' or arap_detail.bussinessflag=N'1' or (arap_detail.bussinessflag=N'2' and arap_detail.idarapvouchertype in (N'{0A6377A7-B4DD-4894-B134-C2D0A8E37B58}',N'{D6E84177-11E2-4187-BE88-C340BAD1FAFA}',N'{CCD85113-D257-43DA-85E3-DA441FD22A7A}'))) 
and ( arap_detail.arrivaldate<=@endDate) 
group by arap_detail.idpartner,arap_detail.idvouchertype,arap_detail.voucherid ) zzd where rorigamount<>0 and bussinessflag=0 )
and {arapdetaildto.idpartner_PartnerDTO} 
and ({arapdetaildto.iddepartment_DepartmentDTO}) 
and ({arapdetaildto.idperson_PersonDTO}) ------收款预警个数