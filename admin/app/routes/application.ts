import Route from "@ember/routing/route";

export default class ApplicationRoute extends Route {
  model() {
    return this.store.findRecord('host-app', 'current');
  }
}
