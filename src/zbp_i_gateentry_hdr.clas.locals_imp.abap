*CLASS lhc_HDR DEFINITION INHERITING FROM cl_abap_behavior_handler.
*  PRIVATE SECTION.
*
*    METHODS get_instance_features FOR INSTANCE FEATURES
*      IMPORTING keys REQUEST requested_features FOR hdr RESULT result.
*
*    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR hdr RESULT result.
*
*    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
*      IMPORTING REQUEST requested_authorizations FOR hdr RESULT result.
*
**    METHODS earlynumbering_create FOR NUMBERING
**
**      IMPORTING entities FOR CREATE hdr.
*
*    METHODS CreateGrn FOR MODIFY
*      IMPORTING keys FOR ACTION hdr~CreateGrn RESULT result.
*
*    METHODS FetchT FOR MODIFY
*      IMPORTING keys FOR ACTION hdr~FetchT RESULT result.
*
*    METHODS ref FOR MODIFY
*      IMPORTING keys FOR ACTION hdr~ref RESULT result.
*
*    METHODS zprint FOR MODIFY
*      IMPORTING keys FOR ACTION hdr~zprint RESULT result.
*
*    METHODS Calculatenet FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR hdr~Calculatenet.
*
*    METHODS setDefaults FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR hdr~setDefaults.
*
*    METHODS setGateInDateTime FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR hdr~setGateInDateTime.
*
*    METHODS ValidateGrossTare FOR VALIDATE ON SAVE
*      IMPORTING keys FOR hdr~ValidateGrossTare.
*
*ENDCLASS.
*
*CLASS lhc_HDR IMPLEMENTATION.
*
*  METHOD get_instance_features.
*  ENDMETHOD.
*
*  METHOD get_instance_authorizations.
*  ENDMETHOD.
*
*  METHOD get_global_authorizations.
*  ENDMETHOD.
*
**  METHOD earlynumbering_create.
**    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entities>).
**      APPEND CORRESPONDING #( <fs_entities> ) TO mapped-hdr
**      ASSIGNING FIELD-SYMBOL(<fs_poupload>).
***      <fs_poupload>-enduser = cl_abap_context_info=>get_user_technical_name( ).
**      IF <fs_poupload>-zid IS INITIAL.
**        TRY.
**            <fs_poupload>-zid = cl_system_uuid=>create_uuid_x16_static(  ).
**          CATCH cx_uuid_error.
**        ENDTRY.
**      ENDIF.
**    ENDLOOP.
**  ENDMETHOD.
*
*  METHOD CreateGrn.
*  ENDMETHOD.
*
*  METHOD FetchT.
*  ENDMETHOD.
*
*  METHOD ref.
*  ENDMETHOD.
*
*  METHOD zprint.
*  ENDMETHOD.
*
*  METHOD Calculatenet.
*  ENDMETHOD.
*
*  METHOD setDefaults.
*  ENDMETHOD.
*
*  METHOD setGateInDateTime.
*  ENDMETHOD.
*
*  METHOD ValidateGrossTare.
*  ENDMETHOD.
*
*ENDCLASS.
*
*CLASS lhc_ITEM DEFINITION INHERITING FROM cl_abap_behavior_handler.
*  PRIVATE SECTION.
*
*    METHODS get_instance_features FOR INSTANCE FEATURES
*      IMPORTING keys REQUEST requested_features FOR item RESULT result.
*
*    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR item RESULT result.
*
*    METHODS precheck_update FOR PRECHECK
*      IMPORTING entities FOR UPDATE item.
*
*    METHODS save0 FOR MODIFY
*      IMPORTING keys FOR ACTION item~save0 RESULT result.
*
*    METHODS CalculateItemDetails FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR item~CalculateItemDetails.
*
*    METHODS ebeln FOR VALIDATE ON SAVE
*      IMPORTING keys FOR item~ebeln.
*
*    METHODS ValidateStorageLocation FOR VALIDATE ON SAVE
*      IMPORTING keys FOR item~ValidateStorageLocation.
*
*ENDCLASS.
*
*CLASS lhc_ITEM IMPLEMENTATION.
*
*  METHOD get_instance_features.
*  ENDMETHOD.
*
*  METHOD get_instance_authorizations.
*  ENDMETHOD.
*
*  METHOD precheck_update.
*  ENDMETHOD.
*
*  METHOD save0.
*  ENDMETHOD.
*
*  METHOD CalculateItemDetails.
*  ENDMETHOD.
*
*  METHOD ebeln.
*  ENDMETHOD.
*
*  METHOD ValidateStorageLocation.
*  ENDMETHOD.
*
*ENDCLASS.

" ==============================
" DEFINITIONS
" ==============================

CLASS lsc_zi_gateentry_hdr DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

ENDCLASS.

CLASS lhc_zi_gateentry_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR hdr RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR hdr RESULT result.

    METHODS creategrn FOR MODIFY
      IMPORTING keys FOR ACTION hdr~creategrn RESULT result.

    METHODS calculatenet FOR DETERMINE ON MODIFY
      IMPORTING keys FOR hdr~calculatenet.

*    METHODS get_instance_features FOR INSTANCE FEATURES
*      IMPORTING keys REQUEST requested_features FOR hdr RESULT result.
    METHODS setdefaults FOR DETERMINE ON MODIFY
      IMPORTING keys FOR hdr~setdefaults.

*    METHODS earlynumbering_create FOR NUMBERING
*      IMPORTING entities FOR CREATE hdr.
**    METHODS validategateout FOR VALIDATE ON SAVE
**      IMPORTING keys FOR hdr~validategateout.
**    METHODS set_default_chk FOR DETERMINE ON MODIFY
**      IMPORTING keys FOR hdr~set_default_chk.
    METHODS ref FOR MODIFY
      IMPORTING keys FOR ACTION hdr~ref RESULT result.

    METHODS setgateindatetime FOR DETERMINE ON MODIFY
      IMPORTING keys FOR hdr~setgateindatetime.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR hdr RESULT result.
    METHODS fetcht FOR MODIFY
      IMPORTING keys FOR ACTION hdr~fetcht RESULT result.
    METHODS zprint FOR MODIFY
      IMPORTING keys FOR ACTION hdr~zprint RESULT result.
    METHODS validategrosstare FOR VALIDATE ON SAVE
      IMPORTING keys FOR hdr~validategrosstare.
*    METHODS earlynumbering_create FOR NUMBERING
*      IMPORTING entities FOR CREATE hdr.

ENDCLASS.

CLASS lsc_zi_gateentry_hdr IMPLEMENTATION.
ENDCLASS.

CLASS lhc_zi_gateentry_hdr IMPLEMENTATION.
  METHOD get_instance_authorizations.
    LOOP AT keys INTO DATA(ls_key).
      INSERT VALUE #(
          %tky = ls_key-%tky
          %action-creategrn = if_abap_behv=>auth-allowed
          %update           = if_abap_behv=>auth-allowed
          %delete           = if_abap_behv=>auth-allowed
*          %assoc-_ADV_item  = if_abap_behv=>auth-allowed
        ) INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_global_authorizations.
    IF requested_authorizations-%create EQ if_abap_behv=>mk-on.
      IF result IS INITIAL.
        result-%create = if_abap_behv=>auth-allowed.
      ENDIF.
    ENDIF.
  ENDMETHOD.

*  METHOD validategateout.
*
*    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
*      ENTITY hdr
*        FIELDS ( gross gateoutdt gateoutout )
*        WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_headers).
*
*    LOOP AT lt_headers INTO DATA(ls_hdr).
*
*      " Block save if Gate Out Date OR Time is filled but Gross is still zero/empty
*      IF ( ls_hdr-gateoutdt IS NOT INITIAL OR ls_hdr-gateoutout IS NOT INITIAL )
*         AND ls_hdr-gross = 0.
*
*        APPEND VALUE #( %key = ls_hdr-%key ) TO failed-hdr.
*
*        IF ls_hdr-gateoutdt IS NOT INITIAL.
*          APPEND VALUE #(
*            %key                  = ls_hdr-%key
*            %msg                  = new_message_with_text(
*                                      severity = if_abap_behv_message=>severity-error
*                                      text     = 'Gate Out Date cannot be set without Gross Weight' )
*            %element-gateoutdt    = if_abap_behv=>mk-on
*          ) TO reported-hdr.
*        ENDIF.
*
*        IF ls_hdr-gateoutout IS NOT INITIAL.
*          APPEND VALUE #(
*            %key                  = ls_hdr-%key
*            %msg                  = new_message_with_text(
*                                      severity = if_abap_behv_message=>severity-error
*                                      text     = 'Gate Out Time cannot be set without Gross Weight' )
*            %element-gateoutout   = if_abap_behv=>mk-on
*          ) TO reported-hdr.
*        ENDIF.
*
*      ENDIF.
*    ENDLOOP.
*
*  ENDMETHOD.

*  METHOD get_instance_features.
*
*    " Read Gross and Chk — used to determine gate-out + weight field visibility
*    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
*      ENTITY hdr
*        FIELDS ( gross chk )
*        WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_headers).
*
*    " Use LOOP over keys (not lt_headers) — ensures result is always populated,
*    " even for brand new records where READ ENTITIES returns nothing.
*    " When no header found → ls_hdr is initial → gross = '' → gate-out fields locked.
*    LOOP AT keys INTO DATA(ls_key).
*
*      " Try to find matching header row; use initial structure as default (safe)
*      DATA(ls_hdr) = VALUE #( lt_headers[ %key = ls_key-%key ] OPTIONAL ).
*
*      INSERT VALUE #(
*        %key = ls_key-%key
*
*        " Gate In: always editable
**        %field-gateindt  = if_abap_behv=>fc-f-unrestricted
**        %field-gateinout = if_abap_behv=>fc-f-unrestricted
*
*        " Gate Out: locked until Gross is entered
*        %field-gateoutdt  = COND #( WHEN ls_hdr-gross IS NOT INITIAL
*                                    THEN if_abap_behv=>fc-f-unrestricted
*                                    ELSE if_abap_behv=>fc-f-read_only )
*
*        %field-gateoutout = COND #( WHEN ls_hdr-gross IS NOT INITIAL
*                                    THEN if_abap_behv=>fc-f-unrestricted
*                                    ELSE if_abap_behv=>fc-f-read_only )
*
*        " Gross + Tare: editable only when Capture Manual (Chk) is checked
*        %field-gross = COND #( WHEN ls_hdr-chk = abap_true
*                                THEN if_abap_behv=>fc-f-unrestricted
*                                ELSE if_abap_behv=>fc-f-read_only )
*
*        %field-tare  = COND #( WHEN ls_hdr-chk = abap_true
*                                THEN if_abap_behv=>fc-f-unrestricted
*                                ELSE if_abap_behv=>fc-f-read_only )
*      ) INTO TABLE result.
*
*    ENDLOOP.
**  ENDMETHOD.
**    READ ENTITIES OF ZI_GATEENTRY_hdr IN LOCAL MODE
**      ENTITY HDR
**        FIELDS ( Gross Chk )
**        WITH CORRESPONDING #( keys )
**      RESULT DATA(lt_headers).
**
**    result = VALUE #( FOR header IN lt_headers (
**                        %tky = header-%tky
**                        %field-Gateindt   = COND #( WHEN header-Gross IS INITIAL THEN if_abap_behv=>fc-f-unrestricted ELSE if_abap_behv=>fc-f-read_only )
**                        %field-Gateinout  = COND #( WHEN header-Gross IS INITIAL THEN if_abap_behv=>fc-f-unrestricted ELSE if_abap_behv=>fc-f-read_only )
**
**                        %field-Gateoutdt  = COND #( WHEN header-Gross IS NOT INITIAL THEN if_abap_behv=>fc-f-unrestricted ELSE if_abap_behv=>fc-f-read_only )
**                        %field-Gateoutout = COND #( WHEN header-Gross IS NOT INITIAL THEN if_abap_behv=>fc-f-unrestricted ELSE if_abap_behv=>fc-f-read_only )
**
**                        %field-Gross      = COND #( WHEN header-Chk = abap_true THEN if_abap_behv=>fc-f-unrestricted ELSE if_abap_behv=>fc-f-read_only )
**                        %field-Tare       = COND #( WHEN header-Chk = abap_true THEN if_abap_behv=>fc-f-unrestricted ELSE if_abap_behv=>fc-f-read_only )
**                      ) ).
*  ENDMETHOD.

  METHOD zprint.
    DATA lo_pfd TYPE REF TO zcl_gatentry_hdr. "<-write your logic class

    CREATE OBJECT lo_pfd.

    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE "<-write your interface name
    ENTITY hdr "<-write your interface name
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(lw_result).

      DATA : update_lines TYPE TABLE FOR UPDATE zi_gateentry_hdr, "<-write your interface name
             update_line  TYPE STRUCTURE FOR UPDATE zi_gateentry_hdr. "<-write your interface name

      update_line-%tky = lw_result-%tky.
      update_line-base64 = 'A'.

      IF update_line-base64 IS NOT INITIAL.

        APPEND update_line TO update_lines.

        MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE "<-write your interface name
        ENTITY hdr "<-write your interface behaviour definition name
        UPDATE
        FIELDS ( base64 )
        WITH update_lines
        REPORTED reported
        FAILED failed
        MAPPED mapped.

        READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE ENTITY hdr "<-write your interface name and behaviour definition name
        ALL FIELDS WITH CORRESPONDING #( lt_result ) RESULT DATA(lt_final).

        result = VALUE #( FOR lw_final IN lt_final ( %tky = lw_final-%tky
        %param = lw_final ) ).

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
        %msg = new_message_with_text(
        severity = if_abap_behv_message=>severity-success
        text = 'PDF Generated!, Please Wait for 30 Sec' )
        ) TO reported-hdr. "<-write your interface behaviour definition name

      ELSE.

      ENDIF.
    ENDLOOP.
  ENDMETHOD..


*  METHOD earlynumbering_create.
*
*    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_entities>).
*      APPEND CORRESPONDING #( <fs_entities> ) TO mapped-hdr
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

  METHOD creategrn.

    " 1. Read Header Data
    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
      ENTITY hdr
        FIELDS ( plant net )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).
    IF lt_headers IS INITIAL.
      RETURN.
    ENDIF.
    DATA(ls_header) = lt_headers[ 1 ].
    DATA(lv_plant) = ls_header-plant.
    " 2. Read Item Data
    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
      ENTITY hdr BY \_adv_item
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).
    IF lt_items IS INITIAL.
      " TODO: Handle error - no items to post
      RETURN.
    ENDIF.

     DATA: lv_total_qty TYPE p DECIMALS 3 VALUE 0,
          lv_has_error TYPE abap_bool VALUE abap_false.
    data(l_c) = lines( lt_items )   .
    DATA : lv_pack TYPE zi_gateentry_hdr-pack.

    LOOP AT lt_items INTO DATA(ls_val_item).
      CLEAR LV_PACK.
      if ls_val_item-Uom = 'KG'.
        LV_PACK = ls_val_item-qty *  '0.001'.
      ELSE.
        LV_PACK =  ls_val_item-qty.
      ENDIF.

      lv_total_qty = lv_total_qty + LV_PACK. "ls_val_item-qty.

      " Check 1: If any Individual line quantity exceeds Header Net Weight
      if l_c = '1'.
      IF ls_val_item-ReceivedQty ne ls_header-net.
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-hdr.
        APPEND VALUE #( %tky = ls_header-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = |Line item { ls_val_item-ebelp } Qty ({ ls_val_item-qty }) exceeds Header Net Weight ({ ls_header-net })| )
                      ) TO reported-hdr.
        lv_has_error = abap_true.
      ENDIF.
      endif.
    ENDLOOP.
    " Check 2: (Optional but recommended) If the SUM of all item quantities exceeds Header Net Weight
    if l_c > '1'.
    IF lv_total_qty ne ls_header-net.
      APPEND VALUE #( %tky = ls_header-%tky ) TO failed-hdr.
      APPEND VALUE #( %tky = ls_header-%tky
                      %msg = new_message_with_text(
                               severity = if_abap_behv_message=>severity-error
                               text     = |Total Item Qty ({ lv_total_qty }) exceeds Header Net Weight ({ ls_header-net })| )
                    ) TO reported-hdr.
      lv_has_error = abap_true.
    ENDIF.
    endif.
    IF lv_has_error = abap_true.
      RETURN. " Do not proceed with GRN creation if validation fails
    ENDIF.

    DATA: lt_poparallel TYPE cl_abap_parallel=>t_in_inst_tab.
    DATA(lo_proc) = NEW cl_abap_parallel( p_percentage = 30 ).
    " -------------------------------------------------------------------------- "
    " START OF NEW LOGIC: Group items by Purchase Order (ebeln)
    " -------------------------------------------------------------------------- "
    DATA: lt_unique_pos LIKE lt_items.
    lt_unique_pos = lt_items.
    SORT lt_unique_pos BY ebeln.
    DELETE ADJACENT DUPLICATES FROM lt_unique_pos COMPARING ebeln.
    " Loop through each unique PO number
    LOOP AT lt_unique_pos INTO DATA(ls_unique_po).
      DATA: lt_items_for_po LIKE lt_items.
      CLEAR lt_items_for_po.

      " Gather all items belonging to this specific PO
      LOOP AT lt_items INTO DATA(ls_item) WHERE ebeln = ls_unique_po-ebeln.
        APPEND ls_item TO lt_items_for_po.
      ENDLOOP.
      " Enqueue a separate BAPI process call for each unique PO
      INSERT NEW zbp_gate_boparallel(
        lt_po_details  = CORRESPONDING #( lt_headers )
        lt_po_details1 = CORRESPONDING #( lt_items_for_po )
        lt_po = CORRESPONDING #( lt_items )
      ) INTO TABLE lt_poparallel.
    ENDLOOP.
    " -------------------------------------------------------------------------- "
    IF lt_poparallel IS NOT INITIAL.
      lo_proc->run_inst( EXPORTING p_in_tab = lt_poparallel
                                   p_debug  = abap_false
                         IMPORTING p_out_tab = DATA(lt_finished1) ).
      DATA: update_lines TYPE TABLE FOR UPDATE zi_gateentry_hdr,
            update_line  TYPE STRUCTURE FOR UPDATE zi_gateentry_hdr.

      DATA: lv_first_mblnr TYPE string,
            lv_first_gjahr TYPE string.
      " Process all parallel results (could be multiple GRNs now!)
      LOOP AT lt_finished1 INTO DATA(ls_finished).
        DATA(lo_instance)  = CAST zbp_gate_boparallel( ls_finished-inst ).
        DATA(lt_generated) = lo_instance->it_po_final.

        READ TABLE lt_generated INTO DATA(w_g) INDEX 1.
        IF sy-subrc = 0.
          IF w_g-mblnr IS NOT INITIAL.

            " Since the header can only store 1 GRN, we assign the very first one we receive
            IF lv_first_mblnr IS INITIAL.
              lv_first_mblnr = w_g-mblnr.
              lv_first_gjahr = w_g-gjahr.
            ENDIF.

            " Display success message for EVERY GRN created
            DATA(lv_success_msg) = |{ w_g-mblnr } created successfully.|.
            APPEND VALUE #( %msg = new_message_with_text(
                                      severity = if_abap_behv_message=>severity-success
                                      text     = lv_success_msg )
                           ) TO reported-hdr.
          ELSE.
            SELECT SINGLE mess
               FROM ztgate_in_log
               WHERE zgate = @w_g-zgate
               INTO @DATA(w_r1).

            DATA(lv_error_msg) = |Error : { w_r1 }|.
            APPEND VALUE #( %msg = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-error
                                     text     = lv_error_msg )
                          ) TO reported-hdr.
          ENDIF.
        ENDIF.
      ENDLOOP.
      " Update the header record with the first GRN Document Number
      IF lv_first_mblnr IS NOT INITIAL.
        LOOP AT keys INTO DATA(key).
          IF line_exists( lt_headers[ zid = key-zid ] ).
            update_line-%tky   = key-%tky.
            update_line-mblnr  = lv_first_mblnr.
            update_line-gjahr  = lv_first_gjahr.
            APPEND update_line TO update_lines.
          ENDIF.
        ENDLOOP.
        IF update_lines IS NOT INITIAL.
          MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
            ENTITY hdr
              UPDATE
                FIELDS ( mblnr gjahr )
                WITH update_lines
                REPORTED DATA(reported1)
                FAILED DATA(failed1)
                MAPPED DATA(mapped1).
        ENDIF.
          DATA: lt_update_items TYPE TABLE FOR UPDATE zi_gateentry_itm,
              ls_update_item  TYPE STRUCTURE FOR UPDATE zi_gateentry_itm.
        " Loop through all previously read items and prepare them for update
        LOOP AT lt_items INTO DATA(ls_item_upd).
          CLEAR ls_update_item.
          ls_update_item-%tky  = ls_item_upd-%tky.
          ls_update_item-mblnr = lv_first_mblnr.
          ls_update_item-gjahr = lv_first_gjahr.
          APPEND ls_update_item TO lt_update_items.
        ENDLOOP.
        " Update the items in the database
        IF lt_update_items IS NOT INITIAL.
          MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
            ENTITY item
              UPDATE
                FIELDS ( mblnr gjahr )
                WITH lt_update_items
                REPORTED DATA(reported_item)
                FAILED DATA(failed_item)
                MAPPED DATA(mapped_item).
        ENDIF.
        " -------------------------------------------------------------------------- "

      ENDIF.

      ENDIF.
*    ENDIF.
    " Update action result payload to reflect changes to the UI
    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
      ENTITY hdr
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result_hdr).
    result = VALUE #( FOR result_hdr IN lt_result_hdr
                       ( %tky   = result_hdr-%tky
                         %param = result_hdr ) ).

*    " 1. Read Header Data
*    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
*      ENTITY hdr
*        FIELDS ( plant Net )
*        WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_headers).
*
*    IF lt_headers IS INITIAL.
*      RETURN.
*    ENDIF.
*
*    DATA(ls_header) = lt_headers[ 1 ].
*    DATA(lv_plant) = ls_header-plant.
*
*    " 2. Read Item Data
*    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
*      ENTITY hdr BY \_adv_item
*        ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_items).
*
*    IF lt_items IS INITIAL.
*      " TODO: Handle error - no items to post
*      RETURN.
*    ENDIF.
*    DATA: lt_poparallel TYPE cl_abap_parallel=>t_in_inst_tab .
*    DATA(lo_proc) = NEW cl_abap_parallel( p_percentage = 30 )  .
*      INSERT NEW zbp_gate_boparallel(  lt_po_details = CORRESPONDING #( lt_headers )
*                                       lt_po_details1 = CORRESPONDING #( lt_items )       )
*        INTO TABLE lt_poparallel.
*
*      IF lt_poparallel IS NOT INITIAL .
*
*        lo_proc->run_inst(  EXPORTING p_in_tab = lt_poparallel
*                                     p_debug = abap_false
*                            IMPORTING p_out_tab = DATA(lt_finished1)  ).
*
*
*        READ TABLE lt_finished1 INTO DATA(ls_finished) INDEX 1.
*        DATA(lo_instance) = CAST zbp_gate_boparallel( ls_finished-inst ).
*        DATA(lt_generated) = lo_instance->it_po_final.
*
**                READ TABLE lt_finished INTO DATA(ls_finished) INDEX 1.
**        DATA(lo_instance) = CAST zbp_parallel( ls_finished-inst ).
**        DATA(lt_generated) = lo_instance->it_po_final.
*
**        MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
**   ENTITY hdr
**   UPDATE FIELDS ( zgate )
**   WITH VALUE #(
**     FOR ls IN lt_generated (
**       %key-zid = ls-zid
**       zgate    = ls-zgate
**       %control-zgate = if_abap_behv=>mk-on
**     )
**   ).
*    read table lt_generated into data(w_g) inDEX 1.
*    DATA : update_lines TYPE TABLE FOR UPDATE ZI_GATEENTRY_hdr,
*           update_line  TYPE STRUCTURE FOR UPDATE ZI_GATEENTRY_hdr.
*    LOOP AT keys INTO DATA(key).
*              IF line_exists( lt_headers[ zid = key-zid
*                                        ] ).
*                update_line-%tky                   = key-%tky.
*                update_line-mblnr                  = w_g-mblnr.
*                update_line-gjahr                  = w_g-gjahr.
*                APPEND update_line TO update_lines.
*              ENDIF.
*            ENDLOOP.
*    MODIFY ENTITIES OF ZI_GATEENTRY_hdr IN LOCAL MODE
*                  ENTITY hdr
*                    UPDATE
*                      FIELDS ( mblnr gjahr )
*                      WITH update_lines
*                      REPORTED data(reported1)
*                      FAILED data(failed1)
*                      MAPPED data(mapped1).
*    endif.
*    IF w_g-mblnr IS NOT INITIAL.
*            DATA(lv_success_msg) = | { w_g-mblnr } created successfully.|.
*            APPEND VALUE #( %msg = new_message_with_text(
*                                      severity = if_abap_behv_message=>severity-success
*                                      text = lv_success_msg )
*                           ) TO reported-hdr.
*          ELSE.
*            SELECT SINGLE mess
*               FROM ztgate_in_log
*               WHERE zgate =  @w_g-zgate
**               AND operation =   @w_f-operation
*               INTO @DATA(w_r1).
**            w_f-mess = w_r1.
*            DATA(lv_error_msg) = |Error : { w_r1 } |.
*            " Error Message
*            APPEND VALUE #( %msg = new_message_with_text(
*                                     severity = if_abap_behv_message=>severity-error
*                                     text = lv_error_msg )
*                          ) TO reported-hdr.
*          ENDIF.
*     READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
*  ENTITY hdr
*    ALL FIELDS WITH CORRESPONDING #( keys )
*  RESULT DATA(lt_result_hdr).
*result = VALUE #( FOR result_hdr IN lt_result_hdr
*                   ( %tky   = result_hdr-%tky
*                     %param = result_hdr ) ).
**     IF lv_mblnr IS NOT INITIAL.
**      MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
**        ENTITY hdr
**          UPDATE FIELDS ( mblnr gjahr )
**          WITH VALUE #( ( %tky  = ls_key-%tky   " <-- Add the key here
**                          mblnr = lv_mblnr
**                          gjahr = lv_gjahr ) ).
**    ENDIF.
**   IF ls_create_failed IS INITIAL.
**      " Fixed: Read the updated entity and populate the action result
**      READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
**        ENTITY hdr
**          ALL FIELDS WITH CORRESPONDING #( keys )
**        RESULT DATA(lt_result_read).
**      result = VALUE #( FOR ls_read IN lt_result_read
**                        ( %tky   = ls_read-%tky
**                          %param = ls_read ) ).
**    ELSE.
**      " Optional: pass failures to UI if needed
**    ENDIF.

    " TODO: Handle Success/Failure
  ENDMETHOD.

  METHOD calculatenet.

    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
 ENTITY hdr
   FIELDS ( gross tare pack )
   WITH CORRESPONDING #( keys )
 RESULT DATA(lt_headers).

    CHECK lt_headers IS NOT INITIAL.
    READ TABLE lt_headers INTO DATA(wa_hdr) INDEX 1.
    GET TIME STAMP FIELD DATA(lv_ts).

    DATA lv_tz TYPE timezone.
    lv_tz = 'INDIA'. " Default timezone if user tz is not maintained


    DATA: lv_current_date TYPE d,
          lv_current_time TYPE t.
    IF wa_hdr-tare IS NOT INITIAL AND wa_hdr-gateoutdt IS INITIAL.
      CONVERT TIME STAMP lv_ts TIME ZONE lv_tz
              INTO DATE lv_current_date
                   TIME lv_current_time.
    ENDIF.
    DATA : lv_pack TYPE zi_gateentry_hdr-pack.
    CLEAR lv_pack.
    lv_pack = wa_hdr-pack * '0.001'.
    IF wa_hdr-gateoutdt IS NOT INITIAL.
      lv_current_date = wa_hdr-gateoutdt.
      lv_current_time = wa_hdr-gateoutout.
    ENDIF.
    MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
      ENTITY hdr
        UPDATE FIELDS ( net gateoutdt gateoutout )
        WITH VALUE #(
          FOR header IN lt_headers
          (
            %tky = header-%tky
            net  = COND #(
                     WHEN header-gross IS NOT INITIAL
                      AND header-tare  IS NOT INITIAL
                     THEN header-gross - header-tare - lv_pack "header-pack
                     ELSE 0
                   )
            gateoutdt = lv_current_date
            gateoutout = lv_current_time
            %control-net = if_abap_behv=>mk-on   " 🔥 IMPORTANT
            %control-gateoutdt = if_abap_behv=>mk-on
            %control-gateoutout = if_abap_behv=>mk-on
          )
        )
        REPORTED DATA(lt_reported)
        FAILED   DATA(lt_failed).

    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
      ENTITY hdr BY \_adv_item
        FIELDS ( ebeln ebelp )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    IF lt_items IS NOT INITIAL.
      IF wa_hdr-gross IS NOT INITIAL AND wa_hdr-tare IS NOT INITIAL.
        MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
          ENTITY item
            UPDATE FIELDS ( receivedqty )
            WITH VALUE #( FOR item IN lt_items (
                            %tky        = item-%tky
                            receivedqty = wa_hdr-gross - wa_hdr-tare - lv_pack "wa_hdr-pack
                             %control-receivedqty = if_abap_behv=>mk-on
                          ) ).
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD setdefaults.

    DATA: nr_number     TYPE cl_numberrange_runtime=>nr_number.
    DATA : lv_quantity TYPE i VALUE '00000000000000000001'.
    DATA: lt_poparallel TYPE cl_abap_parallel=>t_in_inst_tab .
    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
    ENTITY hdr
      ALL FIELDS
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_data).
    READ TABLE lt_data INTO DATA(w_data) INDEX 1.
    IF w_data-zgate IS INITIAL.
      DATA(lo_proc) = NEW cl_abap_parallel( p_percentage = 30 )  .
      INSERT NEW zbp_parallel(  lt_po_details = CORRESPONDING #( lt_data )  )
        INTO TABLE lt_poparallel.

      IF lt_poparallel IS NOT INITIAL .

        lo_proc->run_inst(  EXPORTING p_in_tab = lt_poparallel
                                     p_debug = abap_false
                            IMPORTING p_out_tab = DATA(lt_finished)  ).

        READ TABLE lt_finished INTO DATA(ls_finished) INDEX 1.
        DATA(lo_instance) = CAST zbp_parallel( ls_finished-inst ).
        DATA(lt_generated) = lo_instance->it_po_final.

        READ TABLE lt_generated INTO DATA(w_g) INDEX 1.
        DATA : update_lines TYPE TABLE FOR UPDATE zi_gateentry_hdr,
               update_line  TYPE STRUCTURE FOR UPDATE zi_gateentry_hdr.
        LOOP AT keys INTO DATA(key).
          IF line_exists( lt_data[ zid = key-zid
                                    ] ).
            update_line-%tky                   = key-%tky.
            update_line-zgate                  = w_g-zgate.
            APPEND update_line TO update_lines.
          ENDIF.
        ENDLOOP.
        MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
                      ENTITY hdr
                        UPDATE
                          FIELDS ( zgate )
                          WITH update_lines
                          REPORTED DATA(reported1)
                          FAILED DATA(failed1)
                          MAPPED DATA(mapped1).
      ENDIF.
    ENDIF.

    IF sy-subrc = 0.

    ENDIF.

  ENDMETHOD.

  METHOD ref.

    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
    ENTITY hdr
      ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_headers).

    " 2. Read Item Data
    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
      ENTITY hdr BY \_adv_item
        ALL FIELDS WITH VALUE #( FOR header IN lt_headers ( %tky = header-%tky ) )
      RESULT DATA(lt_items).

    READ TABLE lt_headers INTO DATA(w_hdr) INDEX  1.
    DATA : lv_pack TYPE zi_gateentry_hdr-pack.
    CLEAR lv_pack.
    lv_pack = w_hdr-pack * '0.001'.
    MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
     ENTITY hdr
       UPDATE FIELDS ( net )
       WITH VALUE #( FOR header IN lt_headers (
                       %tky = header-%tky
                        net  = COND #(
                     WHEN header-gross IS NOT INITIAL
                      AND header-tare  IS NOT INITIAL
                     THEN header-gross - header-tare - lv_pack " header-pack
                     ELSE 0
                   )
*                       net  = header-gross - header-tare -
*                          header-pack
                     ) ).

    DATA: lt_update TYPE TABLE FOR UPDATE zi_gateentry_hdr.
    DATA: lt_update1 TYPE TABLE FOR UPDATE zi_gateentry_hdr.
*
    LOOP AT lt_headers INTO DATA(ls_header).
      APPEND VALUE #(
            %tky = ls_header-%tky
*            net = ls_header-gross - ls_header-tare - lv_pack
             net  = COND #(
                     WHEN ls_header-gross IS NOT INITIAL
                      AND ls_header-tare  IS NOT INITIAL
                     THEN ls_header-gross - ls_header-tare - lv_pack " header-pack
                     ELSE 0
                   )
                        "  ls_header-pack
        ) TO lt_update.
    ENDLOOP.

    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
        ENTITY hdr
          UPDATE FIELDS ( net )
          WITH lt_update
        REPORTED DATA(lt_reported)
        FAILED DATA(lt_failed).

      READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
          ENTITY hdr
            ALL FIELDS WITH
            CORRESPONDING #( keys )
          RESULT DATA(result_read).
    ENDIF.
*    result = VALUE #( FOR result_order IN result_read ( %tky   = result_order-%tky
*                                                           %param = result_order ) ).
    DATA(lv_item_count) = lines( lt_items ).
    DATA lt_update_itm TYPE TABLE FOR UPDATE zi_gateentry_itm.
    LOOP AT lt_items INTO DATA(ls_item) ."WHERE prod_order = ls_header-prod_order
      "  AND operation = ls_header-operation.
      if lv_item_count = 1.
      DATA(lv_new_qty) = w_hdr-net.
      else.
        lv_new_qty = ls_item-qty.
      endif.

      APPEND VALUE #(
         %tky = ls_item-%tky
         receivedqty = lv_new_qty
         %control = VALUE #(
         receivedqty = if_abap_behv=>mk-on
      ) ) TO lt_update_itm.
    ENDLOOP.

    IF lt_update_itm IS NOT INITIAL.
      MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
       ENTITY item
         UPDATE FIELDS ( receivedqty )
         WITH lt_update_itm
       REPORTED DATA(lt_reported_itm)
       FAILED DATA(lt_failed_itm).


    ENDIF.
    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
        ENTITY item
          ALL FIELDS WITH
          CORRESPONDING #( keys )
        RESULT DATA(lt_items1).

    LOOP AT keys INTO DATA(ls_result_key).

      READ TABLE lt_headers INTO DATA(ls_header_result)
        WITH KEY zid = ls_result_key-zid .

      IF sy-subrc = 0.
        APPEND VALUE #(
          %cid_ref = ls_result_key-%cid_ref
          %tky     = ls_result_key-%tky
          %param   = CORRESPONDING #( ls_header_result )
        ) TO result.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD setgateindatetime.

    " 1. Read the newly created records
    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
      ENTITY hdr
        FIELDS ( gateindt gateinout ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_gate_entries).

    " 2. Remove any records where date/time might already be set
    " (if you allow manual input and only want to default if empty)
    DELETE lt_gate_entries WHERE ( gateindt IS NOT INITIAL AND gateinout IS NOT INITIAL )
                              OR gross <= 0.
*    DELETE lt_gate_entries WHERE gateindt IS NOT INITIAL AND gateinout IS NOT INITIAL.
    CHECK lt_gate_entries IS NOT INITIAL.

    " 3. Get current local date and time using the user's timezone
    GET TIME STAMP FIELD DATA(lv_ts).

    DATA lv_tz TYPE timezone.

    lv_tz = 'INDIA'. " Default timezone if user tz is not maintained



    DATA: lv_current_date TYPE d,
          lv_current_time TYPE t.

    CONVERT TIME STAMP lv_ts TIME ZONE lv_tz
            INTO DATE lv_current_date
                 TIME lv_current_time.

*    DATA(lv_time1) = lv_ts+8(6)." = lv_ts+8(6).
    " 4. Update the entities with the current date and time
    MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
      ENTITY hdr
        UPDATE
        FIELDS ( gateindt gateinout )
        WITH VALUE #( FOR rec IN lt_gate_entries (
                        %tky      = rec-%tky
                        gateindt  = lv_current_date
                        gateinout = lv_current_time
                      ) )
      REPORTED DATA(update_reported).

    " 5. Pass back any reported messages
**    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

    METHOD get_instance_features.

    " 1. Read Header Data
    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
      ENTITY hdr
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers)
      FAILED failed.

    READ TABLE lt_headers INTO DATA(ls_hdr) INDEX 1.

    " 2. Read Associated Line Items to check if a PO is present
    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
      ENTITY hdr BY \_adv_item
        FIELDS ( ebeln )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    " ====================================================================
    " 3. NEW LOGIC: Check if current logged-in user exists in ZUSER_ID
    " ====================================================================
    " Get current user ID (Standard RAP way)
    DATA(lv_current_user) = cl_abap_context_info=>get_user_technical_name( ).
    DATA: lv_user_allowed TYPE abap_bool VALUE abap_false.

    " Check the table for this user.
    " MAKE SURE to replace 'uname' with the actual field name in your zuser_id table
    SELECT SINGLE @abap_true
      FROM zuser_id WITH PRIVILEGED ACCESS
      WHERE user_id = @lv_current_user
      INTO @lv_user_allowed.

    " 4. Evaluate Features
    result = VALUE #( FOR ls_header IN lt_headers

      " Check if at least one item exists for the current header
      LET lv_has_items = xsdbool( line_exists( lt_items[ %tky-zid = ls_header-zid ] ) ) IN

      ( %tky = ls_header-%tky

        " -------------------------------------------------------------
        " NEW LOGIC: Map dynamic field control for 'Chk'
        " The field is only editable if the user exists in ZUSER_ID
        " -------------------------------------------------------------
        %field-chk = COND #(
          WHEN lv_user_allowed = abap_true
            THEN if_abap_behv=>fc-f-unrestricted
            ELSE if_abap_behv=>fc-f-read_only
        )

        " Map dynamic field control for Tare weight
        %field-tare = COND #(
          WHEN lv_has_items = abap_false
            THEN if_abap_behv=>fc-f-read_only
          ELSE if_abap_behv=>fc-f-unrestricted
        )

         %field-gross = COND #( WHEN ls_hdr-chk = abap_true AND ( ls_hdr-tare IS NOT INITIAL OR ls_hdr-gross = 0 )
                               THEN if_abap_behv=>fc-f-unrestricted
                               ELSE if_abap_behv=>fc-f-read_only )

         %update = COND #( WHEN ls_hdr-mblnr IS NOT INITIAL
                          THEN if_abap_behv=>fc-o-disabled
                          ELSE if_abap_behv=>fc-o-enabled )

        %action-creategrn = COND #( WHEN ls_hdr-mblnr IS NOT INITIAL
                              THEN if_abap_behv=>fc-o-disabled
                              ELSE if_abap_behv=>fc-o-enabled )

        %action-fetcht = COND #( WHEN ls_hdr-mblnr IS NOT INITIAL
                                 THEN if_abap_behv=>fc-o-disabled
                                 ELSE if_abap_behv=>fc-o-enabled )
      )
    ).

  ENDMETHOD.

*  METHOD get_instance_features.
*
*    " 1. Read Header Data (Include fields you already check, like CaptureManual, Tare, etc.)
*    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE  " <--- Replace with your actual BO name
*      ENTITY hdr                                  " <--- Replace with your actual Header alias
*        ALL FIELDS
*        WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_headers)
*      FAILED failed.
*
*    READ TABLE lt_headers INTO DATA(ls_hdr) INDEX 1.
**      DATA(ls_hdr) = VALUE #( lt_headers[ %tky = ls_key-%tky ] OPTIONAL ).
*    " 2. Read Associated Line Items to check if a PO is present
*    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
*      ENTITY hdr BY \_adv_item                        " <--- Replace \_Item with your actual association name
*        FIELDS ( ebeln )                             " Just need to read a field to see if it exists
*        WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_items).
*    " 3. Evaluate Features
*    result = VALUE #( FOR ls_header IN lt_headers
*
*      " Check if at least one item exists for the current header
*      " Note: Replace 'zgate' with your actual key field name linking header and item
*      LET lv_has_items = xsdbool( line_exists( lt_items[ %tky-zid = ls_header-zid ] ) ) IN
*
*      ( %tky = ls_header-%tky
*
*        " Map dynamic field control for Tare weight
*        %field-tare = COND #(
*          " NEW LOGIC: If no line items are present, the field is locked
*          WHEN lv_has_items = abap_false
*            THEN if_abap_behv=>fc-f-read_only
*
*          " EXISTING LOGIC: If items are present, put your existing Tare logic here
*          " (For example, checking if CaptureManual is active)
*          " WHEN ls_header-CaptureManual = abap_true AND ls_header-Tare IS INITIAL
*          "   THEN if_abap_behv=>fc-f-unrestricted
*
*          " Fallback if items exist and existing logic passes
*          ELSE if_abap_behv=>fc-f-unrestricted
*        )
*
*         %field-gross = COND #( WHEN ls_hdr-chk = abap_true AND ( ls_hdr-tare IS NOT INITIAL OR ls_hdr-gross = 0 )
*                               THEN if_abap_behv=>fc-f-unrestricted
*                               ELSE if_abap_behv=>fc-f-read_only )
*          %update = COND #( WHEN ls_hdr-mblnr IS NOT INITIAL
*                          THEN if_abap_behv=>fc-o-disabled
*                          ELSE if_abap_behv=>fc-o-enabled )
*
**        " Hide ref button if Gateindt is empty
*        %action-creategrn = COND #( WHEN ls_hdr-mblnr IS NOT INITIAL
*                              THEN if_abap_behv=>fc-o-disabled
*                              ELSE if_abap_behv=>fc-o-enabled )
*
*        " Hide FetchT button if Gateindt is empty
*        %action-fetcht = COND #( WHEN ls_hdr-mblnr IS NOT INITIAL
*                                 THEN if_abap_behv=>fc-o-disabled
*                                 ELSE if_abap_behv=>fc-o-enabled )
*
*      )
*    ).
*
*  ENDMETHOD.

  METHOD fetcht.
    DATA: lv_xml_result_str TYPE string,
          lv_response       TYPE string,
          lv_doc_status     TYPE string,
          lv_error_response TYPE string.
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
          READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
            ENTITY hdr
              FIELDS ( gross ) WITH CORRESPONDING #( keys )
            RESULT DATA(lt_existing_hdr).

          " Update the entity with the new Weight
          " If Gross is initial, update Gross. If Gross is already filled, update Tare.
          LOOP AT lt_existing_hdr INTO DATA(ls_check_hdr).
            IF ls_check_hdr-gross IS INITIAL OR ls_check_hdr-gross = 0.
              MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
                ENTITY hdr
                  UPDATE FIELDS ( gross )
                  WITH VALUE #( ( %tky = ls_check_hdr-%tky gross = CONV #( lv_weight_str ) ) )
                REPORTED DATA(lt_rep_gross).
              reported = CORRESPONDING #( DEEP lt_rep_gross ).
            ELSE.
              MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
                ENTITY hdr
                  UPDATE FIELDS ( tare )
                  WITH VALUE #( ( %tky = ls_check_hdr-%tky tare = CONV #( lv_weight_str ) ) )
                REPORTED DATA(lt_rep_tare).
              reported = CORRESPONDING #( DEEP lt_rep_tare ).
            ENDIF.
          ENDLOOP.

          " Read the updated entity back to result parameter
          READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
            ENTITY hdr
              ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_hdr).

          " Map it to the $self entity result
          result = VALUE #( FOR ls_hdr IN lt_hdr ( %tky = ls_hdr-%tky %param = CORRESPONDING #( ls_hdr ) ) ).

          " Pass upstream messages
*          reported = CORRESPONDING #( DEEP lt_reported ).
        ENDIF.
      CATCH cx_http_dest_provider_error.
    ENDTRY.
    IF sy-subrc = 0.

    ENDIF.

  ENDMETHOD.

  METHOD ValidateGrossTare.

    " 1. Read the Gross and Tare fields from the Header
    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
      ENTITY hdr
        FIELDS ( Gross Tare )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).
    " 2. Loop through the headers and perform the validation
    LOOP AT lt_headers INTO DATA(ls_hdr).

      " If Gross weight is less than Tare weight, it's invalid
      if ls_hdr-Gross is nOT iNITIAL and ls_hdr-Tare is nOT iNITIAL.
      IF ls_hdr-Gross < ls_hdr-Tare.

        " Mark the transaction as failed
        APPEND VALUE #( %tky = ls_hdr-%tky ) TO failed-hdr.
        " Send an error message back to the Fiori UI and highlight the fields
        APPEND VALUE #(
          %tky           = ls_hdr-%tky
          %msg           = new_message_with_text(
                             severity = if_abap_behv_message=>severity-error
                             text     = 'Gross weight cannot be less than Tare weight.' )
          %element-gross = if_abap_behv=>mk-on
          %element-tare  = if_abap_behv=>mk-on
        ) TO reported-hdr.

      ENDIF.
     endif.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calculateitemdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~calculateitemdetails.
    METHODS validatestoragelocation FOR VALIDATE ON SAVE
      IMPORTING keys FOR item~validatestoragelocation.
    METHODS ebeln FOR VALIDATE ON SAVE
      IMPORTING keys FOR item~ebeln.
    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE item.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR item RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR item RESULT result.

    METHODS save0 FOR MODIFY
      IMPORTING keys FOR ACTION item~save0 RESULT result.

ENDCLASS.

CLASS lhc_item IMPLEMENTATION.

  METHOD calculateitemdetails.

    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
     ENTITY hdr
       FIELDS ( zgate gross tare pack )
       WITH CORRESPONDING #( keys )
     RESULT DATA(lt_headers).

    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
      ENTITY item
        FIELDS ( ebeln ebelp )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    CHECK lt_items IS NOT INITIAL.

    LOOP AT lt_items INTO DATA(ls_item).
      " 1. ALWAYS clear out previous UI error messages for this specific item first
      APPEND VALUE #( %tky = ls_item-%tky %state_area = 'PO_VALIDATION' ) TO reported-item.

      IF ls_item-ebeln IS NOT INITIAL AND ls_item-ebelp IS NOT INITIAL.

        " 2. Handle missing leading zeros which will cause DB fetches to fail!
        DATA lv_ebeln TYPE i_purchaseorderitemapi01-purchaseorder.
        DATA lv_ebelp TYPE i_purchaseorderitemapi01-purchaseorderitem.
        lv_ebeln = |{ ls_item-ebeln ALPHA = IN }|.
        lv_ebelp = |{ ls_item-ebelp ALPHA = IN }|.

        " 3. Use WITH PRIVILEGED ACCESS to bypass unauthorized DCL rows
        SELECT SINGLE FROM i_purchaseorderitemapi01 WITH PRIVILEGED ACCESS
          FIELDS material, purchaseorderitemtext, orderquantity, purchaseorderquantityunit, storagelocation, iscompletelydelivered
          WHERE purchaseorder = @lv_ebeln
            AND purchaseorderitem = @lv_ebelp
          INTO @DATA(ls_po_data).

        IF sy-subrc = 0.
          IF ls_po_data-iscompletelydelivered = 'X' OR ls_po_data-iscompletelydelivered = abap_true.
            " Add state area here so the message sticks around
            APPEND VALUE #( %tky = ls_item-%tky
                            %state_area = 'PO_VALIDATION'
                            %msg = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-error
                                     text     = |PO { ls_item-ebeln } Item { ls_item-ebelp } is completely delivered!| )
                            %element-ebeln = if_abap_behv=>mk-on
                            %element-ebelp = if_abap_behv=>mk-on
                          ) TO reported-item.
            CONTINUE.
          ENDIF.

          SELECT SINGLE FROM i_purchaseorderapi01 WITH PRIVILEGED ACCESS
              FIELDS supplier
              WHERE purchaseorder = @lv_ebeln
            INTO @DATA(ls_po_sup).

          SELECT SINGLE FROM i_supplier WITH PRIVILEGED ACCESS
              FIELDS  supplier, supplierfullname
              WHERE supplier = @ls_po_sup
              INTO @DATA(lv_name).

          READ TABLE lt_headers INTO DATA(w_hdr4) INDEX 1.

          " Use %control so Fiori Elements syncs the values properly
          MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
            ENTITY item
              UPDATE FIELDS ( zgate mat matdesc orderqty uom vend name storage receivedqty )
              WITH VALUE #( ( %tky = ls_item-%tky
                              zgate = w_hdr4-zgate
                              mat = ls_po_data-material
                              matdesc = ls_po_data-purchaseorderitemtext
                              orderqty = ls_po_data-orderquantity
                              uom = ls_po_data-purchaseorderquantityunit
                              vend = ls_po_sup
                              name = lv_name-supplierfullname
                              storage = ls_po_data-storagelocation
                              %control = VALUE #(
                                  zgate = if_abap_behv=>mk-on
                                  mat = if_abap_behv=>mk-on
                                  matdesc = if_abap_behv=>mk-on
                                  orderqty = if_abap_behv=>mk-on
                                  uom = if_abap_behv=>mk-on
                                  vend = if_abap_behv=>mk-on
                                  name = if_abap_behv=>mk-on
                                  storage = if_abap_behv=>mk-on
                              )
                            ) )
             REPORTED DATA(lt_report_update).

          " Pass reported map back
          " reported = CORRESPONDING #( DEEP lt_report_update ).  <-- Replaced with appending so we don't wipe out the clear statement
*          LOOP AT lt_report_update-item INTO DATA(ls_rep).
*            APPEND ls_rep TO reported-item.
*          ENDLOOP.
*          APPEND LINES OF CORRESPONDING #( lt_report_update-item ) TO reported-item.
          " FIX: Use explicit type for CORRESPONDING to safely append the deep structures
*          DATA(lt_rep_item) = CORRESPONDING #( lt_report_update-item MAPPING %tky = %tky ). " Basic mapping sometimes needed for deep tables

          " The safest approach in RAP behavior implementations when types mismatch is a standard loop assigning fields explicitly:
          LOOP AT lt_report_update-item INTO DATA(ls_rep).
            APPEND VALUE #( %tky = ls_rep-%tky
                            %msg = ls_rep-%msg
                            %element-ebeln = ls_rep-%element-ebeln
                            %element-ebelp = ls_rep-%element-ebelp
                            %element-zgate = ls_rep-%element-zgate
                            %element-mat = ls_rep-%element-mat
                            %element-matdesc = ls_rep-%element-matdesc
                            %element-orderqty = ls_rep-%element-orderqty
                            %element-uom = ls_rep-%element-uom
                            %element-vend = ls_rep-%element-vend
                            %element-name = ls_rep-%element-name
                            %element-storage = ls_rep-%element-storage ) TO reported-item.
          ENDLOOP.

          IF w_hdr4-gross IS NOT INITIAL AND w_hdr4-tare IS NOT INITIAL.
            " Add conversion for packing weight to match header calculation

            DATA: lv_pack_itm TYPE p LENGTH 16 DECIMALS 3.
            lv_pack_itm = w_hdr4-pack * '0.001'.

            MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
          ENTITY item
            UPDATE FIELDS ( receivedqty )
            WITH VALUE #( FOR item IN lt_items (
                            %tky        = item-%tky
                            receivedqty = w_hdr4-gross - w_hdr4-tare - lv_pack_itm
                            %control-receivedqty = if_abap_behv=>mk-on
                          ) ).
          ENDIF.
          "13.3.26
*          IF w_hdr4-gross IS NOT INITIAL AND w_hdr4-tare IS NOT INITIAL.
*            MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
*          ENTITY item
*            UPDATE FIELDS ( receivedqty )
*            WITH VALUE #( FOR item IN lt_items (
*                            %tky        = item-%tky
*                            receivedqty = w_hdr4-gross - w_hdr4-tare - w_hdr4-pack
*                            %control-receivedqty = if_abap_behv=>mk-on
*                          ) ).
*          ENDIF.
        ELSE.
          " IMMEDIATELY ERROR THE UI AND WIPE THE FIELDS FOR INVALID PO
          APPEND VALUE #( %tky = ls_item-%tky
                          %state_area = 'PO_VALIDATION'
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = |PO { ls_item-ebeln } Item { ls_item-ebelp } does not exist.| )
                          %element-ebeln = if_abap_behv=>mk-on
                          %element-ebelp = if_abap_behv=>mk-on
                        ) TO reported-item.

          MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
            ENTITY item
              UPDATE FIELDS ( mat matdesc orderqty uom vend name storage receivedqty )
              WITH VALUE #( ( %tky    = ls_item-%tky
                              mat     = ''
                              matdesc = ''
                              orderqty = 0
                              uom     = ''
                              vend    = ''
                              name    = ''
                              storage = ''
                              receivedqty = 0
                              %control = VALUE #(
                                  mat = if_abap_behv=>mk-on
                                  matdesc = if_abap_behv=>mk-on
                                  orderqty = if_abap_behv=>mk-on
                                  uom = if_abap_behv=>mk-on
                                  vend = if_abap_behv=>mk-on
                                  name = if_abap_behv=>mk-on
                                  storage = if_abap_behv=>mk-on
                                  receivedqty = if_abap_behv=>mk-on
                              )
                            ) ).
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validatestoragelocation.

    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
ENTITY item
  FIELDS ( storage )
  WITH CORRESPONDING #( keys )
RESULT DATA(lt_items).

  ENDMETHOD.


  METHOD ebeln.

    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
   ENTITY item
   FIELDS ( ebeln ebelp zgate zid )
   WITH CORRESPONDING #( keys )
   RESULT DATA(lt_items).

    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
      ENTITY item
      BY \_adv_head
      FIELDS ( plant )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).

    LOOP AT lt_items INTO DATA(ls_item).

* Mandatory checks
      IF ls_item-ebeln IS INITIAL OR ls_item-ebelp IS INITIAL.

        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-item.

        IF ls_item-ebeln IS INITIAL.
          APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message_with_text(
                     severity = if_abap_behv_message=>severity-error
                     text     = 'Please Enter PO Number' )
            %element-ebeln = if_abap_behv=>mk-on
          ) TO reported-item.
        ENDIF.

        IF ls_item-ebelp IS INITIAL.
          APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message_with_text(
                     severity = if_abap_behv_message=>severity-error
                     text     = 'Please Enter PO Item' )
            %element-ebelp = if_abap_behv=>mk-on
          ) TO reported-item.
        ENDIF.

        CONTINUE.
      ENDIF.

* Validate PO item
      SELECT SINGLE plant
        FROM i_purchaseorderitemapi01 WITH PRIVILEGED ACCESS
        WHERE purchaseorder     = @ls_item-ebeln
        AND   purchaseorderitem = @ls_item-ebelp
        INTO @DATA(lv_po_plant).

      IF sy-subrc <> 0.

        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-item.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text = |PO { ls_item-ebeln } Item { ls_item-ebelp } does not exist| )
          %element-ebeln = if_abap_behv=>mk-on
          %element-ebelp = if_abap_behv=>mk-on
        ) TO reported-item.

        CONTINUE.
      ENDIF.

* Plant validation
      READ TABLE lt_headers INTO DATA(ls_header)
           WITH KEY zgate = ls_item-zgate
                    zid   = ls_item-zid.

      IF sy-subrc = 0 AND
         ls_header-plant IS NOT INITIAL AND
         ls_header-plant <> lv_po_plant.

        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-item.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text = |PO { ls_item-ebeln }/{ ls_item-ebelp } not in Plant { ls_header-plant }| )
          %element-ebeln = if_abap_behv=>mk-on
          %element-ebelp = if_abap_behv=>mk-on
        ) TO reported-item.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.
  METHOD precheck_update.

    LOOP AT entities INTO DATA(ls_entity1).

      IF ls_entity1-ebeln IS NOT INITIAL AND ls_entity1-ebelp IS INITIAL.

        APPEND VALUE #(
          %tky = ls_entity1-%tky
          %msg = new_message(
                    id = 'ZMSG'
                    number = '001'
                    v1 = 'Item number required for PO'
                    severity = if_abap_behv_message=>severity-error )
        ) TO reported-item.

      ENDIF.

    ENDLOOP.

    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
      ENTITY item
        FIELDS ( ebeln ebelp zgate zid )
        WITH CORRESPONDING #( entities )
      RESULT DATA(lt_items).

    LOOP AT entities INTO DATA(ls_entity).
      ASSIGN lt_items[ %tky = ls_entity-%tky ] TO FIELD-SYMBOL(<ls_item>).
      IF sy-subrc = 0.
        IF ls_entity-%control-ebeln = if_abap_behv=>mk-on.
          <ls_item>-ebeln = ls_entity-ebeln.
        ENDIF.
        IF ls_entity-%control-ebelp = if_abap_behv=>mk-on.
          <ls_item>-ebelp = ls_entity-ebelp.
        ENDIF.
      ENDIF.
    ENDLOOP.

    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
      ENTITY hdr
        FIELDS ( plant )
        WITH VALUE #( FOR item IN lt_items ( zid = item-zid ) )
      RESULT DATA(lt_headers).

    LOOP AT lt_items INTO DATA(ls_item_check).
      IF ls_item_check-ebeln IS INITIAL OR ls_item_check-ebelp IS INITIAL.
        APPEND VALUE #( %tky = ls_item_check-%tky ) TO failed-item.
        IF ls_item_check-ebeln IS INITIAL.
          APPEND VALUE #( %tky = ls_item_check-%tky
                          %state_area = 'PO_VALIDATION'
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = 'Please Enter PO Number'
                                 )
                          %element-ebeln = if_abap_behv=>mk-on ) TO reported-item.
        ENDIF.
        IF ls_item_check-ebelp IS INITIAL.
          APPEND VALUE #( %tky = ls_item_check-%tky
                          %state_area = 'PO_VALIDATION'
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = 'Please Enter PO Item'
                                 )
                          %element-ebelp = if_abap_behv=>mk-on ) TO reported-item.
        ENDIF.
        CONTINUE.
      ENDIF.

      SELECT SINGLE plant
        FROM i_purchaseorderitemapi01 WITH PRIVILEGED ACCESS
        WHERE purchaseorder = @ls_item_check-ebeln
          AND purchaseorderitem = @ls_item_check-ebelp
        INTO @DATA(lv_po_plant).

      IF sy-subrc = 0.
        READ TABLE lt_headers INTO DATA(ls_header)
          WITH KEY zgate = ls_item_check-zgate
                   zid   = ls_item_check-zid.

        IF sy-subrc = 0 AND ls_header-plant IS NOT INITIAL AND ls_header-plant <> lv_po_plant.
          APPEND VALUE #( %tky = ls_item_check-%tky ) TO failed-item.
          APPEND VALUE #( %tky = ls_item_check-%tky
                          %state_area = 'PO_VALIDATION'
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = |PO { ls_item_check-ebeln }/{ ls_item_check-ebelp } does not belong to Plant { ls_header-plant }| )
                          %element-ebeln = if_abap_behv=>mk-on
                          %element-ebelp = if_abap_behv=>mk-on
                        ) TO reported-item.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD save0.

  METHOD save0.

    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
      ENTITY hdr
        FIELDS ( zgate gross tare pack )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).

    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
      ENTITY item
        FIELDS ( ebeln ebelp )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    CHECK lt_items IS NOT INITIAL.

    LOOP AT lt_items INTO DATA(ls_item).
      IF ls_item-ebeln IS NOT INITIAL AND ls_item-ebelp IS NOT INITIAL.

        SELECT SINGLE FROM i_purchaseorderitemapi01
          FIELDS material, purchaseorderitemtext, orderquantity, purchaseorderquantityunit, storagelocation, iscompletelydelivered
          WHERE purchaseorder = @ls_item-ebeln
            AND purchaseorderitem = @ls_item-ebelp
          INTO @DATA(ls_po_data).

        IF ls_po_data-iscompletelydelivered = 'X' OR ls_po_data-iscompletelydelivered = abap_true.
          " Send an error message to the Fiori UI
          APPEND VALUE #( %tky = ls_item-%tky
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = |PO { ls_item-ebeln } Item { ls_item-ebelp } is completely delivered!| )
                        ) TO reported-item.

          " Skip the rest of the logic for this row so it doesn't populate the data
          CONTINUE.
        ENDIF.

        SELECT SINGLE FROM i_purchaseorderapi01
            FIELDS supplier
            WHERE purchaseorder = @ls_item-ebeln
          INTO @DATA(ls_po_sup).

        SELECT SINGLE FROM i_supplier
            FIELDS  supplier, supplierfullname
            WHERE supplier = @ls_po_sup
            INTO @DATA(lv_name).

*        IF sy-subrc = 0.
        READ TABLE lt_headers INTO DATA(w_hdr4) INDEX 1.
        MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
          ENTITY item
            UPDATE FIELDS ( zgate mat matdesc orderqty uom vend name storage receivedqty )
            WITH VALUE #( ( %tky    = ls_item-%tky
                            zgate   = w_hdr4-zgate
                            mat     = ls_po_data-material
                            matdesc = ls_po_data-purchaseorderitemtext
                            orderqty = ls_po_data-orderquantity
                            uom     = ls_po_data-purchaseorderquantityunit
                            vend    = ls_po_sup
                            name    = lv_name-supplierfullname
                            storage = ls_po_data-storagelocation
                            %control = VALUE #(
                              zgate   = if_abap_behv=>mk-on
                              mat     = if_abap_behv=>mk-on
                              matdesc = if_abap_behv=>mk-on
                              orderqty = if_abap_behv=>mk-on
                              uom     = if_abap_behv=>mk-on
                              vend    = if_abap_behv=>mk-on
                              name    = if_abap_behv=>mk-on
                              storage = if_abap_behv=>mk-on
                            ) ) ).

        IF w_hdr4-gross IS NOT INITIAL AND w_hdr4-tare IS NOT INITIAL.
          " Add conversion for packing weight to match header calculation

          DATA: lv_pack_itm2 TYPE p LENGTH 16 DECIMALS 3.
         lv_pack_itm2  = w_hdr4-pack * '0.001'.

          MODIFY ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
        ENTITY item
          UPDATE FIELDS ( receivedqty )
          WITH VALUE #( FOR item IN lt_items (
                          %tky        = item-%tky
                          receivedqty = w_hdr4-gross - w_hdr4-tare - lv_pack_itm2
                          %control-receivedqty = if_abap_behv=>mk-on
                        ) ).
        ENDIF.

      ENDIF.
    ENDLOOP.

    " Map self so the UI refreshes
    READ ENTITIES OF zi_gateentry_hdr IN LOCAL MODE
      ENTITY item
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item_res).

    result = VALUE #( FOR ls_item_res IN lt_item_res ( %tky = ls_item_res-%tky %param = CORRESPONDING #( ls_item_res ) ) ).

  ENDMETHOD.

*  METHOD validateqty.
*  ENDMETHOD.

ENDCLASS.
