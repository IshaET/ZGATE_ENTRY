CLASS zno_range DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    interfaces if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZNO_RANGE IMPLEMENTATION.


    METHOD if_oo_adt_classrun~main.

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
*    LV_JO =  |{ nr_number ALPHA = out }|.
*   LV_JO_OPT = |{ LV_JO ALPHA = in }|. // assigning number to local variable number
*   out->write( LV_JO_OPT ).
if sy-subrc = 0.

endif.
ENDMETHOD.
ENDCLASS.
