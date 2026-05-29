@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate entry item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_GATEENTRY_ITM
  as select from ztgate_item

  association to parent ZI_GATEENTRY_hdr as _ADV_HEAD on $projection.zid = _ADV_HEAD.zid
  //                                                     and $projection.Zgate = _ADV_HEAD.Zgate
{
  key    zid,
  key    ebeln        as Ebeln,
  key    ebelp        as Ebelp,
         zgate        as Zgate,

         vend         as Vend,
         name         as Name,
         mat          as Mat,
         matdesc      as Matdesc,
         storage      as storage,
         order_qty    as OrderQty,
         received_qty as ReceivedQty,
         uom          as Uom,
         qty          as qty,
         bill_no      as BillNo,
         remark       as Remark,
         mblnr,
         gjahr,
         bukrs,
         _ADV_HEAD
}
