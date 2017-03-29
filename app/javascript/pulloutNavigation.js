import { Observable } from 'rxjs/Observable'
import { map } from 'rxjs/operator/map'


$(() => {
  const toggles = Observable.create(observer => {
    $(document.body).on(
      'click',
      '[data-js-pullout-navigation-toggle]',
      (e) => observer.next(e)
    )
  })
  toggles.subscribe(::console.log)
})
