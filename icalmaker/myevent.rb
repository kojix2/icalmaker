require 'icalendar'

module ICalMaker
  class MyEvent < Struct.new(:name, :start_time, :end_time, :location, :description)
    def ready?
      msg = String.new
      %i[name start_time end_time].each do |k|
        msg << "* The #{k} field is required.\n" if self[k].nil?
      end
      msg
    end

    def to_ical
      cal = Icalendar::Calendar.new
      cal.prodid = 'iCalMaker'
      cal.event do |e|
        e.summary = name
        e.dtstart = DateTime.civil(
          *start_time.values_at(*%i[year mon mday hour min sec])
        )
        e.dtend = DateTime.civil(
          *end_time.values_at(*%i[year mon mday hour min sec])
        )
        e.description = description
      end
      cal.publish
      cal.to_ical
    end

    def clear
      members.each do |n|
        self[n] = nil
      end
    end
  end
end
