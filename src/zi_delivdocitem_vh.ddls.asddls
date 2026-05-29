@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivery Item VH - SDProcessStatus C'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }
@Search.searchable: true

define view entity ZI_DelivDocItem_VH
  as select from I_DeliveryDocumentItem as a
  inner join I_DeliveryDocument  as c on c.DeliveryDocument = a.DeliveryDocument
  inner join I_ProductDescription  as b on b.Product = a.Product
                                        and b.Language = 'E'
  left outer join ztgate_item_s as gate on  gate.outbounddelivery     = a.DeliveryDocument
                                        and gate.outbounddeliveryitem = a.DeliveryDocumentItem                                                  
{

  @Search.defaultSearchElement: true 
  @Consumption.filter.multipleSelections: true  
  key a.DeliveryDocument,
  @Consumption.filter.multipleSelections: true
  key a.DeliveryDocumentItem,
  a.Product,
  b.ProductDescription,
  a.Batch,
  @Search.defaultSearchElement: true
  a.Plant,
  cast( case c.DeliveryDocumentType
          when 'LR' then 'true'
          else 'false'
        end as abap.char(5) ) as Chk1
  
}
where
  a.SDProcessStatus = 'C'
  and gate.outbounddelivery is null
//  and c.DeliveryDocumentType = 'LF'
  
