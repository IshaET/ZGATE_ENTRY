@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGP/NRGP ITEM TABLE'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_GATEENTRY_itm_R 
as select from ztgate_item_r
association to parent ZI_GATEENTRY_hdr_R as _ADV_HEADr on $projection.zid = _ADV_HEADr.zid
//composition of target_data_source_name as _association_name
{   
    key ztgate_item_r.zid,
    key ztgate_item_r.challan_no as ChallanNo,
    key ztgate_item_r.posnr,
    
    key ztgate_item_r.mblnr as Mblnr,
    key ztgate_item_r.zeile as Zeile,
    ztgate_item_r.zgate as Zgate,
    
    
    ztgate_item_r.matnr as Matnr,
    ztgate_item_r.maktx as Maktx,
    ztgate_item_r.charg as Charg,
    ztgate_item_r.werks as Werks,
    ztgate_item_r.quantity as Quantity,
    ztgate_item_r.uom as Uom,
    ztgate_item_r.value as Value,
    ztgate_item_r.return_date as ReturnDate,
    ztgate_item_r.return_qty as ReturnQty,
    ztgate_item_r.balance_qty as BalanceQty,
    ztgate_item_r.remarks as Remarks,
    ztgate_item_r.created_by as CreatedBy,
    ztgate_item_r.created_on as CreatedOn,
    ztgate_item_r.last_changed_by as LastChangedBy,
    ztgate_item_r.last_changed_on as LastChangedOn,
    _ADV_HEADr
   
}
