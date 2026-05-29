CLASS zcl_fill_image_table DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FILL_IMAGE_TABLE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: lt_images TYPE TABLE OF ztt_image.

    " Clear existing data
    DELETE FROM ztt_image.   "#EC CI_NOWHERE

    " Append new values
    lt_images = VALUE #(
      ( id = '001' text = 'GATE' pic_url = 'https://img.freepik.com/premium-vector/truck-logo-vector_848918-13070.jpg?w=360' )
    ).

    INSERT ztt_image FROM TABLE @lt_images.

    IF sy-subrc = 0.
      out->write( |{ lines( lt_images ) } entries inserted successfully.| ).
    ELSE.
      out->write( 'Error inserting entries.' ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
