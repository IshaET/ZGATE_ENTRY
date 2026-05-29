@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true

define view entity ZC_GATEENTRY_ITM
  as projection on ZI_GATEENTRY_ITM
{
  key    zid, 
  key    Ebeln,
  key    Ebelp, 
      Zgate,
         Vend,
         Name,
         Mat,
         Matdesc,
         storage,
         OrderQty,
         ReceivedQty,
         Uom,
         qty,
         BillNo,
         Remark,
         mblnr,
         gjahr,
         bukrs,   
         _ADV_HEAD : redirected to parent ZC_GATEENTRY_hdr

}
