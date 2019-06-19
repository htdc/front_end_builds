import Route from "@ember/routing/route";

export default class PublicKeysIndexRoute extends Route {
  model() {
    return this.store.findAll('public-key');
  }
}
