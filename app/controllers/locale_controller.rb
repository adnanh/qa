class LocaleController < ApplicationController

  # abstracts getting current locale
  def get
    # if nothing was specified
    if cookies[:locale].nil?
      # these two are the only ones allowed
      available = %w(en bs)
      # try to read browser defaults
      chosen = http_accept_language.compatible_language_from(available)
      # if nuthin', load engrish
      if chosen.nil?
        cookies[:locale] = { :value => 'en', :expires => 1.year.from_now }
        session[:locale] = 'en'
        render :json => reply(true,'Invalid value specified - using engrish','locale','en')
      else
        cookies[:locale] = { :value => chosen, :expires => 1.year.from_now }
        session[:locale] = chosen
        render :json => reply(true,'','locale',chosen)
      end
    else
      render :json => reply(true,'','locale',cookies[:locale])

    end
  end

  # abstracts setting current locale
  def set
    new_locale = params[:locale]
    if new_locale.nil? || !new_locale.in?(%w(en bs))
      cookies[:locale] = { :value => 'en', :expires => 1.year.from_now }
      session[:locale] = 'en'
    else
      cookies[:locale] = { :value => new_locale, :expires => 1.year.from_now }
      session[:locale] = new_locale
    end
    render :json => reply(true,'')
  end
end
