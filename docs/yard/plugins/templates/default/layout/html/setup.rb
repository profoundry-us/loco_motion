def stylesheets
  super + [
    "css/highlight-11.9.0.min.css"
  ]
end

def javascripts
  super + [
    "js/highlight-11.9.0.min.js",
    "js/haml-11.9.0.min.js",
    "js/setup_highlight.js"
  ]
end
