@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Image View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_IMAGE_VIEW as select from ztt_image
{
    key id as Id,
    text as Text,
    @Semantics.imageUrl: true
    pic_url as PicUrl
}
