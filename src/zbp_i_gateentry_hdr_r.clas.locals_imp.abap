CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS CalculateItemDetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~CalculateItemDetails.

    METHODS CalculateItemDetails1 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~CalculateItemDetails1.

    METHODS setClockOut FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~setClockOut.

    METHODS setItemZgate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~setItemZgate.

    METHODS ValidateDocument FOR VALIDATE ON SAVE
      IMPORTING keys FOR item~ValidateDocument.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR item RESULT result.

ENDCLASS.

CLASS lhc_item IMPLEMENTATION.

  METHOD get_instance_features.
    " 1. Read the Header 'Type' for the requested items via the parent association
    READ ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
      ENTITY item BY \_ADV_HEADr
        FIELDS ( Type )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers)
      LINK DATA(lt_links).
    " 2. Loop over the items and set the field states dynamically
    LOOP AT keys INTO DATA(ls_key).
      " Default state is unrestricted (editable)
      DATA(lv_feature) = if_abap_behv=>fc-f-unrestricted.
      " Find the associative link for this specific item
      READ TABLE lt_links INTO DATA(ls_link) WITH KEY source-%tky = ls_key-%tky.
      IF sy-subrc = 0.
        " Find the header details using the link target
        READ TABLE lt_headers INTO DATA(ls_header) WITH KEY %tky = ls_link-target-%tky.
        " If the Gate Type is 'NRGP', make the return fields read-only
        IF sy-subrc = 0 AND ls_header-Type = 'NRGP'.
          lv_feature = if_abap_behv=>fc-f-read_only.
        ENDIF.
      ENDIF.
      " Append the control settings to the result table
      APPEND VALUE #( %tky              = ls_key-%tky
                      %field-ReturnDate = lv_feature
                      %field-returnqty  = lv_feature
                    ) TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD CalculateItemDetails.

    READ ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
      ENTITY item
        FIELDS ( Zgate ChallanNo zeile )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    CHECK lt_items IS NOT INITIAL.
    LOOP AT lt_items INTO DATA(ls_item).
      IF ls_item-ChallanNo IS NOT INITIAL AND ls_item-Zeile IS NOT INITIAL.
        SELECT SINGLE *
            FROM I_DeliveryDocumentItem
            WHERE DeliveryDocument = @ls_item-ChallanNo
              AND DeliveryDocumentItem = @ls_item-Zeile
              INTO @DATA(wa_item).

        SELECT SINGLE FROM I_PurchaseOrderItemAPI01
          FIELDS Material, PurchaseOrderItemText
          WHERE Material = @wa_item-Material
          INTO @DATA(ls_po_data).
        IF sy-subrc = 0.
          MODIFY ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
              ENTITY item
                UPDATE FIELDS ( Matnr maktx Charg Werks Quantity Uom )
                WITH VALUE #( ( %tky = ls_item-%tky
                                Matnr = wa_item-Product
                                maktx = ls_po_data-PurchaseOrderItemText
                                Charg = wa_item-Batch
                                Werks = wa_item-Plant
                                Quantity = wa_item-ActualDeliveryQuantity
                                Uom = wa_item-DeliveryQuantityUnit ) ).
        ENDIF.

*        MODIFY ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
*            ENTITY item
*              UPDATE FIELDS ( Matnr Zeile ChallanNo Charg Werks Quantity Uom )
*              WITH VALUE #( ( %tky = ls_item-%tky
*                              Matnr = wa_item-Product
*                              Zeile = wa_item-DeliveryDocumentItem
*                              ChallanNo = wa_item-DeliveryDocument
*                              Charg = wa_item-Batch
*                              Werks = wa_item-Plant
*                              Quantity = wa_item-ActualDeliveryQuantity
*                              Uom = wa_item-DeliveryQuantityUnit ) ).
      ENDIF.

      IF ls_item-Mblnr IS NOT INITIAL AND ls_item-Zeile IS NOT INITIAL.
        SELECT SINGLE *
            FROM i_materialdocumentitem_2
            WHERE MaterialDocument = @ls_item-Mblnr
              AND MaterialDocumentItem = @ls_item-Zeile
              INTO @DATA(wa_item1).

        SELECT SINGLE FROM I_PurchaseOrderItemAPI01
         FIELDS Material, PurchaseOrderItemText
         WHERE Material = @wa_item1-Material
         INTO @DATA(ls_po_data1).

        IF sy-subrc = 0.
          MODIFY ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
            ENTITY item
              UPDATE FIELDS ( Matnr   Maktx Charg Werks Quantity Uom )
              WITH VALUE #( ( %tky = ls_item-%tky
                              Matnr = wa_item1-Material
                              Maktx = ls_po_data1-PurchaseOrderItemText
                              Charg = wa_item1-Batch
                              Werks = wa_item1-Plant
                              Quantity = wa_item1-QuantityInBaseUnit
                              Uom = wa_item1-DeliveryQuantityUnit
                               ) ).
        ENDIF.

      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD CalculateItemDetails1.

    READ ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
      ENTITY item
        FIELDS ( Zgate Quantity ReturnQty )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    LOOP AT lt_items INTO DATA(w_items).
      MODIFY ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
                ENTITY item
                  UPDATE FIELDS ( BalanceQty )
                  WITH VALUE #( ( %tky = w_items-%tky
                                  BalanceQty = w_items-Quantity -  w_items-ReturnQty ) ).
    ENDLOOP.

  ENDMETHOD.

  METHOD setClockOut.

    " Read the associated headers for the newly created items
    READ ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
      ENTITY item BY \_ADV_HEADr
        FIELDS ( gateoutdt gateoutout )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).
    " Remove duplicate headers (in the event multiple items are created simultaneously)
    SORT lt_headers BY %tky.
    DELETE ADJACENT DUPLICATES FROM lt_headers COMPARING %tky.
    DATA: update_lines TYPE TABLE FOR UPDATE ZI_GATEENTRY_hdr_R,
          update_line  TYPE STRUCTURE FOR UPDATE ZI_GATEENTRY_hdr_R.

    DATA lv_date TYPE d.
    DATA lv_time TYPE t.

    TRY.
        CONVERT UTCLONG utclong_current( )
          INTO DATE lv_date
          TIME lv_time
          TIME ZONE 'INDIA'. " <--- Hardcoded to Indian Standard Time
      CATCH cx_sy_conversion_no_date_time.
        " Fallback just in case
        lv_date = cl_abap_context_info=>get_system_date( ).
        lv_time = cl_abap_context_info=>get_system_time( ).
    ENDTRY.

    LOOP AT lt_headers INTO DATA(ls_header).
      update_line-%tky        = ls_header-%tky.
      update_line-gateoutdt   = lv_date.
      update_line-gateoutout  = lv_time.
      APPEND update_line TO update_lines.
    ENDLOOP.
    " Update the Header with Clock Out times
    IF update_lines IS NOT INITIAL.
      MODIFY ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
        ENTITY ZI_GATEENTRY_hdr_R
          UPDATE
            FIELDS ( gateoutdt gateoutout )
            WITH update_lines
        REPORTED DATA(lt_reported).
    ENDIF.

  ENDMETHOD.

  METHOD setItemZgate.

    READ ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
      ENTITY item
        FIELDS ( zgate )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).
    " Read corresponding headers via association
    READ ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
      ENTITY item BY \_ADV_HEADr
        FIELDS ( zgate )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers)
      LINK DATA(lt_link).
    DATA: update_lines TYPE TABLE FOR UPDATE ZI_GATEENTRY_itm_R,
          update_line  TYPE STRUCTURE FOR UPDATE ZI_GATEENTRY_itm_R.
    LOOP AT lt_items INTO DATA(ls_item).
      " Find the associative link for this specific item
      READ TABLE lt_link INTO DATA(ls_link) WITH KEY source-%tky = ls_item-%tky.
      IF sy-subrc = 0.
        " Find the header details using the link target
        READ TABLE lt_headers INTO DATA(ls_header) WITH KEY %tky = ls_link-target-%tky.

        " If header has a Zgate and item does not, update the item
        IF sy-subrc = 0 AND ls_header-zgate IS NOT INITIAL AND ls_item-zgate IS INITIAL.
          update_line-%tky   = ls_item-%tky.
          update_line-zgate  = ls_header-zgate.
          APPEND update_line TO update_lines.
        ENDIF.
      ENDIF.
    ENDLOOP.
    IF update_lines IS NOT INITIAL.
      MODIFY ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
        ENTITY item
          UPDATE FIELDS ( zgate )
          WITH update_lines
        REPORTED DATA(lt_reported).
    ENDIF.


  ENDMETHOD.

  METHOD ValidateDocument.

    READ ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
      ENTITY item
        " Added posnr, zeile, and zid to the fields to read
        FIELDS ( ChallanNo mblnr posnr zeile zid )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    LOOP AT lt_items INTO DATA(ls_item).
      " 1. Check if neither field is provided
      IF ls_item-ChallanNo IS INITIAL AND ls_item-mblnr IS INITIAL.
        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-item.
        APPEND VALUE #( %tky = ls_item-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Please enter either a Challan No or an Material Doc'
                               )
                        %element-ChallanNo = if_abap_behv=>mk-on
                        %element-mblnr = if_abap_behv=>mk-on
                      ) TO reported-item.

        " 2. Check if both fields are provided (since user must fill only one out of the 2)
      ELSEIF ls_item-ChallanNo IS NOT INITIAL AND ls_item-mblnr IS NOT INITIAL.
        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-item.
        APPEND VALUE #( %tky = ls_item-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Please enter ONLY ONE: either Challan No or Material Doc'
                               )
                        %element-ChallanNo = if_abap_behv=>mk-on
                        %element-mblnr = if_abap_behv=>mk-on
                      ) TO reported-item.
      ENDIF.

      " 3. Validation for duplicate ChallanNo + posnr in DB table
      IF ls_item-ChallanNo IS NOT INITIAL AND ls_item-posnr IS NOT INITIAL.
        SELECT SINGLE @abap_true FROM ztgate_item_r
          WHERE challan_no = @ls_item-ChallanNo
            AND posnr      = @ls_item-posnr
            AND zid        <> @ls_item-zid   " Exclude the current item being edited/saved
          INTO @DATA(lv_challan_exists).

        IF lv_challan_exists = abap_true.
          APPEND VALUE #( %tky = ls_item-%tky ) TO failed-item.
          APPEND VALUE #( %tky = ls_item-%tky
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = 'Item with this Challan No and Posnr already exists'
                                 )
                          %element-ChallanNo = if_abap_behv=>mk-on
                          %element-posnr = if_abap_behv=>mk-on
                        ) TO reported-item.
        ENDIF.
      ENDIF.

      " 4. Validation for duplicate mblnr + zeile in DB table
      IF ls_item-mblnr IS NOT INITIAL AND ls_item-zeile IS NOT INITIAL.
        SELECT SINGLE @abap_true FROM ztgate_item_r
          WHERE mblnr = @ls_item-mblnr
            AND zeile = @ls_item-zeile
            AND zid   <> @ls_item-zid      " Exclude the current item being edited/saved
          INTO @DATA(lv_mblnr_exists).

        IF lv_mblnr_exists = abap_true.
          APPEND VALUE #( %tky = ls_item-%tky ) TO failed-item.
          APPEND VALUE #( %tky = ls_item-%tky
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = 'Item with this Material Doc and Item already exists'
                                 )
                          %element-mblnr = if_abap_behv=>mk-on
                          %element-zeile = if_abap_behv=>mk-on
                        ) TO reported-item.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

*  METHOD ValidateDocument.
*
*    READ ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
*      ENTITY item
*        FIELDS ( ChallanNo mblnr )
*        WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_items).
*    LOOP AT lt_items INTO DATA(ls_item).
*      " Check if neither field is provided
*      IF ls_item-ChallanNo IS INITIAL AND ls_item-mblnr IS INITIAL.
*        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-item.
*        APPEND VALUE #( %tky = ls_item-%tky
*                        %msg = new_message_with_text(
*                                 severity = if_abap_behv_message=>severity-error
*                                 text     = 'Please enter either a Challan No or an MBLNR'
*                               )
*                        %element-ChallanNo = if_abap_behv=>mk-on
*                        %element-mblnr = if_abap_behv=>mk-on
*                      ) TO reported-item.
*      " Check if both fields are provided (since user must fill only one out of the 2)
*      ELSEIF ls_item-ChallanNo IS NOT INITIAL AND ls_item-mblnr IS NOT INITIAL.
*        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-item.
*        APPEND VALUE #( %tky = ls_item-%tky
*                        %msg = new_message_with_text(
*                                 severity = if_abap_behv_message=>severity-error
*                                 text     = 'Please enter ONLY ONE: either Challan No or MBLNR'
*                               )
*                        %element-ChallanNo = if_abap_behv=>mk-on
*                        %element-mblnr = if_abap_behv=>mk-on
*                      ) TO reported-item.
*      ENDIF.
*    ENDLOOP.
*
*  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_gateentry_hdr_r DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_gateentry_hdr_r RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_gateentry_hdr_r RESULT result.

    METHODS validatestoragelocation FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_gateentry_hdr_r~validatestoragelocation.
    METHODS setdefaults1 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_gateentry_hdr_r~setdefaults1.
    METHODS setclockin FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_gateentry_hdr_r~setclockin.


*    METHODS earlynumbering_create FOR NUMBERING
*      IMPORTING entities FOR CREATE zi_gateentry_hdr_r.

ENDCLASS.

CLASS lhc_zi_gateentry_hdr_r IMPLEMENTATION.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD ValidateStorageLocation.
    READ ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
      ENTITY ZI_GATEENTRY_hdr_R
        FIELDS ( Type )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    LOOP AT lt_items INTO DATA(ls_item).
      IF ls_item-Type IS INITIAL.
        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-zi_gateentry_hdr_r.

        APPEND VALUE #( %tky = ls_item-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Please Select Gate type'
                               )
                        %element-Type = if_abap_behv=>mk-on
                      ) TO reported-zi_gateentry_hdr_r.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

*  METHOD earlynumbering_create.
*
*    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entities>).
*      APPEND CORRESPONDING #( <fs_entities> ) TO mapped-zi_gateentry_hdr_r
*      ASSIGNING FIELD-SYMBOL(<fs_poupload>).
**      <fs_poupload>-enduser = cl_abap_context_info=>get_user_technical_name( ).
*      IF <fs_poupload>-zid IS INITIAL.
*        TRY.
*            <fs_poupload>-zid = cl_system_uuid=>create_uuid_x16_static(  ).
*          CATCH cx_uuid_error.
*        ENDTRY.
*      ENDIF.
*    ENDLOOP.
*
*  ENDMETHOD.

  METHOD setDefaults1.

    DATA: nr_number     TYPE cl_numberrange_runtime=>nr_number.
    DATA : lv_quantity TYPE i VALUE '00000000000000000001'.
    DATA: lt_poparallel TYPE cl_abap_parallel=>t_in_inst_tab .
    READ ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
    ENTITY ZI_GATEENTRY_hdr_R
      ALL FIELDS
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_data).
    READ TABLE lt_data INTO DATA(w_data) INDEX 1.
    IF w_data-zgate IS INITIAL.
      DATA(lo_proc) = NEW cl_abap_parallel( p_percentage = 30 )  .
      INSERT NEW zRGP_parallel(  lt_po_details = CORRESPONDING #( lt_data )  )
        INTO TABLE lt_poparallel.

      IF lt_poparallel IS NOT INITIAL .

        lo_proc->run_inst(  EXPORTING p_in_tab = lt_poparallel
                                     p_debug = abap_false
                            IMPORTING p_out_tab = DATA(lt_finished)  ).

        READ TABLE lt_finished INTO DATA(ls_finished) INDEX 1.
        DATA(lo_instance) = CAST zRGP_parallel( ls_finished-inst ).
        DATA(lt_generated) = lo_instance->it_po_final.

        READ TABLE lt_generated INTO DATA(w_g) INDEX 1.
        DATA : update_lines TYPE TABLE FOR UPDATE ZI_GATEENTRY_hdr_R,
               update_line  TYPE STRUCTURE FOR UPDATE ZI_GATEENTRY_hdr_R.
        LOOP AT keys INTO DATA(key).
          IF line_exists( lt_data[ zid = key-zid
                                    ] ).
            update_line-%tky                   = key-%tky.
            update_line-Zgate                  = w_g-zgate.
            APPEND update_line TO update_lines.
          ENDIF.
        ENDLOOP.
        MODIFY ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
                      ENTITY ZI_GATEENTRY_hdr_R
                        UPDATE
                          FIELDS ( Zgate )
                          WITH update_lines
                          REPORTED DATA(reported1)
                          FAILED DATA(failed1)
                          MAPPED DATA(mapped1).
**     READ TABLE lt_headers INTO DATA(w_hdr) INDEX  1.
*    MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
*     ENTITY hdr
*       UPDATE FIELDS ( zgate )
*       WITH VALUE #( FOR header IN lt_generated (
*                       %tky = header-%tky
*                       zgate    = header-zgate
*                     ) ).
*    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
*        ENTITY hdr
*          ALL FIELDS WITH
*          CORRESPONDING #( keys )
*        RESULT DATA(result_read).
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD setClockIn.
    " Read newly created headers
    READ ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
      ENTITY ZI_GATEENTRY_hdr_R
        FIELDS ( gateindt gateinout )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).

    DATA: update_lines TYPE TABLE FOR UPDATE ZI_GATEENTRY_hdr_R,
          update_line  TYPE STRUCTURE FOR UPDATE ZI_GATEENTRY_hdr_R.

    " ------ UPDATE: Force conversion to INDIA Timezone ------
    DATA lv_date TYPE d.
    DATA lv_time TYPE t.

    TRY.
        CONVERT UTCLONG utclong_current( )
          INTO DATE lv_date
          TIME lv_time
          TIME ZONE 'INDIA'. " <--- Hardcoded to Indian Standard Time
      CATCH cx_sy_conversion_no_date_time.
        " Fallback just in case
        lv_date = cl_abap_context_info=>get_system_date( ).
        lv_time = cl_abap_context_info=>get_system_time( ).
    ENDTRY.
    " --------------------------------------------------------

    LOOP AT lt_headers INTO DATA(ls_header).
      " Only set if not already provided
      IF ls_header-gateindt IS INITIAL AND ls_header-gateinout IS INITIAL.
        update_line-%tky      = ls_header-%tky.
        update_line-gateindt  = lv_date.
        update_line-gateinout = lv_time.
        APPEND update_line TO update_lines.
      ENDIF.
    ENDLOOP.

    " Update the current Draft / Active table with Clock In times
    IF update_lines IS NOT INITIAL.
      MODIFY ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
        ENTITY ZI_GATEENTRY_hdr_R
          UPDATE
            FIELDS ( gateindt gateinout )
            WITH update_lines
        REPORTED DATA(lt_reported).
    ENDIF.


*    " Read newly created headers
*    READ ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
*      ENTITY ZI_GATEENTRY_hdr_R
*        FIELDS ( gateindt gateinout )
*        WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_headers).
*    DATA: update_lines TYPE TABLE FOR UPDATE ZI_GATEENTRY_hdr_R,
*          update_line  TYPE STRUCTURE FOR UPDATE ZI_GATEENTRY_hdr_R.
*    LOOP AT lt_headers INTO DATA(ls_header).
*      " Only set if not already provided
*      IF ls_header-gateindt IS INITIAL AND ls_header-gateinout IS INITIAL.
*        update_line-%tky      = ls_header-%tky.
*        update_line-gateindt  = cl_abap_context_info=>get_system_date( ).
*        update_line-gateinout = cl_abap_context_info=>get_system_time( ).
*        APPEND update_line TO update_lines.
*      ENDIF.
*    ENDLOOP.
*    " Update the current Draft / Active table with Clock In times
*    IF update_lines IS NOT INITIAL.
*      MODIFY ENTITIES OF ZI_GATEENTRY_hdr_R IN LOCAL MODE
*        ENTITY ZI_GATEENTRY_hdr_R
*          UPDATE
*            FIELDS ( gateindt gateinout )
*            WITH update_lines
*        REPORTED DATA(lt_reported).
*    ENDIF.

  ENDMETHOD.

ENDCLASS.
