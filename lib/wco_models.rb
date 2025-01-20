
require 'aws-sdk-s3'

require 'business_time'

require 'cancancan'

require 'devise'

require 'haml'
require 'httparty'

require 'kaminari/mongoid'
require 'kaminari/actionview'

require 'mail'
require 'mongoid'
require 'mongoid_paranoia'

require "omniauth-keycloak"

# require 'select2-rails'
require 'sass-rails'
require 'stripe'

require "wco/engine"
require 'wco/ai_writer'

ACTIVE   = 'active'
INACTIVE = 'inactive'
STATUSES = [ nil, ACTIVE, INACTIVE ]

module Wco; end

module WcoEmail
  ACTION_ADD_TAG    = 'add-tag'
  ACTION_AUTORESPOND = 'autorespond-template'
  ACTION_REMOVE_TAG = 'remove-tag'

  FIELD_BODY    = 'body'
  FIELD_EXE     = 'exe'
  FIELD_FROM    = 'from'
  FIELD_LEADSET = 'leadset'
  FIELD_SUBJECT = 'subject'
  FIELD_TO      = 'to'

  OPERATOR_EQUALS      = 'equals'
  OPERATOR_HAS_TAG     = 'has-tag'
  OPERATOR_NOT_HAS_TAG = 'not-has-tag'
end

module WcoHosting; end

class Wco::HTTParty
  include HTTParty
  debug_output STDOUT
end

ActiveSupport.escape_html_entities_in_json = true
