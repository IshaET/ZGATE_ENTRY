@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'gate out header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_GATEENTRY_HDR_S
  as select from ztgate_hdr_s
  composition [0..*] of ZI_GATEENTRY_ITM_S as _ADV_item1
  association [0..1] to ZC_IMAGE_VIEW      as _Image on _Image.Text = 'GATE'
  association [0..1] to I_Plant          as _Plant on $projection.Plant = _Plant.Plant
  //composition of target_data_source_name as _association_name
{
  key zid,
      zgate      as Zgate,
      plant      as Plant,
      gateindt   as Gateindt,
      gateinout  as Gateinout,
      gateoutdt  as Gateoutdt,
      gateoutout as Gateoutout,
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
      chk1        as Chk1,
      trans,
      created_by,
      _Image,
      _Plant,
      _ADV_item1
      //    _association_name // Make association public
}
