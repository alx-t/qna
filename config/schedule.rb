every 1.day, at: '9:30 am' do
  runner "DailyDigestJob.perform_later"
end

every 60.minutes do
  rake "ts:index"
end

