import $ from 'jquery';

module.exports = ($element) => {
  let isMenuOpen =
    $element
      .asEventStream('click', '.main-header-menu-button')
      .scan(true, (value) => !value); // FIXME: this should not default to true

  isMenuOpen
    .assign($('.main-header-menu-button'), 'toggleClass', 'active');
  isMenuOpen
    .assign($element, 'toggleClass', 'controls-open');
};
