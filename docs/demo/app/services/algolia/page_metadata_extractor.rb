# frozen_string_literal: true

module Algolia
  # Extracts searchable records from the demo's guide and docs pages.
  #
  # Each page is rendered through the real view pipeline (the pages lean on
  # `:markdown` filters and `doc_*` helpers that a source-parse would
  # misread) and split section-by-section on its `h2` headings, so search
  # hits deep-link to the section anchors the doc-page house style already
  # provides. Text before the first `h2` becomes a page-level intro record.
  #
  # @loco_example Extract records for every guide and docs page
  #   records = Algolia::PageMetadataExtractor.new.extract_all
  #   records.first[:type] # => "doc"
  #
  class PageMetadataExtractor
    # Where pages live and how their records are tagged. Priority bases keep
    # pages ranked between component records (1..~60) and example records
    # (1000+): docs slightly above guides, since setup content answers more
    # searches.
    PAGE_SOURCES = [
      { directory: "docs", type: "doc", section: "Docs", priority_base: 500 },
      { directory: "guides", type: "guide", section: "Guides", priority_base: 700 }
    ].freeze

    # Cap section descriptions at roughly a sentence or two.
    DESCRIPTION_WORDS = 40

    # Extract records for all guide and docs pages.
    #
    # @return [Array<Hash>] Algolia records for every page section
    #
    def extract_all
      PAGE_SOURCES.flat_map { |source| extract_source(source) }
    end

    private

    # Extract records for every page in one source directory, skipping
    # partials (files starting with an underscore).
    #
    # @param source [Hash] One PAGE_SOURCES entry
    # @return [Array<Hash>] Records for all pages in the directory
    #
    def extract_source(source)
      dir = Rails.root.join("app", "views", source[:directory])
      pages = Dir.glob("*.html.haml", base: dir).sort
                 .reject { |file| File.basename(file).start_with?("_") }

      pages.each_with_index.flat_map do |file, position|
        page_id = File.basename(file, ".html.haml")
        extract_page(source, page_id, position)
      end
    end

    # Render one page and convert its sections to records.
    #
    # @param source [Hash] One PAGE_SOURCES entry
    # @param page_id [String] The page's file basename (e.g. "03_install")
    # @param position [Integer] The page's position within its directory
    # @return [Array<Hash>] One record per section (plus the intro)
    #
    def extract_page(source, page_id, position)
      html = ApplicationController.render(
        template: "#{source[:directory]}/#{page_id}",
        layout: false,
        assigns: { nav_sections: nav_sections }
      )
      body = Nokogiri::HTML(html).at("body")
      return [] if body.nil?

      page_title = body.at_css("h1")&.text&.strip.presence ||
                   page_id.sub(/\A\d+_/, "").humanize
      # The prefixed id also routes, but the nav links use the stripped form
      # — keep hit URLs canonical with it.
      url = "/#{source[:directory]}/#{page_id.sub(/\A\d+_/, '')}"

      used_ids = Set.new
      sections_for(body, page_title).each_with_index.map do |section, idx|
        # Anchor-less sections (the intro, or an h2 without an id) fall back
        # to a slug of their title, index-suffixed on collision.
        fragment = section[:anchor] || (idx.zero? ? "intro" : section[:title].parameterize)
        fragment = "#{fragment}-#{idx}" unless used_ids.add?(fragment)

        {
          type: source[:type],
          objectID: [source[:type], page_id, fragment].join("-"),
          framework: "LocoMotion",
          section: source[:section],
          component: page_title,
          title: section[:title],
          page_title: page_title,
          description: section[:description],
          url: section[:anchor] ? "#{url}##{section[:anchor]}" : url,
          priority: source[:priority_base] + (position * 20) + idx
        }
      end
    end

    # Some pages read the nav structure (e.g. the introduction counts the
    # guides), which normally comes from a `before_action` that the offline
    # renderer never runs — so build it once the same way the controller
    # does and pass it in as an assign.
    #
    # @return [Array<Hash>] The controller's nav sections
    #
    def nav_sections
      @nav_sections ||= begin
        controller = ApplicationController.new
        # Path helpers need a request; TestRequest ships in actionpack
        # itself, so this is safe outside the test env too.
        controller.set_request!(ActionDispatch::TestRequest.create)
        controller.send(:setup_nav_sections)
        controller.instance_variable_get(:@nav_sections)
      end
    end

    # Walk the rendered body in document order, splitting on `h2` headings.
    # Text before the first heading forms the intro section. Code blocks are
    # excluded so descriptions stay prose.
    #
    # @param body [Nokogiri::XML::Node] The rendered page body
    # @param page_title [String] Title used for the intro section
    # @return [Array<Hash>] Sections with :title, :anchor, and :description
    #
    def sections_for(body, page_title)
      sections = [{ title: page_title, anchor: nil, text: +"" }]

      nodes = body.xpath(
        "//h2 | //text()[not(ancestor::h1)][not(ancestor::h2)]" \
        "[not(ancestor::pre)][not(ancestor::code)]" \
        "[not(ancestor::script)][not(ancestor::style)]"
      )

      nodes.each do |node|
        if node.name == "h2"
          sections << { title: node.text.strip, anchor: node["id"], text: +"" }
        else
          sections.last[:text] << node.text
        end
      end

      sections
        .reject { |section| section[:text].squish.blank? }
        .map do |section|
          {
            title: section[:title],
            anchor: section[:anchor],
            description: section[:text].squish.split(/\s+/)
                                       .first(DESCRIPTION_WORDS).join(" ")
          }
        end
    end
  end
end
