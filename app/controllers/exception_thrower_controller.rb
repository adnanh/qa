class ExceptionThrowerController < ApplicationController
  soap_service namespace: 'urn:WashOut'

  # basic datatype passing
  soap_action 'multiply_two_integers',
              :args => {:a => :integer, :b => :integer },
              :return => :integer
  def multiply_two_integers
    render :soap => (params[:a] * params[:b])
  end

  # basic array passing
  # exemplarum:
  # <?xml version="1.0" encoding="utf-8"?>
  #    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  # <soap:Body>
  # <sum_vector xmlns="urn:WashOut">
  # <vector> <element> 50 </element> <element> 70 </element> </vector>
	#		</sum_vector>
  # </soap:Body>
	# </soap:Envelope>
  soap_action 'sum_vector',
              :args => { :vector => { :element => [:integer]}},
              :return => :integer
  def sum_vector
    sum = 0
    params[:vector][:element].each {
      |a|
      sum+=a
    }
    render :soap => sum
  end

  # complex datatype passing (array of custom objects)
  # shall require custom request bodies
  soap_action 'add_points',
              :args => {:points => { :point => [{ :x => :integer, :y => :integer }]}},
              :return => { :xsum => :integer, :ysum => :integer}
  def add_points
    render :soap => { :xsum => 5, :ysum => 10}
  end

  #TODO: try out type definition
end
