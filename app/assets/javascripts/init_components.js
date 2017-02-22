$(document).ready(function() {
  // Attachinary
  $('.attachinary-input').attachinary();

  // Light Slider
  $("#light-slider").lightSlider({
    item: 1,
    mode: "fade",
    gallery: true,
    thumbItem: 8,
    galleryMargin: 10,
    thumbMargin: 10,
    currentPagerPosition: 'middle',
    prevHtml: '<i class="fa fa-arrow-circle-o-left fa-3x slider-control"></i>',
    nextHtml: '<i class="fa fa-arrow-circle-o-right fa-3x slider-control"></i>',
    responsive : []
  });
});
