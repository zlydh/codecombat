nock = require('nock')
nockBack = nock.back
nockBack.fixtures = 'spec/fixtures/'

module.exports.setupNock = (fixtureFilename, done) ->
  nockBack.setMode('record')
  nockBack fixtureFilename, {afterRecord: afterRecord}, (nockDone) ->
    nock.enableNetConnect('localhost')
    done(null, nockDone)
      
module.exports.teardownNock = ->
  nockBack.setMode('wild')
  nock.cleanAll()

afterRecord = (scopes) ->
  scopes = _.filter scopes, (scope) -> not _.contains(scope.scope, '//localhost:')
  return scopes
  
