module ApplicationHelper
  def order_status_badge_class(status)
    case status.to_s.downcase
    when "pending"   then "bg-warning text-dark"
    when "preparing" then "bg-info text-dark" # หรือ 'bg-primary text-white'
    when "completed" then "bg-success text-white"
    when "cancelled" then "bg-danger text-white"
    else "bg-secondary text-white"
    end
  end
end
