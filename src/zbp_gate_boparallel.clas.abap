CLASS zbp_gate_boparallel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES tt_result TYPE STANDARD TABLE OF ztgate_hdr WITH EMPTY KEY.
    TYPES tt_result1 TYPE STANDARD TABLE OF ztgate_item WITH EMPTY KEY.
    DATA: it_po_final  TYPE  tt_result,
          it_po_final1 TYPE  tt_result,
          it_po_final2  TYPE  tt_result1,
          it_po_final3  TYPE  tt_result1,
          it_po_final4  TYPE  tt_result1.
    INTERFACES if_serializable_object .
    INTERFACES if_abap_parallel .

    METHODS constructor
      IMPORTING
        lt_po_details TYPE tt_result
        lt_po_details1 TYPE tt_result1
        lt_po TYPE tt_result1.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZBP_GATE_BOPARALLEL IMPLEMENTATION.


    METHOD constructor.
    it_po_final = lt_po_details .
    it_po_final1 = lt_po_details.
    it_po_final2 = lt_po_details1.
    it_po_final4 = lt_po.
*    it_po_final2
  ENDMETHOD.


   METHOD if_abap_parallel~do.

      " 3. Map to GRN Structure
    DATA: it_grn TYPE TABLE FOR CREATE i_materialdocumenttp\_materialdocumentitem.
*    SELECT SINGLE STORAGELOCATION
*            from I_PURCHASEORDERITEMAPI01
*            WHERE PurchaseOrder = @item-Ebeln
*              and PurchaseOrderItem = @item-Ebelp
*              into @data(lv_s).

    DATA(ls_header) = it_po_final[ 1 ].
    DATA(lv_plant) = ls_header-plant.

     " Determine the number of line items. If you already have lt_unique_pos,
    " you can use lines( lt_unique_pos ) instead.
    DATA(lv_item_count) = lines( it_po_final4 ).

    APPEND VALUE #(
      %cid_ref = 'CID_001'
      %target  = VALUE #( FOR item IN it_po_final2 (
                   %cid                = |CID_ITM_{ item-ebeln }_{ item-ebelp }|
                   material            = item-mat
                   plant               = lv_plant
                   storagelocation     = item-storage
                   goodsmovementtype   = '101'
                   " --- UPDATED LOGIC HERE ---
                   " If 2 or more line items are present, use item-receivedqty.
                   " If 1 PO/item is present, use ls_header-net.
                   quantityinentryunit = COND #( WHEN lv_item_count > 1
                                                 THEN item-qty
                                                 ELSE ls_header-net )
*                   quantityinentryunit = ls_header-Net "item-receivedqty
                   entryunit           = item-uom
                   purchaseorder       = item-ebeln
                   purchaseorderitem   = item-ebelp
                   goodsmovementrefdoctype  = 'B'
                   %control            = VALUE #(
                                           material            = if_abap_behv=>mk-on
                                           plant               = if_abap_behv=>mk-on
                                           storagelocation     = if_abap_behv=>mk-on
                                           goodsmovementtype   = if_abap_behv=>mk-on
                                           quantityinentryunit = if_abap_behv=>mk-on
                                           entryunit           = if_abap_behv=>mk-on
                                           purchaseorder       = if_abap_behv=>mk-on
                                           purchaseorderitem   = if_abap_behv=>mk-on
                                           goodsmovementrefdoctype = if_abap_behv=>mk-on
                                         )
                 ) )
    ) TO it_grn.

    " 4. Post GRN (User Logic)
    MODIFY ENTITIES OF i_materialdocumenttp
       ENTITY materialdocument
       CREATE FROM VALUE #( ( %cid = 'CID_001'
       goodsmovementcode          = '01'
       postingdate                = cl_abap_context_info=>get_system_date( )
       documentdate               = cl_abap_context_info=>get_system_date( )
       %control-goodsmovementcode = cl_abap_behv=>flag_changed
       %control-postingdate       = cl_abap_behv=>flag_changed
       %control-documentdate      = cl_abap_behv=>flag_changed
       ) )

         ENTITY materialdocument
         CREATE BY \_materialdocumentitem
         FROM it_grn
         MAPPED DATA(ls_create_mapped)
         FAILED DATA(ls_create_failed)
         REPORTED DATA(ls_create_reported).

*    COMMIT ENTITIES.
    COMMIT ENTITIES BEGIN
        RESPONSE OF i_materialdocumenttp
        FAILED DATA(lt_commit_failed)
        REPORTED DATA(lt_commit_reported).
*    DATA(ls_key) = keys[ 1 ].

    DATA(lv_mblnr) = VALUE #( lt_commit_reported-materialdocumentitem[ 1 ]-materialdocument OPTIONAL ).
    DATA(lv_gjahr) = VALUE #( lt_commit_reported-materialdocumentitem[ 1 ]-materialdocumentyear OPTIONAL ).

    IF lt_commit_failed IS NOT INITIAL.
    DATA(lv_error_summary) = VALUE string( ).
    endif.

     LOOP AT lt_commit_reported-materialdocumentitem INTO DATA(ls_rep_item).

        DATA(lv_text) = ls_rep_item-%msg->if_message~get_text( ).
*        lv_error_summary = |{ lv_error_summary } { ls_rep_item-%msg->get_text( ) } |.
    ENDLOOP.
     if lv_text is initial.
     LOOP AT lt_commit_reported-materialdocument INTO DATA(ls_rep_item1).

        lv_text = ls_rep_item1-%msg->if_message~get_text( ).
*        lv_error_summary = |{ lv_error_summary } { ls_rep_item-%msg->get_text( ) } |.
    ENDLOOP.
    endif.

    daTA : wa_log tYPE ztgate_in_log.
    loop AT it_po_final  ASSIGNING FIELD-SYMBOL(<fs_data>).
     wa_log-zgate = <fs_data>-zgate.
     wa_log-mblnr =   lv_mblnr.
     wa_log-gjahr =  lv_gjahr.
    <fs_data>-mblnr = lv_mblnr.
    <fs_data>-gjahr = lv_gjahr.
    wa_log-mess = lv_text.
    modiFY ztgate_in_log fROM @wa_log.
    endLOOP.
*    IF lv_mblnr IS NOT INITIAL.
*      MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
*        ENTITY hdr
*          UPDATE FIELDS ( mblnr gjahr )
*          WITH VALUE #( ( "zid = ls_key-zid "zgate
*                          mblnr = lv_mblnr
*                          gjahr = lv_gjahr ) ).
*    ENDIF.
    "retrieve the generated

*    ls_create_mapped-materialdocument = lv_mblnr.
*    zbp_i_gateentry_hdr=>mapped_material_document-materialdocument = lt_commit_reported-materialdocument.
    commit enTITIES END.


   enDMETHOD.
ENDCLASS.
