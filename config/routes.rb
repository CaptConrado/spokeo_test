Spokeo::Application.routes.draw do
  get "static_page/display"

  get "star/crawl"


   match '/' => 'star#display'
end
