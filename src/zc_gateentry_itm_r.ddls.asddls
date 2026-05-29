@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGP/NRGP consumption view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_GATEENTRY_itm_R 
as projection on ZI_GATEENTRY_itm_R
{   
    key zid,
   @EndUserText.label: 'Challan No'
    key ChallanNo,
   @EndUserText.label: 'Challan Item' 
    key posnr,
    key Mblnr,
     key Zeile,
    Zgate,
    
    
    Matnr,
    Maktx,
    Charg,
    Werks,
    Quantity,
    Uom,
    Value,
    ReturnDate,
    ReturnQty,
    BalanceQty,
    Remarks,
    CreatedBy,
    CreatedOn,
    LastChangedBy,
    LastChangedOn,

    /* Associations */
    _ADV_HEADr : redirected to parent ZC_GATEENTRY_hdr_R
    
//    _association_name // Make association public
}
