module CalendarHelper
  def custom_calendar(options = {}, &block)
    raise "calendar requires a block" unless block
    render CustomCalendar.new(self, options), &block
  end
end
