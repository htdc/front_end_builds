import EmberRouter from "@ember/routing/router";
import config from "./config/environment";

const Router = EmberRouter.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
  this.route('apps', { path: '/' });
  this.route('app', { path: '/apps/:app_id'});
  this.route('pubkeys', { path: '/ssh-keys'});
});

export default Router;
