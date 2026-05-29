@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate entry header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_GATEENTRY_hdr
  as select from ztgate_hdr
  composition [0..*] of ZI_GATEENTRY_ITM as _ADV_item
  association [0..1] to ZC_IMAGE_VIEW    as _Image on _Image.Text = 'GATE'
  association [0..1] to I_Plant          as _Plant on $projection.Plant = _Plant.Plant
//  on $projection.Plant = '1004'
  //composition of target_data_source_name as _association_name
{
  key zid,
      zgate      as Zgate,
      plant      as Plant,
      gateindt   as Gateindt,
      gateinout  as Gateinout,
      gateoutdt  as Gateoutdt,
//      case 
// when gateoutout = '000000' or gateoutout is initial
// then ''
// else concat(
//        concat(
//          concat(substring(gateoutout,1,2),
//          concat(substring(gateoutout,3,2))
//        ),
//        substring(gateoutout,5,2)
//      )
//end as gateoutout,
//      case 
//  when gateoutout = '000000' or gateoutout is initial
//  then ''
//
//  when substring(gateoutout,1,2) < '12'
//  then concat(
//         concat(
//           concat(substring(gateoutout,1,2), ':'),
//           concat(substring(gateoutout,3,2), ':')
//         ),
//         concat(substring(gateoutout,5,2), ' AM')
//       )
//
//  else
//  concat(
//         concat(
//           concat(substring(gateoutout,1,2), ':'),
//           concat(substring(gateoutout,3,2), ':')
//         ),
//         concat(substring(gateoutout,5,2), ' PM')
//       )
//
//end as gateoutout,
//end as gateoutout,
//      case when gateinout = '000000' or gateinout is initial then ''
//           else concat(substring(gateinout,1,2), 
//                concat(':', 
//                concat(substring(gateinout,3,2), 
//                concat(':', substring(gateinout,5,2))))) 
//      end as Gateinout_txt,
//      case when gateoutout = '000000' or gateoutout is initial then ''
//           else concat(substring(gateoutout,1,2), 
//                concat(':', 
//                concat(substring(gateoutout,3,2), 
//                concat(':', substring(gateoutout,5,2))))) 
//      end as Gateoutout_txt,  
      gateoutout as Gateoutout,
//      case 
//  when gateoutout = '000000' or gateoutout is initial
//  then ''
//  else gateoutout
//end as gateoutout_display,
      vehno      as Vehno,
      oname      as Oname,
      drvlicen   as Drvlicen,
      remark     as Remark,
      bill       as Bill,
      tare       as Tare,
      gross      as Gross,
      net        as Net,
      pack       as pack,
      chk        as Chk,
      mblnr      as mblnr,
      gjahr      as gjahr,
      bukrs      as bukrs,
      trans,
      base64,
      created_by,
      case when gateoutdt is initial then 'X'
       else ' '
      end        as IsGateOutHidden,
      _ADV_item,
      _Image,
      _Plant
      
      //    _association_name // Make association public
}
