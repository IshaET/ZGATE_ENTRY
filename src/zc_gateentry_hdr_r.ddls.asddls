@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_GATEENTRY_hdr_R 
 provider contract transactional_query
  as projection on ZI_GATEENTRY_hdr_R
{   

     key zid,
     Zgate,
//    Plant,
     @EndUserText.label: 'Plant'
  @ObjectModel.text.element: ['PlantName']
      Plant,
  @EndUserText.label: 'Plant Name'
      
      _Plant.PlantName as PlantName,   
    Gateindt,
    Gateinout,
    Gateoutdt,
    Gateoutout,
    Vehno,
    Oname,
    Drvlicen,
    Remark,
    Bill,
    Tare,
    Gross,
    Net,
    Pack,
    Chk,
    trans,
    CreatedBy,
    Gjahr,
    Bukrs,
    @Consumption.valueHelpDefinition: [{         entity: { name: 'ZI_STATUS_R', element: 'StatusID' }     }]   
    @ObjectModel.text.element: ['Type'] // Shows "Active" instead of "A"     StatusField,
    Type,

//    GateType,
    _Image.PicUrl,
    _Image,
    _ADV_itemR : redirected to composition child ZC_GATEENTRY_itm_R
//    _association_name // Make association public
}
