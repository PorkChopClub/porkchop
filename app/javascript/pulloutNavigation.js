import { Observable } from 'rxjs/Observable'
import { map } from 'rxjs/operator/map'
import { scan } from 'rxjs/operator/scan'

$(() => {
  const pulloutActiveSelector = '[data-js-pullout-navigation-active]';
  const toggleSelector = '[data-js-pullout-navigation-toggle]';

  const toggles = Observable.create(observer => {
    $(document.body).on(
      'click',
      toggleSelector,
      (e) => observer.next(e)
    )
  })

  const showPullout = toggles::scan((acc) => !acc, false)

  showPullout.subscribe((isShowing) => {
    $(pulloutActiveSelector).toggleClass('pullout-navigation-active', isShowing)
  })
})
