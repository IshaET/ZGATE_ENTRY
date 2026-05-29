@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Material Document based on Gate Type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_VH_MATDOC_GATE 
  as select from I_MaterialDocumentItem_2 
{
  key MaterialDocument,
  key MaterialDocumentYear,
  key MaterialDocumentItem,
      Material,
      Plant,
      GoodsMovementType,
      @UI.lineItem: [{ position: 70, label: 'Gate Type' }]
      /* Map the Movement Types to 'RGP' or 'NRGP' */
      case 
        when GoodsMovementType = '541' or GoodsMovementType = '631' 
          then cast('RGP' as abap.char(4))
          
        when GoodsMovementType = '201' or GoodsMovementType = '601' or 
             GoodsMovementType = '122' or GoodsMovementType = '161' or 
             GoodsMovementType = '301' or GoodsMovementType = '311' or 
             GoodsMovementType = '303' 
          then cast('NRGP' as abap.char(4))
          
        else cast('OTHER' as abap.char(4))
      end as Type
//      case 
//        when GoodsMovementType = '541' or GoodsMovementType = '631' then cast('RGP' as abap.char(4))
//        /* Add your logic for NRGP movement types here if needed, for example: */
//        /* when GoodsMovementType = '101' then cast('NRGP' as abap.char(4)) */
//        else cast('OTHER' as abap.char(4))
//      end as Type
}
// Optional: You can add a WHERE clause here to only fetch relevant movement types 
// to improve performance.
// where GoodsMovementType = '541' or GoodsMovementType = '631' ...
