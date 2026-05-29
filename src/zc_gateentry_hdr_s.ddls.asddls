@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'gate out header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_GATEENTRY_hdr_S
  provider contract transactional_query
  as projection on ZI_GATEENTRY_HDR_S
{
      //  @Search.defaultSearchElement: true
      //   @UI.lineItem: [ { position: 10 },
      //                  { type: #FOR_ACTION, dataAction: 'CreateGrn', label: 'Post GRN' } ]
      //  @UI.identification: [ { position: 10 },
      //                        { type: #FOR_ACTION, dataAction: 'CreateGrn', label: 'Post GRN' } ]
    
  key zid,
  @EndUserText.label: 'Gate Entry No' 
  Zgate,
   @EndUserText.label: 'Plant'
  @ObjectModel.text.element: ['PlantName']
      Plant,
  @EndUserText.label: 'Plant Name'
      
      _Plant.PlantName as PlantName,   
//  @EndUserText.label: 'Plant'
//      Plant,
  @EndUserText.label: 'Gate in Date'    
      Gateindt,
  @EndUserText.label: 'Gate in time'    
      Gateinout,
  @EndUserText.label: 'Gate out Date'    
      Gateoutdt,
  @EndUserText.label: 'Gate out time'    
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
      Chk1,
      trans,
      _Image.PicUrl,
      _ADV_item1 : redirected to composition child ZC_GATEENTRY_ITM_S,
      _Image
      // Make association public
}
