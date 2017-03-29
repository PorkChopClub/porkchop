import { Observable } from 'rxjs/Observable'
import { map } from 'rxjs/operator/map'
import { scan } from 'rxjs/operator/scan'

$(() => {
  const pulloutSelector = '[data-js-pullout-navigation]';
  const toggleSelector = '[data-js-pullout-navigation-toggle]';

  const toggles = Observable.create(observer => {
    $(document.body).on(
      'click',
      toggleSelector,
      (e) => observer.next(e)
    )
  })

  const showPullout = toggles::scan((acc) => !acc, false)

  showPullout.subscribe((isShowing) =>
    $(pulloutSelector).toggleClass('active', isShowing))
})
