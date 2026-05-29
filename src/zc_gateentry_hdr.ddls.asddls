@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate entry consumption'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_GATEENTRY_hdr
  provider contract transactional_query
  as projection on ZI_GATEENTRY_hdr
{
      //  @Search.defaultSearchElement: true
      //   @UI.lineItem: [ { position: 10 },
      //                  { type: #FOR_ACTION, dataAction: 'CreateGrn', label: 'Post GRN' } ]
      //  @UI.identification: [ { position: 10 },
      //                        { type: #FOR_ACTION, dataAction: 'CreateGrn', label: 'Post GRN' } ]
  key zid,    
  @EndUserText.label: 'Gate Entry No'    
   Zgate,
//  @EndUserText.label: 'Plant'
   @EndUserText.label: 'Plant'
  @ObjectModel.text.element: ['PlantName']
      Plant,
  @EndUserText.label: 'Plant Name'
      
      _Plant.PlantName as PlantName,    
//      Plant,
  @EndUserText.label: 'Gate in Date'    
      Gateindt,
  @EndUserText.label: 'Gate in time'    
      Gateinout,
  @EndUserText.label: 'Gate out Date'    
      Gateoutdt,
  @EndUserText.label: 'Gate out time' 
//  @Semantics.time: true         
//      gateoutout_display,  
//      Gateoutout_txt,  
//      Gateoutout_txt,
      Gateoutout,
      Vehno,
      Oname,
      Drvlicen,
      Remark,
      Bill,
      Tare,
      Gross,
      Net,
      pack,
      Chk,
      mblnr,
      gjahr,
      bukrs,
      trans,
      base64,
      IsGateOutHidden,
      _Image.PicUrl,
      _ADV_item : redirected to composition child ZC_GATEENTRY_ITM,
      _Image
      // Make association public
}
