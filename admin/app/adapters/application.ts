import ActiveModelAdapater from 'active-model-adapter';

export default class ApplicationAdapter extends ActiveModelAdapater {

}


// DO NOT DELETE: this is how TypeScript knows how to look up your adapters.
declare module 'ember-data/types/registries/adapter' {
  export default interface AdapterRegistry {
    'application': ApplicationAdapter;
  }
}
