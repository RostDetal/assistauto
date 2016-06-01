# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
sortBy = (key, a, b)->
  r = if r then 1 else -1
  return -1 * r if a[key] > b[key]
  return +1 * r if a[key] < b[key]
  return 0

delivery = (time) ->
  deliveryT = ""
  days = time/24
  return deliveryT = "Несколько часов" if days == 0
  return deliveryT = "24 часа" if days == 1
  return deliveryT = "2 дня" if days == 2
  return deliveryT = "В течение #{days} дней" if days > 2




Spree.check_partner_price = (pid) ->
  params = {p_id: pid}
  $.ajax
    url: '/analogs'
    type: 'GET'
    crossDomain: true
    data: params
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": "X-Requested-With, X-Prototype-Version, Token",
      "Access-Control-Allow-Methods": "POST, GET, PUT, DELETE, OPTIONS",
      "Access-Control-Max-Age": "1728000"
    },
    xhrFields: {
      withCredentials: true
    }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(textStatus)
    success: (data, textStatus, jqXHR) ->
      table = document.getElementById("analogs-table")
      spinner = document.getElementById("analogs-spinner")
      spinner.remove()

      console.log(data)
      table.removeAttribute('style')
      data.sort (a, b) ->
        sortBy('deliveryPeriod', a, b) or
        sortBy('price', a, b)

      for analog in data
        rowsCount = table.rows.length
        row = table.insertRow(rowsCount);

        row.setAttribute('class',"success") if analog["deliveryPeriod"]==0
        row.setAttribute('id', rowsCount)
        cell1 = row.insertCell(0);
        cell2 = row.insertCell(1);
        cell3 = row.insertCell(2);
        cell4 = row.insertCell(3);
        cell5 = row.insertCell(4);
        cell6 = row.insertCell(5);
        cell1.innerHTML = analog["brand"];
        cell2.innerHTML = analog["numberFix"];
        cell3.innerHTML = analog["availability"];
        cell3.setAttribute('class','hidden-xs')
        cell4.innerHTML = delivery(analog["deliveryPeriod"]);
        cell4.setAttribute('class','hidden-xs')
        cell5.innerHTML = analog["price"]+" ₽";
        cell5.setAttribute("id", "price")
        cell6.innerHTML = '<button type="submit"></button>'
      data = null