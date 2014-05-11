class VoteController < ApplicationController
  before_filter :require_logged_in, :except => []

end