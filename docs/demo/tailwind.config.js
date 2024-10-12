module.exports = {
  content: [
    '/home/loco_motion/app/components/**/*.{rb,js,html.haml}',
    './app/components/**/*.{rb,js,html.haml}',
    './app/views/**/*.{rb,js,html.haml}',
    './app/views/**/*.html.haml',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  daisyui: {
    themes: ["light", "dark", "synthwave", "retro", "cyberpunk", "wireframe"],
  },
  plugins: [require("@tailwindcss/typography"), require("daisyui")],
}
