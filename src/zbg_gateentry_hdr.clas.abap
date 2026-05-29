CLASS zbg_gateentry_hdr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_bgmc_operation .
    INTERFACES if_bgmc_op_single_tx_uncontr .
    INTERFACES if_serializable_object .

    METHODS constructor
      IMPORTING
        iv_gate  TYPE c.

  PROTECTED SECTION.
    DATA : im_gate TYPE c.

    METHODS modify
      RAISING
        cx_bgmc_operation.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZBG_GATEENTRY_HDR IMPLEMENTATION.


METHOD constructor.
    im_gate = iv_gate.
  ENDMETHOD.


  METHOD if_bgmc_op_single_tx_uncontr~execute.
    modify( ).
  ENDMETHOD.


  METHOD modify.
    DATA : wa_data TYPE ztgate_hdr.  "<-write your table name
    DATA :lv_pdftest TYPE string.
    DATA lo_pfd TYPE REF TO zcl_gatentry_hdr.  "<-write your logic class

    CREATE OBJECT lo_pfd.

    lo_pfd->get_pdf_64( EXPORTING io_gate = im_gate RECEIVING pdf_64 = DATA(pdf_64) ).

    wa_data-zgate = im_gate.
    wa_data-base64 = pdf_64.

    MODIFY ztgate_hdr FROM @wa_data.  "<-write your table name

  ENDMETHOD.
ENDCLASS.
