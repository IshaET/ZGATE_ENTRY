CLASS zc_f4_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

     INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZC_F4_CLASS IMPLEMENTATION.


    METHOD if_oo_adt_classrun~main.

         SELECT *  "#EC CI_NOWHERE
    FROM zdb_status
    INTO TABLE @DATA(lt_stat).
    IF  sy-subrc = 0.
      DELETE zdb_status FROM TABLE @lt_stat.
    ENDIF.

    CLEAR : lt_stat.

   lt_stat = VALUE #( ( id = 'R' name = 'RGP' )
                                  ( id = 'N' name = 'NRGP' )
                                   ).

    IF  lt_stat IS NOT INITIAL.
      INSERT zdb_status FROM TABLE @lt_stat.
      COMMIT WORK.
    ENDIF.

    ENDMETHOD.
ENDCLASS.
