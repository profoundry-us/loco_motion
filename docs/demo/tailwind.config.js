const { execSync } = require('child_process');

let locoBundlePath = execSync('bundle show loco_motion').toString().trim();

console.log(" *** Importing TailwindCSS config from loco_motion gem: ", locoBundlePath);

module.exports = {
  content: [
    `${locoBundlePath}/app/components/**/*.{rb,js,html.haml}`,
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
