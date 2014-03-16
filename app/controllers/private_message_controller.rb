class PrivateMessageController < ApplicationController
  before_filter :require_logged_in, :except => []

  def create
    respond_to do |format|
      format.json {


      }
    end
  end

  def delete
    respond_to do |format|
      format.json {


      }
    end
  end

  def inbox
    respond_to do |format|
      format.json {


      }
    end
  end

  def outbox
    respond_to do |format|
      format.json {


      }
    end
  end

  def get
    respond_to do |format|
      format.json {


      }
    end
  end

  def check
    respond_to do |format|
      format.json {


      }
    end
  end
end
