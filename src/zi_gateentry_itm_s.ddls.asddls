@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'gate out item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_GATEENTRY_ITM_S 
as select from ztgate_item_s
 association to parent ZI_GATEENTRY_HDR_S as _ADV_HEAD1 on $projection.zid = _ADV_HEAD1.zid
{
    key zid,    
    key outbounddelivery as Outbounddelivery,
    key outbounddeliveryitem as Outbounddeliveryitem,
    zgate as zgate,
    product as Product,
    productdescription as Productdescription,
    batch as Batch,
    storagelocation as Storagelocation,
    soldtoparty as Soldtoparty,
    customerdescription as Customerdescription,
    baseunit as Baseunit,
    actualdeliveryquantity as Actualdeliveryquantity,
    remark as Remark,
    _ADV_HEAD1
}
