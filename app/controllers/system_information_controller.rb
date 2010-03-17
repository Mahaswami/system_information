# To change this template, choose Tools | Templates
# and open the template in the editor.

class SystemInformationController < ApplicationController

  skip_filter filter_chain
  
  before_filter :set_system_info

  def index
    render :action => :show, :layout => false
  end

  def export
    output = render_to_string :action => :show, :layout => false
    send_data output, :filename => 'system_info.html', :type => 'application/html'
  end

  private
  
  def set_system_info
    @platform = RUBY_PLATFORM
    @version = APP_VERSION rescue "Unknown"
    @environment = RAILS_ENV
    @database_vendor = mysql? ? "MySQL" : oracle? ? "Oracle" : "Unknown"
    if mysql?
      database = Rails.configuration.database_configuration[RAILS_ENV]["database"]
      host = Rails.configuration.database_configuration[RAILS_ENV]["host"]
      @database = "#{database}@#{host}"
    elsif oracle?
      database = Rails.configuration.database_configuration[RAILS_ENV]["database"]
      user = Rails.configuration.database_configuration[RAILS_ENV]["username"]
      @database = "User = #{user}; TNS Name = #{database}"
    else
      @database = "Unknown"
    end
    @jndi = Rails.configuration.database_configuration[RAILS_ENV]["jndi"]
    unless @jndi.blank?
      @database = Rails.configuration.database_configuration[RAILS_ENV]["driver"]
    end
    if RUBY_PLATFORM =~/java/
      @java_vendor = Java.java.lang.System.getProperty("java.vendor")
      @java_version = Java.java.lang.System.getProperty("java.version")
    end
  end
end
