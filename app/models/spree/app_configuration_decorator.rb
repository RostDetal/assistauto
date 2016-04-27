Spree::AppConfiguration.class_eval do
  preference :voshod_api_url, :string, :default=>'http://voshod-avto.ru.public.api.abcp.ru'
  preference :voshod_api_login, :string, :default=>''
  preference :voshod_api_pass, :string, :default=>''

  preference :yandex_api_url, :string, :default=>'http://voshod-avto.ru.public.api.abcp.ru'
  preference :yandex_api_login, :string, :default=>''
  preference :yandex_api_pass, :string, :default=>''
end