class QuestionController < ApplicationController
  include QaHelper

  before_filter :require_logged_in, :except => [:get]

  def create
  end

  def get
  end

  def update
  end

  def delete
  end

  def open
  end

  def close
  end
end
