//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'RGP/NRGP'
//@Metadata.ignorePropagatedAnnotations: true
//define view entity ZI_STATUS_r 
//as select from zdb_status
//{
//    key id as Id,
//    name as Name
//}
////as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZSTATUS_R')
////{
////  key domain_name,
////  key value_position,
////  key language,
////    @UI.textArrangement: #TEXT_ONLY
////    @UI.lineItem: [{importance: #HIGH  }]
////  
////      value_low,
////      text
////      
//}

@AbapCatalog.viewEnhancementCategory: [#NONE]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Value Help for Status'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.resultSet.sizeCategory: #XS   // Tells UI it's a small list (Dropdown)
 
define view entity ZI_STATUS_R 
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZSTATUS_R' )
  // Dummy selection, or use separate logic below

{

  key   value_low  as StatusID,

      text   as StatusText

}

where domain_name = 'ZSTATUS_R' // If using a released domain view
 