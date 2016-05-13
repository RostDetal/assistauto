# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


Spree.check_partner_price = (sku, host, l, p) ->
  console.log("WORK: "+sku)
  console.log("WORK: "+host)
#  invocation = new XMLHttpRequest()
#  handler = -> console.log(invocation.responseText)
#  if invocation
#    invocation.open('GET', host, true);
#    invocation.onload = handler;
#    invocation.send()
#



#  params = {userlogin: l, brand:"AMTEL", number:sku, userpsw: p}
#  $.get(host, params, (response)->
#    console.log(response)
#  , "json")

#  $.ajax
#    url: host
#    type: 'GET'
#    crossDomain: true
#    data: params
#    headers: {"Access-Control-Allow-Origin": "*", "Access-Control-Allow-Headers":"X-Requested-With, X-Prototype-Version, Token", "Access-Control-Allow-Methods":"POST, GET, PUT, DELETE, OPTIONS", "Access-Control-Max-Age":"1728000"},
#    xhrFields: {
#      withCredentials: true
#    }
#    dataType: 'application/json'
#    error: (jqXHR, textStatus, errorThrown) ->
#      console.log(textStatus)
#    success: (data, textStatus, jqXHR) ->
#      console.log(data)






