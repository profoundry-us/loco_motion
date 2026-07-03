# frozen_string_literal: true

require "rails_helper"
require "tmpdir"
require "fileutils"

RSpec.describe LocoMotion::Migrations::LeadingTrailing do
  around do |example|
    Dir.mktmpdir do |dir|
      @root = dir
      example.run
    end
  end

  def write(name, contents)
    path = File.join(@root, name)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, contents)
  end

  def read(name)
    File.read(File.join(@root, name))
  end

  def run_migration(apply: true)
    described_class.new(root: @root, apply: apply).run
  end

  describe "keyword arguments" do
    it "renames start:/end: on labelable helper calls" do
      write("app/views/a.haml", <<~HAML)
        = daisy_text_input(name: "username", start: "Username:")
        = daisy_checkbox(name: "terms", id: "terms", end: "I agree")
        = daisy_toggle(end: "Enable Feature X")
        = daisy_radio(name: "one", value: "1", end: "Radio one")
      HAML

      run_migration

      expect(read("app/views/a.haml")).to eq(<<~HAML)
        = daisy_text_input(name: "username", leading: "Username:")
        = daisy_checkbox(name: "terms", id: "terms", trailing: "I agree")
        = daisy_toggle(trailing: "Enable Feature X")
        = daisy_radio(name: "one", value: "1", trailing: "Radio one")
      HAML
    end

    it "renames the generated part options (css/html/aria/data)" do
      write("app/views/b.haml", <<~HAML)
        = daisy_select(name: "c", start: "Country", start_css: "font-bold", end_html: { id: "x" })
        = daisy_checkbox(name: "t", end: "Agree", start_aria: { hidden: true }, end_data: { foo: "bar" })
      HAML

      run_migration

      expect(read("app/views/b.haml")).to eq(<<~HAML)
        = daisy_select(name: "c", leading: "Country", leading_css: "font-bold", trailing_html: { id: "x" })
        = daisy_checkbox(name: "t", trailing: "Agree", leading_aria: { hidden: true }, trailing_data: { foo: "bar" })
      HAML
    end

    it "renames hash-rocket keys" do
      write("app/views/c.haml", <<~HAML)
        = daisy_checkbox(name: "t", :end => "I agree")
      HAML

      run_migration

      expect(read("app/views/c.haml"))
        .to eq("= daisy_checkbox(name: \"t\", :trailing => \"I agree\")\n")
    end

    it "renames options on form builder calls" do
      write("app/views/d.erb", <<~ERB)
        <%= form.daisy_cally_input(:start_date, start: "Start Date") %>
        <%= form.daisy_checkbox(:newsletter, toggle: true, end: "Subscribe") %>
      ERB

      run_migration

      expect(read("app/views/d.erb")).to eq(<<~ERB)
        <%= form.daisy_cally_input(:start_date, leading: "Start Date") %>
        <%= form.daisy_checkbox(:newsletter, toggle: true, trailing: "Subscribe") %>
      ERB
    end

    it "renames options across multi-line calls" do
      write("app/views/e.haml", <<~HAML)
        = daisy_text_input(name: "email",
            start: "Email:",
            end: "@example.com")
        = daisy_checkbox name: "terms",
            end: "I agree"
      HAML

      run_migration

      expect(read("app/views/e.haml")).to eq(<<~HAML)
        = daisy_text_input(name: "email",
            leading: "Email:",
            trailing: "@example.com")
        = daisy_checkbox name: "terms",
            trailing: "I agree"
      HAML
    end

    it "leaves other symbols, strings, and unrelated calls alone" do
      write("app/views/f.haml", <<~HAML)
        = daisy_checkbox(name: "checkbox_end", id: "checkbox_end", value: "end")
        = link_to "Go", some_path(start: 1, end: 10)
        - range = { start: 0, end: 5 }
      HAML

      run_migration

      expect(read("app/views/f.haml")).to eq(<<~HAML)
        = daisy_checkbox(name: "checkbox_end", id: "checkbox_end", value: "end")
        = link_to "Go", some_path(start: 1, end: 10)
        - range = { start: 0, end: 5 }
      HAML
    end
  end

  describe "slot calls" do
    it "renames with_start/with_end on labelable block variables" do
      write("app/views/g.haml", <<~HAML)
        = daisy_text_input(name: "password") do |input|
          - input.with_start do
            Password
          - input.with_end(css: "flex items-center") do
            = loco_icon("eye")
      HAML

      run_migration

      expect(read("app/views/g.haml")).to eq(<<~HAML)
        = daisy_text_input(name: "password") do |input|
          - input.with_leading do
            Password
          - input.with_trailing(css: "flex items-center") do
            = loco_icon("eye")
      HAML
    end

    it "renames slots inside build_radio_input blocks" do
      write("app/views/h.haml", <<~HAML)
        = daisy_theme_controller do |tc|
          = tc.build_radio_input(theme: "dark") do |radio|
            - radio.with_end(css: "flex items-center gap-2") do
              Dark Mode
      HAML

      run_migration

      expect(read("app/views/h.haml")).to eq(<<~HAML)
        = daisy_theme_controller do |tc|
          = tc.build_radio_input(theme: "dark") do |radio|
            - radio.with_trailing(css: "flex items-center gap-2") do
              Dark Mode
      HAML
    end

    it "stops renaming once the block closes" do
      write("app/views/i.haml", <<~HAML)
        = daisy_checkbox(name: "a") do |item|
          - item.with_end do
            Agree
        = my_custom_widget do |item|
          - item.with_end do
            Menu
      HAML

      run_migration

      expect(read("app/views/i.haml")).to eq(<<~HAML)
        = daisy_checkbox(name: "a") do |item|
          - item.with_trailing do
            Agree
        = my_custom_widget do |item|
          - item.with_end do
            Menu
      HAML
    end

    it "renames navbar slots" do
      write("app/views/n.haml", <<~HAML)
        = daisy_navbar(css: "bg-base-100") do |navbar|
          - navbar.with_start(css: "gap-2") do
            Logo
          - navbar.with_center do
            Search
          - navbar.with_end do
            Menu
      HAML

      run_migration

      expect(read("app/views/n.haml")).to eq(<<~HAML)
        = daisy_navbar(css: "bg-base-100") do |navbar|
          - navbar.with_leading(css: "gap-2") do
            Logo
          - navbar.with_center do
            Search
          - navbar.with_trailing do
            Menu
      HAML
    end

    it "renames timeline event options and slots via with_event" do
      write("app/views/t.haml", <<~HAML)
        = daisy_timeline do |timeline|
          - timeline.with_event(start: "1985", middle_icon: "user-circle", end: "Born")
          - timeline.with_event do |event|
            - event.with_start(css: "font-bold") do
              1985
            - event.with_end(css: "timeline-box") do
              Born
      HAML

      run_migration

      expect(read("app/views/t.haml")).to eq(<<~HAML)
        = daisy_timeline do |timeline|
          - timeline.with_event(leading: "1985", middle_icon: "user-circle", trailing: "Born")
          - timeline.with_event do |event|
            - event.with_leading(css: "font-bold") do
              1985
            - event.with_trailing(css: "timeline-box") do
              Born
      HAML
    end

    it "renames slots in ERB blocks" do
      write("app/views/j.erb", <<~ERB)
        <%= daisy_checkbox(name: "terms") do |cb| %>
          <% cb.with_end do %>
            I agree
          <% end %>
        <% end %>
      ERB

      run_migration

      expect(read("app/views/j.erb")).to include("cb.with_trailing do")
    end
  end

  describe "leftovers" do
    it "leaves unrecognized components' slots alone and reports them for review" do
      write("app/views/k.haml", <<~HAML)
        = my_sidebar do |sidebar|
          - sidebar.with_start do
            Logo
          - sidebar.with_end do
            Menu
      HAML

      migration = run_migration

      expect(read("app/views/k.haml")).to include("sidebar.with_start")
      expect(read("app/views/k.haml")).to include("sidebar.with_end")
      expect(migration.leftovers.map { |l| l[:line] }).to contain_exactly(2, 4)
    end
  end

  describe "dry run and change reporting" do
    it "does not write files unless apply is set" do
      original = "= daisy_checkbox(name: \"terms\", end: \"I agree\")\n"
      write("app/views/l.haml", original)

      migration = run_migration(apply: false)

      expect(read("app/views/l.haml")).to eq(original)
      expect(migration.changes).to contain_exactly(
        hash_including(
          file: "app/views/l.haml",
          line: 1,
          before: "= daisy_checkbox(name: \"terms\", end: \"I agree\")",
          after: "= daisy_checkbox(name: \"terms\", trailing: \"I agree\")"
        )
      )
    end
  end
end
