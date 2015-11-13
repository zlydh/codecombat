nock = require('nock')
nockBack = nock.back
nockBack.fixtures = 'spec/fixtures/'

module.exports.setupNock = (fixtureFilename, done) ->
  nockBack.setMode('record')
  nockBack fixtureFilename, {afterRecord: afterRecord, before: before}, (nockDone) ->
    nock.enableNetConnect('localhost')
    done(null, nockDone)
      
module.exports.teardownNock = ->
  nockBack.setMode('wild')
  nock.cleanAll()

afterRecord = (scopes) ->
  scopes = _.filter scopes, (scope) -> not _.contains(scope.scope, '//localhost:')
  return scopes
  
# payment.spec.coffee needs this, because each test creates new Users with new _ids which
# are sent to Stripe as metadata. This messes up the tests which expect inputs to be
# uniform. This scope-preprocessor makes nock ignore body for matching requests.
# Ideally we would not do this; perhaps a better system would be to figure out a way
# to create users with consistent _id values.
before = (scope) -> scope.body = (body) -> true
  
