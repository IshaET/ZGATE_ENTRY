CLASS lhc_zi_gateentry_itm_s DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS CalculateItemDetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZI_GATEENTRY_ITM_S~CalculateItemDetails.
    METHODS ValidateGateItem FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZI_GATEENTRY_ITM_S~ValidateGateItem.

ENDCLASS.

CLASS lhc_zi_gateentry_itm_s IMPLEMENTATION.

  METHOD CalculateItemDetails.

      READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
      ENTITY zi_gateentry_hdr_s
        FIELDS ( zgate Gross Tare pack ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).
    READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
      ENTITY zi_gateentry_itm_s
        FIELDS ( Outbounddelivery Outbounddeliveryitem ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).
    CHECK lt_items IS NOT INITIAL AND lt_headers IS NOT INITIAL.
    READ TABLE lt_headers INTO DATA(wa_hdr) INDEX 1.
    LOOP AT lt_items INTO DATA(ls_item).
      IF ls_item-Outbounddelivery IS NOT INITIAL AND ls_item-Outbounddeliveryitem IS NOT INITIAL.
        DATA(lv_delivery) = |{ ls_item-Outbounddelivery ALPHA = IN }|.
        " Existing Details Update Logic
        SELECT SINGLE * FROM I_OUTBOUNDDELIVERYITEM WITH PRIVILEGED ACCESS
                WHERE OutboundDelivery = @lv_delivery
                  AND OutboundDeliveryItem = @ls_item-Outbounddeliveryitem
                  INTO @DATA(wa_delv1).
        SELECT SINGLE * FROM I_DeliveryDocument WITH PRIVILEGED ACCESS
               WHERE DeliveryDocument =  @lv_delivery
               INTO @DATA(wa_delv).
        SELECT SINGLE FROM I_PurchaseOrderItemAPI01
          FIELDS Material, PurchaseOrderItemText
          WHERE Material = @wa_delv1-Product
          INTO @DATA(ls_po_data).
        SELECT SINGLE FROM I_Customer
          FIELDS CustomerFullName
          WHERE Customer = @wa_delv-ShipToParty
          INTO @DATA(lv_sold).
        MODIFY ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
            ENTITY zi_gateentry_itm_s
              UPDATE FIELDS ( zgate Product Productdescription Batch Storagelocation Soldtoparty Customerdescription Baseunit Actualdeliveryquantity )
              WITH VALUE #( ( %tky = ls_item-%tky
                              zgate = wa_hdr-Zgate
                              Product = wa_delv1-Product
                              Productdescription = ls_po_data-PurchaseOrderItemText
                              Batch = wa_delv1-batch
                              Storagelocation = wa_delv1-StorageLocation
                              Soldtoparty = wa_delv-SoldToParty
                              Customerdescription = lv_sold
                              Baseunit = wa_delv1-BaseUnit
                              Actualdeliveryquantity = wa_delv1-ActualDeliveryQuantity
                           ) ).
      ENDIF.
    ENDLOOP.
**     READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
**      ENTITY zi_gateentry_hdr_s
**        FIELDS ( zgate Gross Tare pack )
**        WITH CORRESPONDING #( keys )
**      RESULT DATA(lt_headers).
**    READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
**      ENTITY zi_gateentry_itm_s
**        FIELDS ( Outbounddelivery Outbounddeliveryitem )
**        WITH CORRESPONDING #( keys )
**      RESULT DATA(lt_items).
**    READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
**      ENTITY zi_gateentry_hdr_s BY \_ADV_item1
**        FIELDS ( Outbounddelivery Outbounddeliveryitem )
**        WITH CORRESPONDING #( lt_headers )
**      RESULT DATA(lt_all_items).
**    READ TABLE lt_headers INTO DATA(wa_hdr) INDEX 1.
**    CHECK lt_items IS NOT INITIAL.
**
**    DATA lv_delivery TYPE vbeln_vl.
**    DATA lv_other_delivery TYPE vbeln_vl.
**    DATA lv_error_mixed TYPE abap_bool.
**    DATA lv_other_type TYPE string.
**    LOOP AT lt_items INTO DATA(ls_item).
**      IF ls_item-Outbounddelivery IS NOT INITIAL AND ls_item-Outbounddeliveryitem IS NOT INITIAL.
**        lv_delivery = ls_item-Outbounddelivery.
**        lv_delivery = |{ lv_delivery ALPHA = IN }|.
**
**        SELECT SINGLE *
**               FROM I_DeliveryDocument
**               WHERE DeliveryDocument =  @lv_delivery
**               INTO @DATA(wa_delv2).
**        " ------------------------------------------------------------------------
**        " NEW VALIDATION: Prevent mixing LF and LR Document Types
**        " ------------------------------------------------------------------------
**        IF sy-subrc = 0 AND ( wa_delv2-DeliveryDocumentType = 'LF' OR wa_delv2-DeliveryDocumentType = 'LR' ).
**          lv_error_mixed = abap_false.
**          " FIX: We loop over lt_all_items to check all lines in the document
**          LOOP AT lt_all_items INTO DATA(ls_other_item) WHERE zid = ls_item-zid AND Outbounddelivery IS NOT INITIAL AND %tky <> ls_item-%tky.
**            lv_other_delivery = ls_other_item-Outbounddelivery.
**            lv_other_delivery = |{ lv_other_delivery ALPHA = IN }|.
**            CLEAR lv_other_type.
**            SELECT SINGLE DeliveryDocumentType FROM I_DeliveryDocument WHERE DeliveryDocument = @lv_other_delivery INTO @lv_other_type.
**            IF sy-subrc = 0.
**               IF ( wa_delv2-DeliveryDocumentType = 'LF' AND lv_other_type = 'LR' ) OR
**                  ( wa_delv2-DeliveryDocumentType = 'LR' AND lv_other_type = 'LF' ).
**                 lv_error_mixed = abap_true.
**                 EXIT.
**               ENDIF.
**            ENDIF.
**          ENDLOOP.
**          IF lv_error_mixed = abap_true.
**             APPEND VALUE #( %tky = ls_item-%tky
**                             %msg = new_message_with_text(
**                                      severity = if_abap_behv_message=>severity-error
**                                      text     = 'Cannot mix LF and LR Delivery Document Types in the same gate entry.' )
**                             %element-outbounddelivery     = if_abap_behv=>mk-on
**                           ) TO reported-zi_gateentry_itm_s.
**             CONTINUE. " Skip remaining logic for this failed item
**          ENDIF.
**        ENDIF.
**        " Existing Quantity Check
**        SELECT SINGLE ActualDeliveryQuantity
**                 FROM I_DeliveryDocumentItem
**                 WHERE DeliveryDocument     = @lv_delivery
**                   AND DeliveryDocumentItem = @ls_item-Outbounddeliveryitem
**                 INTO @DATA(lv_actual_qty).
**        IF sy-subrc = 0 AND lv_actual_qty = 0.
**          APPEND VALUE #( %tky = ls_item-%tky
**                          %msg = new_message_with_text(
**                                   severity = if_abap_behv_message=>severity-error
**                                   text     = 'Actual Delivery Quantity is 0.000 for this item.' )
**                          %element-outbounddelivery     = if_abap_behv=>mk-on
**                          %element-outbounddeliveryitem = if_abap_behv=>mk-on
**                        ) TO reported-zi_gateentry_itm_s.
**          CONTINUE.
**        ENDIF.
**        " Existing Details Update Logic
**        SELECT SINGLE *
**                FROM I_OUTBOUNDDELIVERYITEM
**                WHERE OutboundDelivery = @lv_delivery
**                  AND OutboundDeliveryItem = @ls_item-Outbounddeliveryitem
**                  INTO @DATA(wa_delv1).
**
**        SELECT SINGLE *
**               FROM I_DeliveryDocument
**               WHERE DeliveryDocument =  @lv_delivery
**               INTO @DATA(wa_delv).
**        SELECT SINGLE FROM I_PurchaseOrderItemAPI01
**          FIELDS Material, PurchaseOrderItemText
**          WHERE Material = @wa_delv1-Product
**          INTO @DATA(ls_po_data).
**        SELECT SINGLE FROM I_Customer
**          FIELDS CustomerFullName
**          WHERE Customer = @wa_delv-ShipToParty
**          INTO @DATA(lv_sold).
**        MODIFY ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
**            ENTITY zi_gateentry_itm_s
**              UPDATE FIELDS ( zgate Product Productdescription Batch Storagelocation Soldtoparty Customerdescription Baseunit Actualdeliveryquantity )
**              WITH VALUE #( ( %tky = ls_item-%tky
**                              zgate = wa_hdr-Zgate
**                              Product = wa_delv1-Product
**                              Productdescription = ls_po_data-PurchaseOrderItemText
**                              Batch = wa_delv1-batch
**                              Storagelocation = wa_delv1-StorageLocation
**                              Soldtoparty = wa_delv-SoldToParty
**                              Customerdescription = lv_sold
**                              Baseunit = wa_delv1-BaseUnit
**                              Actualdeliveryquantity = wa_delv1-ActualDeliveryQuantity
**                           ) ).
**      ENDIF.
**    ENDLOOP.

*     READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
*      ENTITY zi_gateentry_hdr_s
*        FIELDS ( zgate Gross Tare pack )
*        WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_headers).
*
*    READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
*      ENTITY zi_gateentry_itm_s
*        FIELDS ( Outbounddelivery Outbounddeliveryitem )
*        WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_items).
*
*    READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
*      ENTITY zi_gateentry_hdr_s BY \_ADV_item1
*        FIELDS ( Outbounddelivery Outbounddeliveryitem )
*        WITH CORRESPONDING #( lt_headers )
*      RESULT DATA(lt_all_items).
*
*    read table lt_headers into data(wa_hdr) index 1.
*
*     CHECK lt_items IS NOT INITIAL.
*    DATA lv_delivery TYPE vbeln_vl.
*    DATA lv_other_delivery TYPE vbeln_vl.
*    DATA lv_error_mixed TYPE abap_bool.
*    DATA lv_other_type TYPE string.
*    LOOP AT lt_items INTO DATA(ls_item).
*      if ls_item-Outbounddelivery is not INITIAL AND ls_item-Outbounddeliveryitem is NOT INITIAL.
*        lv_delivery = ls_item-Outbounddelivery.
*        lv_delivery = |{ lv_delivery ALPHA = IN }|.
*        SELECT SINGLE *
*               FROM I_DeliveryDocument
*               WHERE DeliveryDocument =  @lv_delivery
*               INTO @DATA(wa_delv2).
*
*        SELECT SINGLE ActualDeliveryQuantity
*                 FROM I_DeliveryDocumentItem
*                 WHERE DeliveryDocument     = @lv_delivery
*                   AND DeliveryDocumentItem = @ls_item-Outbounddeliveryitem
*                 INTO @DATA(lv_actual_qty).
*
*        IF sy-subrc = 0 AND lv_actual_qty = 0.
*          " Issue the error message.
*          " Note: Determinations do not have the 'failed' parameter implicitly.
*          " Appending the error to 'reported' will display it on the UI immediately.
*          APPEND VALUE #( %tky = ls_item-%tky
*                          %msg = new_message_with_text(
*                                   severity = if_abap_behv_message=>severity-error
*                                   text     = 'Actual Delivery Quantity is 0.000 for this item.' )
*                          " Highlight the fields on the UI that caused the error
*                          %element-outbounddelivery     = if_abap_behv=>mk-on
*                          %element-outbounddeliveryitem = if_abap_behv=>mk-on
*                        ) TO reported-zi_gateentry_itm_s.
*
*          " Skip the rest of the logic for this failed item
*          CONTINUE.
*        ENDIF.
*
*        SELECT SINGLE *
*                from I_OUTBOUNDDELIVERYITEM
*                WHERE OutboundDelivery = @lv_delivery
*                  and OutboundDeliveryItem = @ls_item-Outbounddeliveryitem
*                  INTO @DATA(wa_delv1).
*       SELECT SINGLE *
*               from I_DeliveryDocument
*               WHERE DeliveryDocument =  @lv_delivery
*               INTO @DATA(wa_delv).
*
*       SELECT SINGLE FROM I_PurchaseOrderItemAPI01
*          FIELDS Material, PurchaseOrderItemText
*          WHERE Material = @wa_delv1-Product
*          INTO @DATA(ls_po_data).
*
*       SELECT SINGLE from I_Customer
*        fields CustomerFullName
*        where Customer = @wa_delv-ShipToParty "SoldToParty
*        into @data(lv_sold).
*
*
*       MODIFY ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
*            ENTITY zi_gateentry_itm_s
*              UPDATE FIELDS ( zgate Product Productdescription Batch Storagelocation Soldtoparty Customerdescription Baseunit
*               Actualdeliveryquantity )
*              WITH VALUE #( ( %tky = ls_item-%tky
*                              zgate = wa_hdr-Zgate
*                              Product = wa_delv1-Product
*                              Productdescription = ls_po_data-PurchaseOrderItemText
*                              Batch = wa_delv1-batch
*                              Storagelocation = wa_delv1-StorageLocation
*                              Soldtoparty = wa_delv-SoldToParty
*                              Customerdescription = lv_sold
*                              Baseunit = wa_delv1-BaseUnit
*                              Actualdeliveryquantity = wa_delv1-ActualDeliveryQuantity
*
*                           ) ).
*
*
*
*      ENDIF.
*
*
*    ENDLOOP.
*
*    daTA(lt_all_items1) = lt_all_items.
*    loop AT lt_all_items1 iNTO dATA(wa_all_item1).
*    lv_delivery = wa_all_item1-Outbounddelivery.
*    lv_delivery = |{ lv_delivery ALPHA = IN }|.
*    SELECT SINGLE *
*               FROM I_DeliveryDocument
*               WHERE DeliveryDocument =  @lv_delivery
*               INTO @DATA(wa_delv3).
*
*        " ------------------------------------------------------------------------
*        " NEW VALIDATION: Prevent mixing LF and LR Document Types
*        " ------------------------------------------------------------------------
*        IF sy-subrc = 0 AND ( wa_delv3-DeliveryDocumentType = 'LF' OR wa_delv3-DeliveryDocumentType = 'LR' ).
*          lv_error_mixed = abap_false.
*
*          LOOP AT lt_all_items INTO DATA(ls_other_item) WHERE zid = ls_item-zid AND Outbounddelivery IS NOT INITIAL AND %tky <> ls_item-%tky.
*            lv_other_delivery = ls_other_item-Outbounddelivery.
*            lv_other_delivery = |{ lv_other_delivery ALPHA = IN }|.
*
*            CLEAR lv_other_type.
*            SELECT SINGLE DeliveryDocumentType FROM I_DeliveryDocument WHERE DeliveryDocument = @lv_other_delivery INTO @lv_other_type.
*            IF sy-subrc = 0.
*               IF ( wa_delv3-DeliveryDocumentType = 'LF' AND lv_other_type = 'LR' ) OR
*                  ( wa_delv3-DeliveryDocumentType = 'LR' AND lv_other_type = 'LF' ).
*                 lv_error_mixed = abap_true.
*                 EXIT.
*               ENDIF.
*            ENDIF.
*          ENDLOOP.
*
*          IF lv_error_mixed = abap_true.
*             APPEND VALUE #( %tky = ls_item-%tky
*                             %msg = new_message_with_text(
*                                      severity = if_abap_behv_message=>severity-error
*                                      text     = 'Cannot mix LF and LR Delivery Document Types in the same gate entry.' )
*                             %element-outbounddelivery     = if_abap_behv=>mk-on
*                           ) TO reported-zi_gateentry_itm_s.
*             CONTINUE.
*          ENDIF.
*        ENDIF.
*   endloop.
  ENDMETHOD.

  METHOD ValidateGateItem.


    READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
      ENTITY zi_gateentry_itm_s
        FIELDS ( Outbounddelivery Outbounddeliveryitem )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).
    READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
      ENTITY zi_gateentry_hdr_s BY \_ADV_item1
        FIELDS ( Outbounddelivery Outbounddeliveryitem )
        WITH CORRESPONDING #( lt_items )
      RESULT DATA(lt_all_items).
    DATA lv_delivery TYPE vbeln_vl.
    DATA lv_other_delivery TYPE vbeln_vl.
    DATA lv_error_mixed TYPE abap_bool.
    DATA lv_other_type TYPE string.
    LOOP AT lt_items INTO DATA(ls_item).

      " ------------------------------------------------------------------------
      " VALIDATION 1: Check for Blank Delivery or Item Number
      " ------------------------------------------------------------------------
      IF ls_item-Outbounddelivery IS INITIAL OR ls_item-Outbounddeliveryitem IS INITIAL.
        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-zi_gateentry_itm_s.
        APPEND VALUE #( %tky = ls_item-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Delivery Number and Line Item cannot be blank.' )
                        " Highlight exactly which field is blank on the UI
                        %element-outbounddelivery     = COND #( WHEN ls_item-outbounddelivery IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
                        %element-outbounddeliveryitem = COND #( WHEN ls_item-outbounddeliveryitem IS INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
                      ) TO reported-zi_gateentry_itm_s.
        CONTINUE. " Item is blank, do not run database queries below
      ENDIF.
      " If fields are not blank, prepare for database queries
      lv_delivery = |{ ls_item-Outbounddelivery ALPHA = IN }|.
      " ------------------------------------------------------------------------
      " VALIDATION 2: Check if Delivery and Item are already used
      " ------------------------------------------------------------------------
      SELECT SINGLE outbounddelivery
        FROM ztgate_item_s
        WHERE outbounddelivery     = @lv_delivery
          AND outbounddeliveryitem = @ls_item-outbounddeliveryitem
          AND zid                 <> @ls_item-zid
        INTO @DATA(lv_already_used).
      IF sy-subrc = 0.
        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-zi_gateentry_itm_s.
        APPEND VALUE #( %tky = ls_item-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'This Outbound Delivery and Item are already present in a Gate Entry.' )
                        %element-outbounddelivery     = if_abap_behv=>mk-on
                        %element-outbounddeliveryitem = if_abap_behv=>mk-on
                      ) TO reported-zi_gateentry_itm_s.
        CONTINUE.
      ENDIF.
      " ------------------------------------------------------------------------
      " VALIDATION 3: Prevent mixing LF and LR Document Types
      " ------------------------------------------------------------------------
*      SELECT SINGLE * FROM I_DeliveryDocument WITH PRIVILEGED ACCESS
*             WHERE DeliveryDocument =  @lv_delivery
*             INTO @DATA(wa_delv2).
*      IF sy-subrc = 0 AND ( wa_delv2-DeliveryDocumentType = 'LF' OR wa_delv2-DeliveryDocumentType = 'LR' ).
*        lv_error_mixed = abap_false.
*        LOOP AT lt_all_items INTO DATA(ls_other_item) WHERE zid = ls_item-zid AND Outbounddelivery IS NOT INITIAL AND %tky <> ls_item-%tky.
*          lv_other_delivery = |{ ls_other_item-Outbounddelivery ALPHA = IN }|.
*          CLEAR lv_other_type.
*          SELECT SINGLE DeliveryDocumentType
*          FROM I_DeliveryDocument WITH PRIVILEGED ACCESS WHERE DeliveryDocument = @lv_other_delivery INTO @lv_other_type.
*          IF sy-subrc = 0.
*             IF ( wa_delv2-DeliveryDocumentType = 'LF' AND lv_other_type = 'LR' ) OR
*                ( wa_delv2-DeliveryDocumentType = 'LR' AND lv_other_type = 'LF' ).
*               lv_error_mixed = abap_true.
*               EXIT.
*             ENDIF.
*          ENDIF.
*        ENDLOOP.
*        IF lv_error_mixed = abap_true.
*           APPEND VALUE #( %tky = ls_item-%tky ) TO failed-zi_gateentry_itm_s.
*           APPEND VALUE #( %tky = ls_item-%tky
*                           %msg = new_message_with_text(
*                                    severity = if_abap_behv_message=>severity-error
*                                    text     = 'Cannot mix LF and LR Delivery Document Types in the same gate entry.' )
*                           %element-outbounddelivery     = if_abap_behv=>mk-on
*                         ) TO reported-zi_gateentry_itm_s.
*           CONTINUE.
*        ENDIF.
*      ENDIF.
      " ------------------------------------------------------------------------
      " VALIDATION 4: Quantity Check
      " ------------------------------------------------------------------------
      SELECT SINGLE ActualDeliveryQuantity FROM I_DeliveryDocumentItem WITH PRIVILEGED ACCESS
               WHERE DeliveryDocument     = @lv_delivery
                 AND DeliveryDocumentItem = @ls_item-Outbounddeliveryitem
               INTO @DATA(lv_actual_qty).

      IF sy-subrc = 0 AND lv_actual_qty = 0.
        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-zi_gateentry_itm_s.
        APPEND VALUE #( %tky = ls_item-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Actual Delivery Quantity is 0.000 for this item.' )
                        %element-outbounddelivery     = if_abap_behv=>mk-on
                        %element-outbounddeliveryitem = if_abap_behv=>mk-on
                      ) TO reported-zi_gateentry_itm_s.
        CONTINUE.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_gateentry_hdr_s DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_gateentry_hdr_s RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_gateentry_hdr_s RESULT result.
    METHODS ref FOR MODIFY
      IMPORTING keys FOR ACTION zi_gateentry_hdr_s~ref RESULT result.
    METHODS setdefaults FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_gateentry_hdr_s~setdefaults.
    METHODS setgateindatetime1 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_gateentry_hdr_s~setgateindatetime1.
    METHODS calculatenet1 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_gateentry_hdr_s~calculatenet1.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_gateentry_hdr_s RESULT result.
    METHODS fetcht1 FOR MODIFY
      IMPORTING keys FOR ACTION zi_gateentry_hdr_s~fetcht1 RESULT result.
*    METHODS earlynumbering_create FOR NUMBERING
*      IMPORTING entities FOR CREATE zi_gateentry_hdr_s.

ENDCLASS.

CLASS lhc_zi_gateentry_hdr_s IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.

    IF requested_authorizations-%create EQ if_abap_behv=>mk-on.
      IF result IS INITIAL.
        result-%create = if_abap_behv=>auth-allowed.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD ref.

    READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
    ENTITY zi_gateentry_hdr_s
      ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_headers).

    READ TABLE lt_headers INTO DATA(w_hdr) INDEX  1.
    MODIFY ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
     ENTITY zi_gateentry_hdr_s
       UPDATE FIELDS ( net )
       WITH VALUE #( FOR header IN lt_headers (
                       %tky = header-%tky
                       net  = COND #(
                     WHEN header-gross IS NOT INITIAL
                      AND header-tare  IS NOT INITIAL
                     THEN header-Gross - header-Tare "- lv_pack " header-pack
                     ELSE 0
                     )
*                       net  = header-gross - header-tare -
*                          header-pack
                     ) ).

    READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
        ENTITY zi_gateentry_hdr_s
          ALL FIELDS WITH
          CORRESPONDING #( keys )
        RESULT DATA(result_read).
    result = VALUE #( FOR result_order IN result_read ( %tky   = result_order-%tky
                                                           %param = result_order ) ).

  ENDMETHOD.

  METHOD setDefaults.

    DATA: nr_number     TYPE cl_numberrange_runtime=>nr_number.
    DATA : lv_quantity TYPE i VALUE '00000000000000000001'.
    DATA: lt_poparallel TYPE cl_abap_parallel=>t_in_inst_tab .
    READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
    ENTITY zi_gateentry_hdr_s
      ALL FIELDS
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_data).
    READ TABLE lt_data INTO DATA(w_data) INDEX 1.
    IF w_data-zgate IS INITIAL.
      DATA(lo_proc) = NEW cl_abap_parallel( p_percentage = 30 )  .
      INSERT NEW zOUT_parallel(  lt_po_details = CORRESPONDING #( lt_data )  )
        INTO TABLE lt_poparallel.

      IF lt_poparallel IS NOT INITIAL .

        lo_proc->run_inst(  EXPORTING p_in_tab = lt_poparallel
                                     p_debug = abap_false
                            IMPORTING p_out_tab = DATA(lt_finished)  ).

        READ TABLE lt_finished INTO DATA(ls_finished) INDEX 1.
        DATA(lo_instance) = CAST zOUT_parallel( ls_finished-inst ).
        DATA(lt_generated) = lo_instance->it_po_final.

    read table lt_generated into data(w_g) inDEX 1.
    DATA : update_lines TYPE TABLE FOR UPDATE zi_gateentry_hdr_s,
           update_line  TYPE STRUCTURE FOR UPDATE zi_gateentry_hdr_s.
    LOOP AT keys INTO DATA(key).
              IF line_exists( lt_data[ zid = key-zid
                                        ] ).
                update_line-%tky                   = key-%tky.
                update_line-Zgate                  = w_g-zgate.
                APPEND update_line TO update_lines.
              ENDIF.
            ENDLOOP.
    MODIFY ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
                  ENTITY zi_gateentry_hdr_s
                    UPDATE
                      FIELDS ( Zgate )
                      WITH update_lines
                      REPORTED data(reported1)
                      FAILED data(failed1)
                      MAPPED data(mapped1).
      ENDIF.
    ENDIF.

    IF sy-subrc = 0.

    ENDIF.
  ENDMETHOD.

  METHOD setGateInDateTime1.

     " 1. Read the newly created records
    READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
      ENTITY zi_gateentry_hdr_s
        FIELDS ( gateindt gateinout ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_gate_entries).

    " 2. Remove any records where date/time might already be set
    " (if you allow manual input and only want to default if empty)
    DELETE lt_gate_entries WHERE ( gateindt IS NOT INITIAL AND gateinout IS NOT INITIAL )
             OR Tare <= 0.
    CHECK lt_gate_entries IS NOT INITIAL.

    " 3. Get current local date and time using the user's timezone
    GET TIME STAMP FIELD DATA(lv_ts).

    DATA lv_tz TYPE timezone.
    lv_tz = 'INDIA'. " Default timezone if user tz is not maintained
*    ENDTRY.

    DATA: lv_current_date TYPE d,
          lv_current_time TYPE t.

    CONVERT TIME STAMP lv_ts TIME ZONE lv_tz
            INTO DATE lv_current_date
                 TIME lv_current_time.


    " 4. Update the entities with the current date and time
    MODIFY ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
      ENTITY zi_gateentry_hdr_s
        UPDATE
        FIELDS ( gateindt gateinout )
        WITH VALUE #( FOR rec IN lt_gate_entries (
                        %tky      = rec-%tky
                        gateindt  = lv_current_date
                        gateinout = lv_current_time
                      ) )
      REPORTED DATA(update_reported).

    " 5. Pass back any reported messages
    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD Calculatenet1.

     READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
 ENTITY zi_gateentry_hdr_s
   FIELDS ( gross tare pack )
   WITH CORRESPONDING #( keys )
 RESULT DATA(lt_headers).

    CHECK lt_headers IS NOT INITIAL.
      read table lt_headers into data(wa_hdr) iNDEX 1.
     GET TIME STAMP FIELD DATA(lv_ts).

    DATA lv_tz TYPE timezone.
*    TRY.
*        lv_tz = cl_abap_context_info=>get_user_time_zone( ).
*      CATCH cx_abap_context_info_error.
    lv_tz = 'INDIA'. " Default timezone if user tz is not maintained
*    ENDTRY.

    DATA: lv_current_date TYPE d,
          lv_current_time TYPE t.
    if wa_hdr-Gross is nOT iNITIAL and wa_hdr-Gateoutdt is INITIAL.
    CONVERT TIME STAMP lv_ts TIME ZONE lv_tz
            INTO DATE lv_current_date
                 TIME lv_current_time.
    endif.
    if wa_hdr-gateindt is nOT iNITIAL.
       wa_hdr-Gateoutdt = lv_current_date.
       wa_hdr-Gateoutout = lv_current_time.
    endif.
    MODIFY ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
      ENTITY zi_gateentry_hdr_s
        UPDATE FIELDS ( net Gateoutdt Gateoutout )
        WITH VALUE #(
          FOR header IN lt_headers
          (
            %tky = header-%tky
            net  = COND #(
                     WHEN header-gross IS NOT INITIAL
                      AND header-tare  IS NOT INITIAL
                     THEN header-Gross - header-Tare
                     ELSE 0
                   )
            Gateoutdt = lv_current_date
            Gateoutout = lv_current_time
            %control-net = if_abap_behv=>mk-on   " 🔥 IMPORTANT
            %control-Gateoutdt = if_abap_behv=>mk-on
            %control-Gateoutout = if_abap_behv=>mk-on
          )
        )
        REPORTED DATA(lt_reported)
        FAILED   DATA(lt_failed).

    READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
      ENTITY zi_gateentry_itm_s
        FIELDS ( Outbounddelivery Outbounddeliveryitem  )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

*    IF lt_items[] IS NOT INITIAL.

      READ TABLE lt_headers INTO DATA(w_hdr4) INDEX 1.
      IF lt_items[] IS NOT INITIAL.
      LOOP AT lt_items INTO DATA(ls_item).
        IF ls_item-Outbounddelivery IS NOT INITIAL AND ls_item-Outbounddeliveryitem IS NOT INITIAL.
          DATA(lv_delivery) = ls_item-Outbounddelivery.
          lv_delivery = |{ lv_delivery ALPHA = IN }|.

          SELECT SINGLE ActualDeliveryQuantity
                   FROM I_DeliveryDocumentItem
                   WHERE DeliveryDocument     = @lv_delivery
                     AND DeliveryDocumentItem = @ls_item-Outbounddeliveryitem
                   INTO @DATA(lv_actual_qty).

          IF sy-subrc = 0 AND w_hdr4-Net IS NOT INITIAL AND w_hdr4-Net <> lv_actual_qty.
             APPEND VALUE #( %tky = ls_item-%tky
                             %msg = new_message_with_text(
                                      severity = if_abap_behv_message=>severity-error
                                      text     = 'Net Quantity cannot be greater than Actual Delivery Quantity.' )
                             %element-actualdeliveryquantity = if_abap_behv=>mk-on
                           ) TO reported-zi_gateentry_itm_s.
          ENDIF.
        ENDIF.
      ENDLOOP.
*      IF w_hdr4-gross IS NOT INITIAL AND w_hdr4-tare IS NOT INITIAL.
**        MODIFY ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
**      ENTITY zi_gateentry_itm_s
**        UPDATE FIELDS ( receivedqty )
**        WITH VALUE #( FOR item IN lt_items (
**                        %tky        = item-%tky
**                        receivedqty = w_hdr4-gross - w_hdr4-tare -
**                        w_hdr4-pack
**                      ) ).
*      ENDIF.

    ENDIF.

  ENDMETHOD.

*  METHOD earlynumbering_create.
*
*    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entities>).
*      APPEND CORRESPONDING #( <fs_entities> ) TO mapped-zi_gateentry_hdr_s
*      ASSIGNING FIELD-SYMBOL(<fs_poupload>).
**      <fs_poupload>-enduser = cl_abap_context_info=>get_user_technical_name( ).
*      IF <fs_poupload>-zid IS INITIAL.
*        TRY.
*            <fs_poupload>-zid = cl_system_uuid=>create_uuid_x16_static(  ).
*          CATCH cx_uuid_error.
*        ENDTRY.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.

    METHOD get_instance_features.

    " -------------------------------------------------------------------------
    " NEW: Verify if current user exists in custom table zuser_id
    " -------------------------------------------------------------------------
    DATA: lv_is_authorized TYPE abap_bool VALUE abap_false.
    DATA: lv_uname         TYPE sy-uname.

    TRY.
        lv_uname = cl_abap_context_info=>get_user_technical_name( ).
      CATCH cx_abap_context_info_error.
        lv_uname = sy-uname. " Fallback to system field
    ENDTRY.

    " Check if the user exists in table zuser_id (Change 'bname' if your table's field is different, e.g., 'userid' or 'uname')
    SELECT SINGLE @abap_true
      FROM zuser_id
      WHERE user_id = @lv_uname
      INTO @lv_is_authorized.

    " 1. Read header data AND associated items
    READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
      ENTITY zi_gateentry_hdr_s
        FIELDS ( Zgate zid gateindt chk chk1 tare gross ) " Ensure zid and chk1 are read
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers)
      ENTITY zi_gateentry_hdr_s BY \_ADV_item1
        FIELDS ( zid Zgate outbounddelivery ) " FIX: Explicitly request zid / Zgate here!
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    LOOP AT keys INTO DATA(ls_key).
      DATA(ls_hdr) = VALUE #( lt_headers[ %tky = ls_key-%tky ] OPTIONAL ).

      " 2. Check if at least one associated line item has a Delivery entered
      DATA(lv_has_delivery) = abap_false.

      " FIX: Match using 'zid' since it is the primary unique ID
      LOOP AT lt_items INTO DATA(ls_item) WHERE zid = ls_hdr-zid.
        IF ls_item-outbounddelivery IS NOT INITIAL.
          lv_has_delivery = abap_true.
          EXIT. " We found at least one, no need to check the rest
        ENDIF.
      ENDLOOP.

      APPEND VALUE #(
        %tky         = ls_key-%tky

        " -------------------------------------------------------------------------
        " NEW: Auth check logic for chk
        " -------------------------------------------------------------------------
        %field-chk   = COND #(
                         WHEN lv_is_authorized = abap_true THEN if_abap_behv=>fc-f-unrestricted
                         ELSE if_abap_behv=>fc-f-read_only )

        " -------------------------------------------------------------------------

        " Gross weight logic
        %field-gross = COND #(
                         " CASE 1: Both chk and chk1 are X
                         WHEN ls_hdr-chk = abap_true AND ls_hdr-chk1 = abap_true AND ( ls_hdr-gross IS INITIAL OR ls_hdr-gross = 0 )
                           THEN if_abap_behv=>fc-f-unrestricted
                         " CASE 2: Only chk is X (Tare first) -> Open ONLY when Tare > 0 AND at least one line item delivery was entered
                         WHEN ls_hdr-chk = abap_true AND ls_hdr-chk1 <> abap_true AND ( ls_hdr-tare IS NOT INITIAL AND ls_hdr-tare > 0 ) AND lv_has_delivery = abap_true
                           THEN if_abap_behv=>fc-f-unrestricted
                         " Default: Read only
                         ELSE if_abap_behv=>fc-f-read_only )

        " Tare weight logic
        %field-tare  = COND #(
                         " CASE 1: Both chk and chk1 are X
                         WHEN ls_hdr-chk = abap_true AND ls_hdr-chk1 = abap_true AND ( ls_hdr-gross IS NOT INITIAL AND ls_hdr-gross > 0 )
                           THEN if_abap_behv=>fc-f-unrestricted
                         " CASE 2: Only chk is X
                         WHEN ls_hdr-chk = abap_true AND ls_hdr-chk1 <> abap_true AND ( ls_hdr-tare IS INITIAL OR ls_hdr-tare = 0 )
                           THEN if_abap_behv=>fc-f-unrestricted
                         " Default: Read only
                         ELSE if_abap_behv=>fc-f-read_only )
      ) TO result.
    ENDLOOP.

  ENDMETHOD.


*  METHOD get_instance_features.
*
*          " 1. Read header data AND associated items
*     " 1. Read header data AND associated items
*    READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
*      ENTITY zi_gateentry_hdr_s
*        FIELDS ( Zgate zid gateindt chk chk1 tare gross ) " Ensure zid and chk1 are read
*        WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_headers)
*      ENTITY zi_gateentry_hdr_s BY \_ADV_item1
*        FIELDS ( zid Zgate outbounddelivery ) " FIX: Explicitly request zid / Zgate here!
*        WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_items).
*    LOOP AT keys INTO DATA(ls_key).
*      DATA(ls_hdr) = VALUE #( lt_headers[ %tky = ls_key-%tky ] OPTIONAL ).
*      " 2. Check if at least one associated line item has a Delivery entered
*      DATA(lv_has_delivery) = abap_false.
*      " FIX: Match using 'zid' since it is the primary unique ID
*      LOOP AT lt_items INTO DATA(ls_item) WHERE zid = ls_hdr-zid.
*        IF ls_item-outbounddelivery IS NOT INITIAL.
*          lv_has_delivery = abap_true.
*          EXIT. " We found at least one, no need to check the rest
*        ENDIF.
*      ENDLOOP.
*      APPEND VALUE #(
*        %tky    = ls_key-%tky
*        " Gross weight logic
*        %field-gross = COND #(
*                         " CASE 1: Both chk and chk1 are X
*                         WHEN ls_hdr-chk = abap_true AND ls_hdr-chk1 = abap_true AND ( ls_hdr-gross IS INITIAL OR ls_hdr-gross = 0 )
*                           THEN if_abap_behv=>fc-f-unrestricted
*                         " CASE 2: Only chk is X (Tare first) -> Open ONLY when Tare > 0 AND at least one line item delivery was entered
*                         WHEN ls_hdr-chk = abap_true AND ls_hdr-chk1 <> abap_true AND ( ls_hdr-tare IS NOT INITIAL AND ls_hdr-tare > 0 ) AND lv_has_delivery = abap_true
*                           THEN if_abap_behv=>fc-f-unrestricted
*                         " Default: Read only
*                         ELSE if_abap_behv=>fc-f-read_only )
*        " Tare weight logic
*        %field-tare  = COND #(
*                         " CASE 1: Both chk and chk1 are X
*                         WHEN ls_hdr-chk = abap_true AND ls_hdr-chk1 = abap_true AND ( ls_hdr-gross IS NOT INITIAL AND ls_hdr-gross > 0 )
*                           THEN if_abap_behv=>fc-f-unrestricted
*                         " CASE 2: Only chk is X
*                         WHEN ls_hdr-chk = abap_true AND ls_hdr-chk1 <> abap_true AND ( ls_hdr-tare IS INITIAL OR ls_hdr-tare = 0 )
*                           THEN if_abap_behv=>fc-f-unrestricted
*                         " Default: Read only
*                         ELSE if_abap_behv=>fc-f-read_only )
*      ) TO result.
*    ENDLOOP.
*
*
*
**      READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
**      ENTITY zi_gateentry_hdr_s
**        FIELDS ( Zgate gateindt chk tare gross ) " <--- Added 'tare' and 'gross' here
**        WITH CORRESPONDING #( keys )
**      RESULT DATA(lt_headers).
**    LOOP AT keys INTO DATA(ls_key).
**      " Try to find matching header row; use initial structure as default if not found
**      DATA(ls_hdr) = VALUE #( lt_headers[ %tky = ls_key-%tky ] OPTIONAL ).
**      APPEND VALUE #(
**        %tky    = ls_key-%tky
**        " Gross weight is open for input ONLY when Manual check (chk) is true AND Tare is already entered (> 0)
**        %field-gross = COND #( WHEN ls_hdr-chk = abap_true AND ( ls_hdr-tare IS NOT INITIAL AND ls_hdr-tare > 0 )
**                               THEN if_abap_behv=>fc-f-unrestricted
**                               ELSE if_abap_behv=>fc-f-read_only )
**        " Tare weight is open for input ONLY when Manual check (chk) is true AND Tare is NOT yet entered (= 0 or initial)
**        %field-tare  = COND #( WHEN ls_hdr-chk = abap_true AND ( ls_hdr-tare IS INITIAL OR ls_hdr-tare = 0 )
**                               THEN if_abap_behv=>fc-f-unrestricted
**                               ELSE if_abap_behv=>fc-f-read_only )
**      ) TO result.
**
**    ENDLOOP.
*
*  ENDMETHOD.

  METHOD FetchT1.

         daTA: lv_xml_result_str        TYPE string,
          lv_response              TYPE string,
          lv_doc_status            TYPE string,
          lv_error_response        type string.
    TRY.
          DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                   comm_scenario      = 'ZCS_FETCHWEIGHT'
                                       service_id     = 'ZFETCHWEIGHT_REST'
                                 ).



          DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
          CATCH cx_web_http_client_error INTO DATA(lx_error).
          DATA(lo_request) = lo_http_client->get_http_request( ).
          lo_request->set_header_field( i_name  = 'Content-Type'
                                              i_value = 'application/json' ).
          TRY.
              DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>get ).
              lv_xml_result_str = lo_response->get_text( ).
              lv_response = lv_xml_result_str.
            CATCH cx_web_http_client_error .
          ENDTRY.
*          DATA : str TYPE string.
*        SPLIT lv_xml_result_str AT '"":"'   INTO str lv_doc_status.
*        SPLIT lv_xml_result_str AT '"":'     INTO str lv_error_response.

         DATA: str TYPE string.
        " Split JSON by weight_kg key to grab the number
        SPLIT lv_xml_result_str AT '"weight_kg":' INTO str lv_doc_status.

        IF sy-subrc = 0.
          " Now split by comma (since it's followed by ` , "weight_mt": `)
          SPLIT lv_doc_status AT ',' INTO DATA(lv_weight_str) DATA(lv_rest).
          CONDENSE lv_weight_str.

          " First read the current Draft header to see if Gross is already filled
          READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
            ENTITY zi_gateentry_hdr_s
              FIELDS ( Gross ) WITH CORRESPONDING #( keys )
            RESULT DATA(lt_existing_hdr).

          " Update the entity with the new Weight
          " If Gross is initial, update Gross. If Gross is already filled, update Tare.
          LOOP AT lt_existing_hdr INTO DATA(ls_check_hdr).
            IF ls_check_hdr-Gross IS INITIAL OR ls_check_hdr-Gross = 0.
              MODIFY ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
                ENTITY zi_gateentry_hdr_s
                  UPDATE FIELDS ( Gross )
                  WITH VALUE #( ( %tky = ls_check_hdr-%tky Gross = CONV #( lv_weight_str ) ) )
                REPORTED DATA(lt_rep_gross).
              reported = CORRESPONDING #( DEEP lt_rep_gross ).
            ELSE.
              MODIFY ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
                ENTITY zi_gateentry_hdr_s
                  UPDATE FIELDS ( Tare )
                  WITH VALUE #( ( %tky = ls_check_hdr-%tky Tare = CONV #( lv_weight_str ) ) )
                REPORTED DATA(lt_rep_tare).
              reported = CORRESPONDING #( DEEP lt_rep_tare ).
            ENDIF.
          ENDLOOP.

          " Read the updated entity back to result parameter
          READ ENTITIES OF zi_gateentry_hdr_s IN LOCAL MODE
            ENTITY zi_gateentry_hdr_s
              ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_hdr).

          " Map it to the $self entity result
          result = VALUE #( FOR ls_hdr IN lt_hdr ( %tky = ls_hdr-%tky %param = CORRESPONDING #( ls_hdr ) ) ).

          " Pass upstream messages
*          reported = CORRESPONDING #( DEEP lt_reported ).
        ENDIF.
       CATCH cx_http_dest_provider_error.
    enDTRY.
    if sy-subrc = 0.

    endif.

  ENDMETHOD.

ENDCLASS.
