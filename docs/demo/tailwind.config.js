module.exports = {
  content: [
    '/home/loco_motion/app/components/**/*.{rb,js,html.haml}',
    '/home/loco_motion/docs/demo/components/**/*.{rb,js,html.haml}',
    '/home/loco_motion/docs/demo/app/views/**/*.{rb,js,html.haml}',
    './app/views/**/*.html.haml',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [require("@tailwindcss/typography"), require("daisyui")],
}
