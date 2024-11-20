class TailwindAsAServiceController < ApplicationController
  require 'open3'
  require 'tempfile'

  skip_before_action :verify_authenticity_token # For API endpoints (adjust as needed)

  INPUT_CSS_PATH = Rails.root.join('app/assets/taas/taas.tailwind.css')
  CONFIG_PATH = Rails.root.join('app/assets/taas/taas.config.js')

  def generate
    # Raw POST body with HTML input
    html_content = request.raw_post.force_encoding('UTF-8').scrub

    Tempfile.create(['input', '.html']) do |temp_html|
      Tempfile.create(['output', '.css']) do |temp_output|
        begin
          # Write HTML content to temp file
          temp_html.write(html_content)
          temp_html.flush

          command = "npx tailwindcss --config #{CONFIG_PATH} -i #{INPUT_CSS_PATH} -o #{temp_output.path} --minify --content #{temp_html.path}"

          # Execute Tailwind CLI
          stdout, stderr, status = Open3.capture3(command)

          if status.success?
            render plain: File.read(temp_output.path), content_type: 'text/css'
          else
            render json: { error: stderr }, status: :unprocessable_entity
          end
        rescue => e
          render json: { error: e.message }, status: :internal_server_error
        end
      end
    end
  end
end
