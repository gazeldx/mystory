module LettersHelper
  def letter_body body
    raw auto_emotion(auto_link(body))
  end
end
