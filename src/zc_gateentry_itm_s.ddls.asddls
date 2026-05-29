@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'gate out item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZC_GATEENTRY_ITM_S
  as projection on ZI_GATEENTRY_ITM_S
{
  key zid,
  key Outbounddelivery,
  key Outbounddeliveryitem,
      zgate,  
      Product,
      Productdescription,
      Batch,
      Storagelocation,
      Soldtoparty,
      Customerdescription,
      Baseunit,
      Actualdeliveryquantity,
      Remark,

      _ADV_HEAD1 : redirected to parent ZC_GATEENTRY_hdr_S

}
