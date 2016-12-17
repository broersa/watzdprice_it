/* eslint-env node, mocha */
var chai = require('chai');
// var assert = chai.assert;
var expect = chai.expect;
var sinon = require('sinon');
var watzdprice = require('watzdprice');
var moment = require('moment');
var config = require('config');

describe('index', function () {
  var sandbox;

  beforeEach(function () {
    // Create a sandbox for the test
    sandbox = sinon.sandbox.create();
  });

  afterEach(function () {
    // Restore all the things made through the sandbox
    sandbox.restore();
  });

  it('should run', function (done) {
    watzdprice.startSession(config.elastic_url, function (error, client) {
      expect(error).to.be.null;
      watzdprice.updateProduct(client, config.elastic_index, moment(), {
        name: 'Andre Broers',
        url: 'http://www.bekijkhet.com'
      }, function (error) {
        expect(error).to.be.undefined;
        done();
      });
    });
  });

  it('should run', function (done) {
    watzdprice.startSession(config.elastic_url, function (error, client) {
      expect(error).to.be.null;
      watzdprice.updateProduct(client, config.elastic_index, moment(), {
        name: 'Andre Broers',
        url: 'http://www.bekijkhet.com'
      }, function (error) {
        expect(error).to.be.undefined;
        done();
      });
    });
  });

  it('should run', function (done) {
    watzdprice.updateProduct(moment(), {
      name: 'Andre Broersx',
      url: 'http://www.bekijkhet.com'
    }, function (error, result) {
      console.log('!!!!!!!!!!!!!');
      console.log(error);
      console.log('!!!!!!!!!!!!!');
      console.log(result);
      console.log('!!!!!!!!!!!!!');
      expect(error).not.to.be.null;
      done();
    });
  });

  it('should run', function (done) {
    watzdprice.findProducts('broers', function (error, result) {
      console.log('!!!!!!!!!!!!!');
      console.log(error);
      console.log('!!!!!!!!!!!!!');
      console.log(result);
      console.log('!!!!!!!!!!!!!');
      expect(error).not.to.be.null;
      done();
    });
  });
});
