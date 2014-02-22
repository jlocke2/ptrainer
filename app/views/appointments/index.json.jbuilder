json.array!(@appointments) do |appointment|
  json.extract! appointment, :id, :name, :description
  json.start appointment.start_at
  json.end appointment.end_at
  json.title appointment.name
  json.url appointment_url(appointment, format: :html)
end