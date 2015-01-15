/* global jQuery  */
import Pretender from 'pretender';

import hostApp from './data/hostApp';
import apps from './data/apps';
import builds from './data/builds';

var stubData = {
  hostApp: hostApp,
  apps: apps,
  builds: builds,
};

// by default allow logging in
stubData.validLogin = true;

stubData.currentUser = {
  email: "sam.selikoff@gmail.com",
  firstname: "Sam",
  id: "current",
  lastname: "Selikoff"
};

var config = function() {
  var _this = this;

  this.prepareBody = function(body){
    return body ? JSON.stringify(body) : '{"error": "not found"}';
  }

  this.stubUrl = function(verb, url, data) {
    this[verb].call(this, '/api' + url, function(request) {
      console.log('Hitting ' + url);
      console.log(data);
      return [200, {}, data];
    });
  }.bind(this);

  this.unhandledRequest = function(verb, path, request) {
    console.error("FAILED REQUEST");
    console.error(verb, path);
  };

  this.setupGlobalRoutes = function(data) {
    var _this = this;

    this.stubUrl('get', '/host_apps/current', {
      host_app: data.hostApp
    });

    this.stubUrl('get', '/apps', {
      apps: data.apps,
      builds: data.builds
    });

    this.get('/api/apps/:id', function(request) {
      var id = +request.params.id;
      var app = data.apps.findBy('id', id);
      var builds = data.builds.findBy('app_id', id);

      var response = {
        app: app,
        builds: builds
      };

      return [200, {}, response];
    });

    this.stubUrl('post', '/apps', {});

    this.delete('/api/apps/:id', function(request) {
      var appId = +request.params.id;
      data.apps = data.apps.rejectBy('id', appId);
      data.builds = data.builds.rejectBy('app_id', appId);

      _this.setupGlobalRoutes.call(_this, data);

      return [204, {}];
    });

  }.bind(this);

  this.resetGlobalRoutes = function() {
    var data = jQuery.extend(true, {}, stubData); // Make sure we have a copy

    this.setupGlobalRoutes(data);
  };

  this.resetGlobalRoutes();
};

export default {
  initialize: function() {
    return new Pretender(config);
  }
};