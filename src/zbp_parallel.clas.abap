CLASS zbp_parallel DEFINITION
  PUBLIC

  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES tt_result TYPE STANDARD TABLE OF ztgate_hdr WITH EMPTY KEY.
    DATA: it_po_final  TYPE  tt_result,
          it_po_final1 TYPE  tt_result.
    INTERFACES if_serializable_object .
    INTERFACES if_abap_parallel .

    METHODS constructor
      IMPORTING
        lt_po_details TYPE tt_result.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZBP_PARALLEL IMPLEMENTATION.


    METHOD constructor.
    it_po_final = lt_po_details .
    it_po_final1 = lt_po_details .
  ENDMETHOD.


   METHOD if_abap_parallel~do.
      reaD TABLE it_po_final into data(w_final) index 1.
     DATA: nr_number     TYPE cl_numberrange_runtime=>nr_number.
*      DATA: LV_JO TYPE z_number .
*      DATA: LV_JO_OPT TYPE z_number.
TRY.
      CALL METHOD cl_numberrange_runtime=>number_get
        EXPORTING
*         ignore_buffer     =
          nr_range_nr = '01'
          object      = 'ZGATEENTRY'
          quantity    = 00000000000000000001
*         subobject   =
*         toyear      =
        IMPORTING
          number      = nr_number.
*     returncode        =
*     returned_quantity =

    CATCH cx_nr_object_not_found.
    CATCH cx_number_ranges.
  ENDTRY.
  if nr_number is nOT iNITIAL.
*    select single *
   loop AT it_po_final  ASSIGNING FIELD-SYMBOL(<fs_data>).

*        from ztgate_hdr
*        where zid = @w_final-zid
*        into @data(lv_no).
    data(l_gate) = nr_number+10(10).
    <fs_data>-zgate = l_gate.
    endLOOP.
*    zbp_i_gateentry_hdr=>mapped_journalentrytp-hdr =  w_final-zgate.


  endIF.

   endMETHOD.
ENDCLASS.
