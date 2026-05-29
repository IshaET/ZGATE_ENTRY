@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Item VH - IMPM/TMPM/RMPM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }
@Search.searchable: true

define view entity ZI_PurOrdItem_VH
  as select from I_PurchaseOrderAPI01 as Header
    inner join I_PurchaseOrderItemAPI01 as Item
      on Header.PurchaseOrder = Item.PurchaseOrder
    left outer join I_PurchaseOrderHistoryAPI01 as i1
      on  i1.PurchaseOrder     = Item.PurchaseOrder 
      and i1.PurchaseOrderItem = Item.PurchaseOrderItem
{
  key Header.PurchaseOrder,
  key Item.PurchaseOrderItem,

  @Search.defaultSearchElement: true
  Item.Plant,
  Item.Material,
  Item.StorageLocation,

  Item.PurchaseOrderQuantityUnit,

  @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'   
  Item.OrderQuantity,

  @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
  cast(
    sum(
        case
            when i1.GoodsMovementType = '101'
                then i1.Quantity

            when i1.GoodsMovementType = '102'
                then - i1.Quantity

            else 0
        end
    )
    as abap.quan( 13, 3 )
) as TotalQuantity
 
//  sum( i1.Quantity ) as TotalQuantity
  
//  @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
//sum(
//    case
//        when i1.Quantity < 0
//             then i1.Quantity
//        else i1.Quantity
//    end
//) as TotalQuantity
  

}
where 
//(
////     Header.PurchaseOrderType = 'IMPM'
////  or Header.PurchaseOrderType = 'TMPM'
////  or Header.PurchaseOrderType = 'RMPM'
//)
//and
 Item.IsCompletelyDelivered <> 'X'

group by
  Header.PurchaseOrder,
  Item.PurchaseOrderItem,
  Item.Plant,
  Item.Material,
  Item.StorageLocation,
  Item.PurchaseOrderQuantityUnit,
  Item.OrderQuantity
//define view entity ZI_PurOrdItem_VH
//  as select from I_PurchaseOrderAPI01 as Header
//    inner join I_PurchaseOrderItemAPI01 as Item
//      on  Header.PurchaseOrder = Item.PurchaseOrder
//    left outer join I_PurchaseOrderHistoryAPI01 as i1
//      on  i1.PurchaseOrder = Item.PurchaseOrder 
//      and i1.PurchaseOrderItem = Item.PurchaseOrderItem
//{
//  key Header.PurchaseOrder,
//  key Item.PurchaseOrderItem,
//  @Search.defaultSearchElement: true
//   Item.Plant,
//   Item.Material,
//   Item.StorageLocation,
//   Item.PurchaseOrderQuantityUnit,
//   @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'   
//   Item.OrderQuantity,
//   @Semantics.quantity.unitOfMeasure:'PurchaseOrderQuantityUnit'
//   i1.Quantity
//}
//where 
//( Header.PurchaseOrderType = 'IMPM'
//or Header.PurchaseOrderType = 'TMPM'
//or Header.PurchaseOrderType = 'RMPM' )
//and Item.IsCompletelyDelivered <> 'X'
