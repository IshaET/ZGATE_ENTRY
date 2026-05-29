@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Transporters (ZSER)'
define view entity ZI_Transporter_VH 
  as select from I_Supplier 
{
  key Supplier,
      SupplierName,
      SupplierAccountGroup,
      BusinessPartnerName1
}
where SupplierAccountGroup = 'ZSER'
