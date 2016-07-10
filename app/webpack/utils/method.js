import $ from 'jquery'

$(document).on('click', 'a[data-method]', function(event) {
  const element = $(this)
  if (element.is('a[data-remote]')) { return }
  const method = element.attr('data-method').toLowerCase()
  if (method === 'get') { return }
  const form = document.createElement('form')
  form.method = 'POST'
  form.action = element.attr('href')
  form.style.display = 'none'
  if (method !== 'post') {
    const input = document.createElement('input')
    input.setAttribute('type', 'hidden')
    input.setAttribute('name', '_method')
    input.setAttribute('value', method)
    form.appendChild(input)
  }

  const authToken = document.createElement('input')
  authToken.setAttribute('type', 'hidden')
  authToken.setAttribute('name', $('meta[name="csrf-param"]').attr('content'))
  authToken.setAttribute('value', $('meta[name="csrf-token"]').attr('content'))
  form.appendChild(authToken)

  document.body.appendChild(form)
  $(form).submit()
  event.preventDefault()
  return false
})
