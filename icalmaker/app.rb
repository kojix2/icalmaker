require_relative 'myevent'
require_relative 'version'

module ICalMaker
  class App
    include Glimmer::LibUI::Application

    before_body do
      @event = MyEvent.new
    end

    body do
      menu('File') do
        menu_item('Clear') do
          on_clicked { @event.clear }
        end
        menu_item('Save') do
          on_clicked { save_ical_file }
        end
        quit_menu_item
      end
      menu('Help') do
        about_menu_item do
          on_clicked do
            message_box(
              "iCalMaker #{ICalMaker::VERSION}",
              <<~EOF
                iCalMaker is a simple iCalendar event generator.
                Author: @kojix2.
                GUI: Glimmer DSL for LibUI
              EOF
            )
          end
        end
      end
      window('iCalMaker') do
        margined true

        vertical_box do
          form do
            entry do
              stretchy false
              label 'MyEvent Name'
              text <=> [@event, :name]
            end
            date_time_picker do
              stretchy false
              label 'Start Time'
              time <=> [@event, :start_time]
            end
            date_time_picker do
              stretchy false
              label 'End Time'
              time <=> [@event, :end_time]
            end
            entry do
              stretchy false
              label 'Location'
              text <=> [@event, :location]
            end
            multiline_entry do
              label 'Description'
              text <=> [@event, :description]
            end
          end
          horizontal_box do
            stretchy false
            label('') # Space
            button('Clear') do
              stretchy false
              on_clicked { @event.clear }
            end
            button('Save') do
              stretchy false
              on_clicked { save_ical_file }
            end
          end
        end
      end
    end

    def save_ical_file
      msg = @event.ready?
      unless msg.empty?
        message_box_error('Please check the form again', msg)
        return false
      end
      path = save_file
      return false if path.nil?

      str = @event.to_ical
      File.write(path, str)
    rescue StandardError => e
      message_box_error('Error saving file', e.message)
      false
    end
  end
end
