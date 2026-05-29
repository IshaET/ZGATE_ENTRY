@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGP/NRGP'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_GATEENTRY_hdr_R 
as select from ztgate_hdr_r
 association [0..1] to ZC_IMAGE_VIEW    as _Image on _Image.Text = 'GATE'
// $projection.Plant = '1004'
 composition [0..*] of ZI_GATEENTRY_itm_R as _ADV_itemR
 association [0..1] to I_Plant          as _Plant on $projection.Plant = _Plant.Plant
{
    key zid,
    zgate as Zgate,
    plant as Plant,
    gateindt as Gateindt,
    gateinout as Gateinout,
    gateoutdt as Gateoutdt,
    gateoutout as Gateoutout,
    vehno as Vehno,
    oname as Oname,
    drvlicen as Drvlicen,
    remark as Remark,
    bill as Bill,
    tare as Tare,
    gross as Gross,
    net as Net,
    pack as Pack,
    chk as Chk,
    trans,
    created_by as CreatedBy,
    gjahr as Gjahr,
    bukrs as Bukrs,
         @Consumption.valueHelpDefinition: [{         entity: { name: 'ZI_STATUS_R', element: 'StatusID' }     }]   
    @ObjectModel.text.element: ['Type'] // Shows "Active" instead of "A"     StatusField,
    type as Type,
    
    _Image,
    _Plant,
    _ADV_itemR
//    _association_name // Make association public
}
