require "powerapi/exception.rb"
require "powerapi/parser.rb"
require "powerapi/version.rb"

require "powerapi/assignment.rb"
require "powerapi/section.rb"
require "powerapi/student.rb"

require "savon"
require "json"

module PowerAPI
  module_function

  def authenticate(url, username, password, fetch_transcript=true)
    if url[-1] == "/"
      url = url[0..-2]
    else
      url = url
    end

    soap_endpoint = url + "/pearson-rest/services/PublicPortalService"

    login_client = Savon.client(
      endpoint: soap_endpoint,
      namespace: "http://publicportal.rest.powerschool.pearson.com/xsd",
      wsse_auth: ["pearson", "pearson"]
    )

    login = login_client.call(:login, message: { username: username, password: password, userType: 2} )

    if login.body[:login_response][:return][:user_session_vo] == nil
      raise PowerAPI::Exception.new(login.body[:login_response][:return][:message_v_os][:description])
    end

    session = login.body[:login_response][:return][:user_session_vo]

    return PowerAPI::Student.new(url, session, fetch_transcript)
  end
end
