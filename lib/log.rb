# the methods in here need to be available as both instance and class methods
# because we will want to log from within both types
module Log
  def log(desc)
    Rails.logger.debug desc
  end

  def log_around(desc = "")
    Rails.logger.debug "Starting to #{desc}"
    result = block_given? ? yield : nil
    Rails.logger.debug "Finished #{desc}"
    result
  end

  def log_around_with_result(desc = '')
    Rails.logger.debug "Starting to #{desc}"
    result = block_given? ? yield : nil
    Rails.logger.debug "Finished #{desc}"
    result_message = result ? result : "Result: nil"
    Rails.logger.debug "Result: #{result_message}"
    result
  end

  def log_before(desc = "")
    Rails.logger.debug "Starting to #{desc}"
    yield if block_given?
  end

  def log_after(desc = "")
    result = block_given? ? yield : nil
    Rails.logger.debug "Finished #{desc}"
    result
  end
end