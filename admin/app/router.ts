import EmberRouter from "@ember/routing/router";
import config from "./config/environment";

const Router = EmberRouter.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
  this.route('apps', { path: '/' }, function () {
    this.route('show', { path: '/apps/:app_id'});
    this.route('new');
  });
  this.route('pubkeys', { path: '/ssh-keys'});
});

export default Router;
