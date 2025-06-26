class Api::V1::BaseController < ApplicationController
  include Authenticable

  before_action :authenticate!
end
