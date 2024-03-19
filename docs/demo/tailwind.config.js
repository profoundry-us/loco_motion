module.exports = {
  content: [
    './app/views/**/*.html.haml',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [require("daisyui")],
}
