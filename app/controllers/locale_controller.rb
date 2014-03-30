class LocaleController < ApplicationController

  # gets locale, either from current session or from browser settings
  # could be extended to store custom user setting ...
  def get
    if session[:locale].nil?
      available = %w(en bs)
      chosen = http_accept_language.compatible_language_from(available)
      # if nuthin', load engrish
      if chosen.nil?
        session[:locale] = 'en'
        render :json => reply(true,'Invalid value specified - using engrish','locale','en')
      else
        session[:locale] = chosen
        render :json => reply(true,'','locale',chosen)
      end
    else
      render :json => reply(true,'','locale',session[:locale])

    end
  end

  # changes the locale in session
  # could be extended to store custom user setting in db ...
  def set
    new_locale = params[:locale]
    if new_locale.nil? || !new_locale.in?(%w(en bs))
      session[:locale] = 'en'
    else
      session[:locale] = new_locale
    end
    render :json => reply(true,'')
  end
end
