class QuestionController < ApplicationController
  before_filter :require_logged_in, :except => []

end