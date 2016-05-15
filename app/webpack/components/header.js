import $ from 'jquery';
import Bacon from 'baconjs';
$.fn.asEventStream = Bacon.$.asEventStream;

module.exports = ($element) => {
  let isMenuOpen =
    $element
      .asEventStream('click', '.main-header-menu-button')
      .scan(false, (value) => !value);

  isMenuOpen
    .assign($('.main-header-menu-button'), 'toggleClass', 'active');
  isMenuOpen
    .assign($element, 'toggleClass', 'controls-open');
};
