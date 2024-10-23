import { Application } from "@hotwired/stimulus"

import { CountdownController } from "@profoundry-us/loco_motion"

const application = Application.start()

application.register("countdown", CountdownController)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
