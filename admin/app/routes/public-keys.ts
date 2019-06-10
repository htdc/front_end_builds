import Route from "@ember/routing/route";

export default class PublicKeysRoute extends Route {
  model() {
    return this.store.findAll('public-key');
  }
}
