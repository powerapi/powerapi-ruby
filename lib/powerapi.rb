require "powerapi/exception.rb"
require "powerapi/parser.rb"
require "powerapi/version.rb"

require "powerapi/data/assignment.rb"
require "powerapi/data/section.rb"
require "powerapi/data/student.rb"

require "savon"
require "json"

module PowerAPI
  module_function

  def authenticate(url, username, password, fetch_transcript=true)
    url = clean_url(url)

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

    return PowerAPI::Data::Student.new(url, session, fetch_transcript)
  end

  def clean_url(url)
    if url[-1] == "/"
      url = url[0..-2]
    else
      url = url
    end
  end

  def district_lookup(code)
    request = HTTPI::Request.new("https://powersource.pearsonschoolsystems.com/services/rest/remote-device/v2/get-district/" + code)
    request.headers = { "Accept" => "application/json" }

    details = HTTPI.get(request)

    if details.error?
      return false
    end

    details = JSON.parse(details.body)

    district_lookup_url(details["district"]["server"])
  end

  def district_lookup_url(district_server)
    if district_server["sslEnabled"] == true
      url = "https://"
    else
      url = 'http://'
    end

    url += district_server["serverAddress"]

    if (district_server["sslEnabled"] == true and district_server["portNumber"] != 443) or
        (district_server["sslEnabled"] == false and district_server["portNumber"] != 80)

        url += ":" + district_server["portNumber"].to_s
    end

    url
  end
end
