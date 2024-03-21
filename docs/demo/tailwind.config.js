module.exports = {
  // TODO: Figure out how to get dynamically generated classes (like
  // btn-primary) into Tailwind...
  content: [
    '/home/loco_motion/app/components/**/*.{rb,js,html.haml}',
    './app/views/**/*.html.haml',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [require("daisyui")],
}
