const { execSync } = require('child_process');

// Get the path to the loco_motion gem
let locoBundlePath = execSync('bundle show loco_motion-rails').toString().trim();

console.log(" *** Importing LocoMotion gem Components into Tailwind: ", locoBundlePath);

module.exports = {
  content: [
    `${locoBundlePath}/app/components/**/*.{rb,js,html,haml}`,
    'app/components/**/*.{rb,js,html,haml}',
    'app/views/**/*.{rb,js,html,haml}',
  ]
}
