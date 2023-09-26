class NotificationService
  def initialize(answer)
    @answer = answer
  end

  def send_notification
    @question = @answer.question
    @question.subscriptions.find_each(batch_size: 500) do |subscribe|
      NotificationMailer.notification(subscribe.user, @answer).deliver_later
    end
  end
end
